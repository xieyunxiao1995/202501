import assert from "node:assert/strict";
import worker from "./worker.js";
import { STORY_CANON } from "./storyCanon.js";
import { CHARACTERS } from "./characters.js";

assert.equal(Object.keys(CHARACTERS).length, 40);
assert.equal(Object.keys(STORY_CANON).length, 40);
assert.equal(Object.values(STORY_CANON).reduce((count, story) => count + story.chapters.length, 0), 328);
assert.equal(STORY_CANON.mira.chapters.length, 10);
assert.equal(STORY_CANON.mira.chapters[7].id, "mira_c8");
assert.equal(Object.keys(STORY_CANON.mira.chapters[7].choices).length, 2);
assert.equal(STORY_CANON.sylvie.chapters.length, 8);
assert.equal(STORY_CANON.sylvie.chapters[7].id, "sylvie_c8");
assert.equal(Object.keys(STORY_CANON.sylvie.chapters[7].choices).length, 2);
assert.equal(STORY_CANON.noel.chapters.length, 8);

let providerRequests = 0;
let providerText = "The letter carries a familiar blue seal.";
const liveFetch = globalThis.fetch;
globalThis.fetch = async (url, options) => {
  providerRequests++;
  assert.equal(String(url), "https://ark.cn-beijing.volces.com/api/v3/responses");
  const providerBody = JSON.parse(options.body);
  assert.equal(providerBody.model, "doubao-seed-character-260628");
  assert.equal(providerBody.store, false);
  assert.equal(providerBody.stream, false);
  assert.match(providerBody.instructions, /Mira Vale/);
  assert.match(providerBody.instructions, /rejected correction slip/);
  assert.match(providerBody.instructions, /\[\[choice:CHOICE_ID\]\]/);
  assert.equal(providerBody.input[0].role, "user");
  const serialized = JSON.stringify(providerBody.input);
  assert.match(serialized, /The Atlas of Lost Letters/);
  assert.match(serialized, /Chapter objective/);
  assert.equal(options.headers.authorization, "Bearer mocked-secret-never-in-client");
  return new Response(JSON.stringify({output:[{type:"message",role:"assistant",content:[{type:"output_text",text:providerText}]}]}),
    {status:200,headers:{"content-type":"application/json"}});
};
const env = { ARK_API_KEY: "mocked-secret-never-in-client", REQUEST_LIMITER: {limit: async () => ({success:true})} };
function request(body) {
  return new Request("https://tideverse.invalid/v1/chat", {method:"POST",headers:{"Content-Type":"application/json","CF-Connecting-IP":"192.0.2.100"},body:JSON.stringify(body)});
}
const valid = {
  characterID:"mira", chapterIndex:1, chapterID:"mira_c2", chapterTitle:"The Missing Address",
  storyChoices:[{chapterID:"mira_c1",choiceID:"mira_c1_a"}],
  recentMessages:[], approvedMemories:[], message:"What does the seal mean?", imageBase64:null
};
let response = await worker.fetch(request(valid),env);
assert.equal(response.status,200);
let result = await response.json();
assert.equal(result.reply,"The letter carries a familiar blue seal.");
assert.equal(result.suggestedChoiceID,null);

// A valid marker is stripped from prose and returned as a canonical choice ID.
providerText = "Then we follow the wax seal.\n[[choice:mira_c1_a]]";
const firstTurn = {...valid, chapterIndex:0, chapterID:"mira_c1", chapterTitle:"A Letter Without a Name", storyChoices:[], message:"I want to study the wax seal under the lamp."};
response = await worker.fetch(request(firstTurn),env);
assert.equal(response.status,200);
result = await response.json();
assert.equal(result.reply,"Then we follow the wax seal.");
assert.equal(result.suggestedChoiceID,"mira_c1_a");

// A forged or future-chapter ID is stripped and never surfaced.
providerText = "That is not part of this chapter.\n[[choice:mira_c2_a]]";
response = await worker.fetch(request(firstTurn),env);
assert.equal(response.status,200);
result = await response.json();
assert.equal(result.reply,"That is not part of this chapter.");
assert.equal(result.suggestedChoiceID,null);

for (const invalid of [
  {...valid,characterID:"unlisted-person"},
  {...valid,characterID:"__proto__"},
  {...valid,chapterID:"mira_c3"},
  {...valid,chapterIndex:"1"},
  {...valid,chapterIndex:9},
  {...valid,storyChoices:[]},
  {...valid,storyChoices:[{chapterID:"mira_c1",choiceID:"jonah_c1_a"}]},
  {...valid,storyChoices:[{chapterID:"mira_c1",choiceID:"mira_c1_a"},{chapterID:"mira_c1",choiceID:"mira_c1_b"}]},
  {...valid,imageBase64:"not-valid!"}
]) {
  response = await worker.fetch(request(invalid),env);
  assert.equal(response.status,400);
}
response = await worker.fetch(request(valid),{...env,REQUEST_LIMITER:{limit:async()=>({success:false})}});
assert.equal(response.status,429);
assert.equal(providerRequests,3);
globalThis.fetch=liveFetch;
console.log("Worker mocked integration: canonical chapter, model payload, valid/forged choice markers, invalid IDs, rate limit - PASS");

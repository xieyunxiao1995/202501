from pathlib import Path
import hashlib

root=Path(__file__).resolve().parent
project=root/'Tideverse.xcodeproj'/'project.pbxproj'
files=[]
for p in (root/'Tideverse').rglob('*'):
 if p.is_file() and (p.suffix in ['.swift','.json','.plist']):
  if '.xcassets/' in str(p): continue
  files.append(p.relative_to(root).as_posix())
files.append('Tideverse/Resources/Assets.xcassets')
files.append('Tests/TideverseTests.swift')
files.append('UITests/TideverseUITests.swift')
for folder in ['Backend', 'Documentation', 'Tools']:
 for p in (root/folder).rglob('*'):
  if p.is_file() and '__pycache__' not in p.parts: files.append(p.relative_to(root).as_posix())
files.extend(['README.md','AGENTS.md'])
files=sorted(set(files))
ids={}
def oid(key):
 if key not in ids:
  ids[key]=hashlib.sha1(('tideverse-xcode-'+key).encode()).hexdigest().upper()[:24]
 return ids[key]

objects=[]
def add(key, kind, lines):
 objects.append((kind,oid(key),f'\t\t{oid(key)} /* {key} */ = {{\n'+lines+'\n\t\t};'))

def q(s):
 return '"'+s.replace('\\','\\\\').replace('"','\\"')+'"'

app_target=oid('AppTarget')
test_target=oid('UnitTestsTarget')
products=oid('ProductsGroup')
main_group=oid('MainGroup')
root_groups={'Tideverse','Backend','Documentation','Tests','UITests','Tools'}
folder_groups={}
for path in files:
 parts=path.split('/')
 for depth in range(1,len(parts)):
  # Do not expand all assets: Xcode treats it as one asset catalog.
  folder='/'.join(parts[:depth])
  if folder.endswith('.xcassets'): break
  folder_groups[folder]=oid('Group/'+folder)
for folder,folder_id in sorted(folder_groups.items(),key=lambda kv:(kv[0].count('/'),kv[0])):
 direct_folders=sorted(f for f in folder_groups if f.startswith(folder+'/') and f.count('/') == folder.count('/')+1)
 direct_files=sorted(f for f in files if f.startswith(folder+'/') and f.count('/')==folder.count('/')+1)
 children=[f'\t\t\t\t{oid("Group/"+f)} /* {f.split("/")[-1]} */,' for f in direct_folders]
 children += [f'\t\t\t\t{oid("File/"+f)} /* {f.split("/")[-1]} */,' for f in direct_files]
 add('Group/'+folder,'PBXGroup','\t\t\tisa = PBXGroup;\n\t\t\tchildren = (\n'+'\n'.join(children)+'\n\t\t\t);\n\t\t\tname = '+q(folder.split('/')[-1])+';\n\t\t\tsourceTree = "<group>";')

for f in files:
 ext=Path(f).suffix
 type_map={'.swift':'sourcecode.swift','.json':'text.json','.plist':'text.plist.xml','.md':'net.daringfireball.markdown','.toml':'text','.js':'sourcecode.javascript','.xcassets':'folder.assetcatalog'}
 line='\t\t\tisa = PBXFileReference;\n\t\t\tlastKnownFileType = '+type_map.get(ext,'text')+';\n\t\t\tname = '+q(Path(f).name)+';\n\t\t\tpath = '+q(f)+';\n\t\t\tsourceTree = "<group>";'
 add('File/'+f,'PBXFileReference',line)

add('AppProduct','PBXFileReference','\t\t\tisa = PBXFileReference;\n\t\t\texplicitFileType = wrapper.application;\n\t\t\tincludeInIndex = 0;\n\t\t\tpath = Tideverse.app;\n\t\t\tsourceTree = BUILT_PRODUCTS_DIR;')
add('TestsProduct','PBXFileReference','\t\t\tisa = PBXFileReference;\n\t\t\texplicitFileType = wrapper.cfbundle;\n\t\t\tincludeInIndex = 0;\n\t\t\tpath = TideverseTests.xctest;\n\t\t\tsourceTree = BUILT_PRODUCTS_DIR;')
add('UITestsProduct','PBXFileReference','\t\t\tisa = PBXFileReference;\n\t\t\texplicitFileType = wrapper.cfbundle;\n\t\t\tincludeInIndex = 0;\n\t\t\tpath = TideverseUITests.xctest;\n\t\t\tsourceTree = BUILT_PRODUCTS_DIR;')
add('ProductsGroup','PBXGroup',f'\t\t\tisa = PBXGroup;\n\t\t\tchildren = (\n\t\t\t\t{oid("AppProduct")} /* Tideverse.app */,\n\t\t\t\t{oid("TestsProduct")} /* TideverseTests.xctest */,\n\t\t\t\t{oid("UITestsProduct")} /* TideverseUITests.xctest */,\n\t\t\t);\n\t\t\tname = Products;\n\t\t\tsourceTree = "<group>";')
root_children=[f'\t\t\t\t{oid("Group/"+name)} /* {name} */,' for name in sorted(root_groups)]+[f'\t\t\t\t{oid("File/"+name)} /* {name} */,' for name in ['README.md','AGENTS.md']]+[f'\t\t\t\t{oid("ProductsGroup")} /* Products */,']
add('MainGroup','PBXGroup','\t\t\tisa = PBXGroup;\n\t\t\tchildren = (\n'+'\n'.join(root_children)+'\n\t\t\t);\n\t\t\tsourceTree = "<group>";')

app_sources=[f for f in files if f.startswith('Tideverse/') and f.endswith('.swift')]
app_resources=[f for f in files if f in ['Tideverse/Resources/Stories/characters.json','Tideverse/Resources/Stories/stories.json','Tideverse/Resources/Assets.xcassets']]
test_sources=['Tests/TideverseTests.swift']
ui_test_sources=['UITests/TideverseUITests.swift']
for f in app_sources+app_resources+test_sources+ui_test_sources:
 add('BuildFile/'+f,'PBXBuildFile',f'\t\t\tisa = PBXBuildFile;\n\t\t\tfileRef = {oid("File/"+f)} /* {Path(f).name} */;')

phases=[('AppSources','PBXSourcesBuildPhase',app_sources),('AppResources','PBXResourcesBuildPhase',app_resources),('AppFrameworks','PBXFrameworksBuildPhase',[]),('TestSources','PBXSourcesBuildPhase',test_sources),('TestResources','PBXResourcesBuildPhase',[]),('TestFrameworks','PBXFrameworksBuildPhase',[]),('UISources','PBXSourcesBuildPhase',ui_test_sources),('UIResources','PBXResourcesBuildPhase',[]),('UIFrameworks','PBXFrameworksBuildPhase',[])]
for name,kind,items in phases:
 refs='\n'.join(f'\t\t\t\t{oid("BuildFile/"+f)} /* {Path(f).name} */,' for f in items)
 add(name,kind,'\t\t\tisa = '+kind+';\n\t\t\tbuildActionMask = 2147483647;\n\t\t\tfiles = (\n'+refs+'\n\t\t\t);\n\t\t\trunOnlyForDeploymentPostprocessing = 0;')

release_script = 'if [ "$CONFIGURATION" = "Release" ]; then /usr/bin/python3 "$SRCROOT/Tools/verify_release.py"; fi'
add('ReleaseValidation','PBXShellScriptBuildPhase','\t\t\tisa = PBXShellScriptBuildPhase;\n\t\t\talwaysOutOfDate = 1;\n\t\t\tbuildActionMask = 2147483647;\n\t\t\tfiles = ();\n\t\t\tinputPaths = ("$(SRCROOT)/Tideverse/Resources/Info.plist", "$(SRCROOT)/Tools/verify_release.py");\n\t\t\tname = "Verify Release Metadata";\n\t\t\toutputPaths = ();\n\t\t\trunOnlyForDeploymentPostprocessing = 0;\n\t\t\tshellPath = /bin/sh;\n\t\t\tshellScript = '+q(release_script)+';')

add('AppTarget','PBXNativeTarget' ,f'''\t\t\tisa = PBXNativeTarget;
\t\t\tbuildConfigurationList = {oid('AppConfigList')} /* Build configuration list for PBXNativeTarget Tideverse */;
\t\t\tbuildPhases = (
\t\t\t\t{oid('ReleaseValidation')} /* Verify Release Metadata */,
\t\t\t\t{oid('AppSources')} /* Sources */,
\t\t\t\t{oid('AppFrameworks')} /* Frameworks */,
\t\t\t\t{oid('AppResources')} /* Resources */,
\t\t\t);
\t\t\tbuildRules = ();
\t\t\tdependencies = ();
\t\t\tname = Tideverse;
\t\t\tproductName = Tideverse;
\t\t\tproductReference = {oid('AppProduct')} /* Tideverse.app */;
\t\t\tproductType = "com.apple.product-type.application";''')
add('TestsContainerProxy','PBXContainerItemProxy',f'''\t\t\tisa = PBXContainerItemProxy;
\t\t\tcontainerPortal = {oid('Project')} /* Project object */;
\t\t\tproxyType = 1;
\t\t\tremoteGlobalIDString = {oid('AppTarget')};
\t\t\tremoteInfo = Tideverse;''')
add('TestsDependency','PBXTargetDependency',f'''\t\t\tisa = PBXTargetDependency;
\t\t\ttarget = {oid('AppTarget')} /* Tideverse */;
\t\t\ttargetProxy = {oid('TestsContainerProxy')} /* PBXContainerItemProxy */;''')
add('UnitTestsTarget','PBXNativeTarget',f'''\t\t\tisa = PBXNativeTarget;
\t\t\tbuildConfigurationList = {oid('TestsConfigList')} /* Build configuration list for PBXNativeTarget TideverseTests */;
\t\t\tbuildPhases = (
\t\t\t\t{oid('TestSources')} /* Sources */,
\t\t\t\t{oid('TestFrameworks')} /* Frameworks */,
\t\t\t\t{oid('TestResources')} /* Resources */,
\t\t\t);
\t\t\tbuildRules = ();
\t\t\tdependencies = (
\t\t\t\t{oid('TestsDependency')} /* PBXTargetDependency */,
\t\t\t);
\t\t\tname = TideverseTests;
\t\t\tproductName = TideverseTests;
\t\t\tproductReference = {oid('TestsProduct')} /* TideverseTests.xctest */;
\t\t\tproductType = "com.apple.product-type.bundle.unit-test";''')
add('UITestsContainerProxy','PBXContainerItemProxy',f'''\t\t\tisa = PBXContainerItemProxy;
\t\t\tcontainerPortal = {oid('Project')} /* Project object */;
\t\t\tproxyType = 1;
\t\t\tremoteGlobalIDString = {oid('AppTarget')};
\t\t\tremoteInfo = Tideverse;''')
add('UITestsDependency','PBXTargetDependency',f'''\t\t\tisa = PBXTargetDependency;
\t\t\ttarget = {oid('AppTarget')} /* Tideverse */;
\t\t\ttargetProxy = {oid('UITestsContainerProxy')} /* PBXContainerItemProxy */;''')
add('UITestsTarget','PBXNativeTarget',f'''\t\t\tisa = PBXNativeTarget;
\t\t\tbuildConfigurationList = {oid('UITestsConfigList')} /* Build configuration list for PBXNativeTarget TideverseUITests */;
\t\t\tbuildPhases = (
\t\t\t\t{oid('UISources')} /* Sources */,
\t\t\t\t{oid('UIFrameworks')} /* Frameworks */,
\t\t\t\t{oid('UIResources')} /* Resources */,
\t\t\t);
\t\t\tbuildRules = ();
\t\t\tdependencies = (
\t\t\t\t{oid('UITestsDependency')} /* PBXTargetDependency */,
\t\t\t);
\t\t\tname = TideverseUITests;
\t\t\tproductName = TideverseUITests;
\t\t\tproductReference = {oid('UITestsProduct')} /* TideverseUITests.xctest */;
\t\t\tproductType = "com.apple.product-type.bundle.ui-testing";''')

for target in ['Project','App','Tests','UITests']:
 for config in ['Debug','Release']:
  settings={}
  if target=='Project':
   settings={'ALWAYS_SEARCH_USER_PATHS':'NO','CLANG_ENABLE_MODULES':'YES','CLANG_ENABLE_OBJC_ARC':'YES','GCC_C_LANGUAGE_STANDARD':'gnu11','IPHONEOS_DEPLOYMENT_TARGET':'17.0','SDKROOT':'iphoneos','SWIFT_VERSION':'5.0','SWIFT_ACTIVE_COMPILATION_CONDITIONS': 'DEBUG' if config=='Debug' else '','SWIFT_OPTIMIZATION_LEVEL':'-Onone' if config=='Debug' else '-O','DEBUG_INFORMATION_FORMAT':'dwarf' if config=='Debug' else '"dwarf-with-dsym"','ENABLE_TESTABILITY':'YES' if config=='Debug' else 'NO'}
  elif target=='App':
   settings={'ASSETCATALOG_COMPILER_APPICON_NAME':'AppIcon','CODE_SIGN_STYLE':'Automatic','CURRENT_PROJECT_VERSION':'1','DEVELOPMENT_ASSET_PATHS':'""','ENABLE_PREVIEWS':'YES','GENERATE_INFOPLIST_FILE':'NO','INFOPLIST_FILE':'"Tideverse/Resources/Info.plist"','IPHONEOS_DEPLOYMENT_TARGET':'17.0','MARKETING_VERSION':'1.0.0','PRODUCT_BUNDLE_IDENTIFIER':'app.tideverse.journeys','PRODUCT_NAME':'"$(TARGET_NAME)"','SUPPORTED_PLATFORMS':'"iphoneos iphonesimulator"','SWIFT_EMIT_LOC_STRINGS':'YES','SWIFT_VERSION':'5.0','TARGETED_DEVICE_FAMILY':'1'}
  elif target=='UITests':
   settings={'CODE_SIGN_STYLE':'Automatic','GENERATE_INFOPLIST_FILE':'YES','IPHONEOS_DEPLOYMENT_TARGET':'17.0','PRODUCT_BUNDLE_IDENTIFIER':'app.tideverse.journeys.uitests','PRODUCT_NAME':'"$(TARGET_NAME)"','SWIFT_VERSION':'5.0','TARGETED_DEVICE_FAMILY':'1','TEST_TARGET_NAME':'Tideverse'}
  else:
   settings={'BUNDLE_LOADER':'"$(TEST_HOST)"','CODE_SIGN_STYLE':'Automatic','GENERATE_INFOPLIST_FILE':'YES','IPHONEOS_DEPLOYMENT_TARGET':'17.0','PRODUCT_BUNDLE_IDENTIFIER':'app.tideverse.journeys.tests','PRODUCT_NAME':'"$(TARGET_NAME)"','SWIFT_VERSION':'5.0','TARGETED_DEVICE_FAMILY':'1','TEST_HOST':'"$(BUILT_PRODUCTS_DIR)/Tideverse.app/Tideverse"'}
  lines=['\t\t\t\t'+key+' = '+val+';' for key,val in settings.items() if val!='']
  add(f'{target}{config}Config','XCBuildConfiguration','\t\t\tisa = XCBuildConfiguration;\n\t\t\tbuildSettings = {\n'+'\n'.join(lines)+'\n\t\t\t};\n\t\t\tname = '+config+';')
 for_label={'Project':'PBXProject "Tideverse"','App':'PBXNativeTarget "Tideverse"','Tests':'PBXNativeTarget "TideverseTests"','UITests':'PBXNativeTarget "TideverseUITests"'}[target]
 add(target+'ConfigList','XCConfigurationList',f'''\t\t\tisa = XCConfigurationList;
\t\t\tbuildConfigurations = (
\t\t\t\t{oid(target+'DebugConfig')} /* Debug */,
\t\t\t\t{oid(target+'ReleaseConfig')} /* Release */,
\t\t\t);
\t\t\tdefaultConfigurationIsVisible = 0;
\t\t\tdefaultConfigurationName = Release;''')

add('Project','PBXProject',f'''\t\t\tisa = PBXProject;
\t\t\tattributes = {{
\t\t\t\tBuildIndependentTargetsInParallel = YES;
\t\t\t\tLastUpgradeCheck = 1600;
\t\t\t\tTargetAttributes = {{
\t\t\t\t\t{oid('AppTarget')} = {{ CreatedOnToolsVersion = 16.0; LastSwiftMigration = 1600; }};
\t\t\t\t\t{oid('UnitTestsTarget')} = {{ CreatedOnToolsVersion = 16.0; LastSwiftMigration = 1600; TestTargetID = {oid('AppTarget')}; }};
\t\t\t\t\t{oid('UITestsTarget')} = {{ CreatedOnToolsVersion = 16.0; LastSwiftMigration = 1600; TestTargetID = {oid('AppTarget')}; }};
\t\t\t\t}};
\t\t\t}};
\t\t\tbuildConfigurationList = {oid('ProjectConfigList')} /* Build configuration list for PBXProject */;
\t\t\tcompatibilityVersion = "Xcode 14.0";
\t\t\tdevelopmentRegion = en;
\t\t\thasScannedForEncodings = 0;
\t\t\tknownRegions = (en, Base);
\t\t\tmainGroup = {oid('MainGroup')};
\t\t\tproductRefGroup = {oid('ProductsGroup')};
\t\t\tprojectDirPath = "";
\t\t\tprojectRoot = "";
\t\t\ttargets = (
\t\t\t\t{oid('AppTarget')} /* Tideverse */,
\t\t\t\t{oid('UnitTestsTarget')} /* TideverseTests */,
\t\t\t\t{oid('UITestsTarget')} /* TideverseUITests */,
\t\t\t);''')

orders=['PBXBuildFile','PBXContainerItemProxy','PBXFileReference','PBXFrameworksBuildPhase','PBXGroup','PBXNativeTarget','PBXProject','PBXResourcesBuildPhase','PBXSourcesBuildPhase','PBXShellScriptBuildPhase','PBXTargetDependency','XCBuildConfiguration','XCConfigurationList']
parts=['// !$*UTF8*$!','{','\tarchiveVersion = 1;','\tclasses = {};','\tobjectVersion = 56;','\tobjects = {']
for kind in orders:
 entries=sorted([s for t,i,s in objects if t==kind])
 if entries:
  parts += [f'\n/* Begin {kind} section */']+entries+[f'/* End {kind} section */\n']
parts+=['\t};','\trootObject = '+oid('Project')+' /* Project object */;','}','']
project.write_text('\n'.join(parts))
print('Wrote pbxproj:',len(app_sources),'Swift app source files,',len(app_resources),'resources, 1 unit-test file,',len(objects),'objects')

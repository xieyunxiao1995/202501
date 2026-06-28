import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/app_theme.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  final _contactController = TextEditingController();
  String _category = '功能建议';
  bool _submitting = false;

  @override
  void dispose() {
    _contentController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);

    final body =
        '''
反馈类型：$_category

反馈内容：
${_contentController.text.trim()}

联系方式：${_contactController.text.trim().isEmpty ? '未填写' : _contactController.text.trim()}

来自 CPDD小屋 iOS App
''';
    final uri = Uri(
      scheme: 'mailto',
      path: 'feedback@cpcloth.app',
      queryParameters: {'subject': 'CPDD小屋 - $_category', 'body': body},
    );

    try {
      final launched = await launchUrl(uri);
      if (!launched) await _copyFallback(body);
    } catch (_) {
      await _copyFallback(body);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _copyFallback(String body) async {
    await Clipboard.setData(ClipboardData(text: body));
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('未找到邮件应用，反馈内容已复制到剪贴板。')));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: FocusManager.instance.primaryFocus?.unfocus,
      child: Scaffold(
        appBar: AppBar(title: const Text('反馈与建议')),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            children: [
              Container(
                padding: const EdgeInsets.all(19),
                decoration: BoxDecoration(
                  color: AppColors.mistBlue,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Text(
                  '每一条具体的体验都很珍贵。提交后会打开系统邮件，由你确认发送。',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 22),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(labelText: '反馈类型'),
                items: const ['功能建议', '体验问题', '数据问题', 'AI 回答', '其他']
                    .map(
                      (value) =>
                          DropdownMenuItem(value: value, child: Text(value)),
                    )
                    .toList(growable: false),
                onChanged: (value) {
                  if (value != null) setState(() => _category = value);
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _contentController,
                minLines: 6,
                maxLines: 10,
                decoration: const InputDecoration(
                  labelText: '告诉我们发生了什么',
                  hintText: '建议描述使用场景、期望结果和实际结果……',
                  alignLabelWithHint: true,
                ),
                validator: (value) => value == null || value.trim().length < 5
                    ? '请至少输入 5 个字，让我们更好地理解问题'
                    : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _contactController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: '联系方式（选填）',
                  hintText: '邮箱或其他方便联系的方式',
                ),
              ),
              const SizedBox(height: 26),
              FilledButton.icon(
                onPressed: _submitting ? null : _submit,
                icon: _submitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.mail_outline_rounded),
                label: Text(_submitting ? '正在准备…' : '通过邮件发送'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tech_barter/components/custom_scaffold.dart';
import 'package:tech_barter/services/api_service.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSending = true);

      bool response = await ApiService.sendMessage(_nameController.text, _emailController.text, _messageController.text);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response ? 'Message sent successfully!' : 'Failed to send message.'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.blue[600],
          ),
        );
        _formKey.currentState!.reset();
        setState(() => _isSending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final blueColor = Colors.blue[600];

    return CustomScaffold(
      curIndex: 2,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHeader(theme, blueColor!),
              const SizedBox(height: 40),
              _buildContactForm(theme, blueColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, Color blueColor) {
    return Column(
      children: [
        Text(
          'Contact Us',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: blueColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Have questions or feedback? We\'d love to hear from you!',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildContactForm(ThemeData theme, Color blueColor) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Send us a message',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: blueColor,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Your Name',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    prefixIcon: Icon(Icons.person, color: blueColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: blueColor),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    prefixIcon: Icon(Icons.email, color: blueColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: blueColor),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    labelText: 'Message',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.message, color: blueColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: blueColor),
                    ),
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your message';
                    }
                    if (value.length < 10) {
                      return 'Message should be at least 10 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isSending ? null : _sendMessage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blueColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isSending
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'Send Message',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
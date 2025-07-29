import 'package:cofi/screens/community_commitment_screen.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../widgets/text_widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _obscurePassword = true;
  final TextEditingController _birthdayController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Finish signing up',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                _buildTextField('First name'),
                const SizedBox(height: 12),
                _buildTextField('Last name'),
                const SizedBox(height: 12),
                _buildTextField(
                  'Birthday (mm/dd/yyyy)',
                  hint:
                      'To sign up, you need to be at least 18. Your birthday won’t be shared with other people who use Cofi.',
                  suffixIcon:
                      const Icon(Icons.arrow_drop_down, color: Colors.white54),
                  readOnly: true,
                  controller: _birthdayController,
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime(DateTime.now().year - 18, 1, 1),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(DateTime.now().year - 18, 12, 31),
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.dark().copyWith(
                            colorScheme: ColorScheme.dark(
                              primary: const Color(0xFFDF2C2C),
                              surface: const Color(0xFF222222),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      _birthdayController.text =
                          "${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}";
                    }
                  },
                ),
                const SizedBox(height: 12),
                _buildTextField('Email', initialValue: 'support@appcourse.io'),
                const SizedBox(height: 12),
                _buildTextField(
                  'Password',
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white54,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 18),
                _buildDisclaimer(),
                const SizedBox(height: 20),
                _buildButton(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label, {
    String? hint,
    Widget? suffixIcon,
    bool obscureText = false,
    bool readOnly = false,
    String? initialValue,
    TextEditingController? controller,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          text: label,
          fontSize: 15,
          color: Colors.white,
          isBold: true,
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          initialValue: controller == null ? initialValue : null,
          obscureText: obscureText,
          readOnly: readOnly,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF222222),
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white54, fontSize: 13),
            suffixIcon: suffixIcon,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(28),
              borderSide: BorderSide.none,
            ),
          ),
          onTap: onTap,
        ),
      ],
    );
  }

  Widget _buildDisclaimer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: TextWidget(
        text:
            'By selecting Agree and continue, I agree to appcourse Terms of Service, Payments Terms of Service and Nondiscrimination Policy and acknowledge the Privacy Policy.',
        fontSize: 12.5,
        color: Colors.white70,
        align: TextAlign.left,
        maxLines: 4,
      ),
    );
  }

  Widget _buildButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFDF2C2C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CommunityCommitmentScreen(),
          ),
        );
      },
      child: TextWidget(
        text: 'Agree and continue',
        fontSize: 17,
        color: Colors.white,
        isBold: true,
        align: TextAlign.center,
      ),
    );
  }
}

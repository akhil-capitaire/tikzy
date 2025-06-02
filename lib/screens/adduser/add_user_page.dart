import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tikzy/utils/fontsizes.dart';
import 'package:tikzy/utils/screen_size.dart';
import 'package:tikzy/utils/spaces.dart';
import 'package:tikzy/widgets/buttons.dart';
import 'package:tikzy/widgets/form_input.dart';

import '../../services/user_services.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final roleController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    roleController.dispose();
    super.dispose();
  }

  Future<void> createUser({
    required String name,
    required String email,
    required String role,
    required String password, // Temp or fixed password
  }) async {
    try {
      // 1. Create user in Firebase Auth
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = credential.user?.uid;
      if (uid == null) throw Exception('User ID is null');

      // 2. Save profile in Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      throw Exception('Auth Error: ${e.message}');
    } on FirebaseException catch (e) {
      throw Exception('Firestore Error: ${e.message}');
    }
  }

  void submit() async {
    if (formKey.currentState?.validate() ?? false) {
      final name = nameController.text.trim();
      final email = emailController.text.trim();
      final role = selectedRole?.trim() ?? '';

      try {
        await UserService().createUser(
          name: name,
          email: email,
          role: role,
          password: email,
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  String? selectedRole;
  final roles = ['Admin', 'User', 'Manager', 'Support'];
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isWeb = screenWidth >= 900;

    final maxWidth = 700.0;

    return Scaffold(
      appBar: isMobile ? AppBar(centerTitle: true) : null,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenSize.width(isMobile ? 4 : 6),
                vertical: ScreenSize.height(4),
              ),
              child: Material(
                elevation: isMobile ? 0 : 8,
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Add New User',
                            style: TextStyle(
                              fontSize: baseFontSize + 6,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        sb(0, 4),

                        if (isWeb)
                          Row(
                            children: [
                              Expanded(
                                child: FormInput(
                                  controller: nameController,
                                  hintText: 'Full Name',
                                  validator: (value) =>
                                      (value == null || value.isEmpty)
                                      ? 'Enter name'
                                      : null,
                                  keyboardType: TextInputType.name,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: FormInput(
                                  controller: emailController,
                                  hintText: 'Email',
                                  validator: (value) {
                                    if (value == null || value.isEmpty)
                                      return 'Enter email';
                                    final emailRegex = RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                    );
                                    if (!emailRegex.hasMatch(value))
                                      return 'Enter valid email';
                                    return null;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                            ],
                          )
                        else ...[
                          FormInput(
                            controller: nameController,
                            hintText: 'Full Name',
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                ? 'Enter name'
                                : null,
                            keyboardType: TextInputType.name,
                          ),
                          sb(0, 3),
                          DropdownButtonFormField<String>(
                            value: selectedRole,
                            decoration: InputDecoration(
                              hintText: 'Select Role',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                            ),
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                ? 'Select role'
                                : null,
                            items: roles
                                .map(
                                  (role) => DropdownMenuItem(
                                    value: role,
                                    child: Text(role),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) =>
                                setState(() => selectedRole = value),
                          ),
                        ],

                        sb(0, 3),

                        DropdownButtonFormField<String>(
                          value: selectedRole,
                          isExpanded: true,
                          style: TextStyle(fontSize: baseFontSize),
                          decoration: InputDecoration(
                            hintText: 'Select Role',
                            labelStyle: TextStyle(fontSize: baseFontSize),
                            hintStyle: TextStyle(fontSize: baseFontSize),
                            errorStyle: TextStyle(fontSize: baseFontSize - 1),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            isDense: true, // reduces vertical height
                          ),
                          validator: (value) => (value == null || value.isEmpty)
                              ? 'Select role'
                              : null,
                          items: roles
                              .map(
                                (role) => DropdownMenuItem(
                                  value: role,
                                  child: Text(
                                    role,
                                    style: TextStyle(fontSize: baseFontSize),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) =>
                              setState(() => selectedRole = value),
                        ),

                        sb(0, 5),

                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            label: 'Add User',
                            type: ButtonType.primary,
                            isSmall: false,
                            onPressed: () async {
                              submit();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

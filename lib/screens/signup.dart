import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String _selectedGender = "Male"; // Default selection
  String _selectedUniversity = "Select University"; // Default selection

  final List<String> universities = [
    "Select University",
    "Baba Guru Nanak Univeristy",
    "LUMS",
    "MIT",
    "Oxford University",
    "Cambridge University"
  ];

  bool _isPasswordVisible = false;

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('fullName', nameController.text);
      await prefs.setString('whoiam', emailController.text);
      await prefs.setString('password', passwordController.text);
      await prefs.setString('gender', _selectedGender);
      await prefs.setString('university', _selectedUniversity);
      await prefs.setString('address', addressController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Successfully Signed Up!"), backgroundColor: Colors.green),
      );

      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Signup")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Full Name"),
                  validator: (value) => value!.isEmpty ? "Enter your name" : null,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: "Email"),
                  validator: (value) => !value!.contains("@") ? "Enter a valid email" : null,
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                  validator: (value) => value!.length < 6 ? "Password must be 6+ characters" : null,
                ),

                // Gender Selection (Radio Buttons)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Gender:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Radio(
                            value: "Male",
                            groupValue: _selectedGender,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value.toString();
                              });
                            },
                          ),
                          Text("Male"),
                          Radio(
                            value: "Female",
                            groupValue: _selectedGender,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value.toString();
                              });
                            },
                          ),
                          Text("Female"),
                        ],
                      ),
                    ],
                  ),
                ),

                // University Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedUniversity,
                  items: universities.map((String uni) {
                    return DropdownMenuItem<String>(
                      value: uni,
                      child: Text(uni),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedUniversity = value!;
                    });
                  },
                  validator: (value) => value == "Select University" ? "Please select a university" : null,
                  decoration: InputDecoration(labelText: "University"),
                ),

                // Address Field
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: "Address"),
                  validator: (value) => value!.isEmpty ? "Enter your address" : null,
                ),

                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _signup,
                  child: Text("Signup"),
                ),
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                  child: Text("Already have an account? Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

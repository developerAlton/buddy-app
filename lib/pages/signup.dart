import 'package:buddy_app/constants/texts.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'package:buddy_app/constants/sizes.dart';
import 'package:buddy_app/constants/private_constants.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  // TextEditingControllers for input fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _studentNoController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  // FocusNodes for input fields
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _idFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _rePasswordFocusNode = FocusNode();

  // Flags to track if fields have been clicked first time
  bool _firstNameTouched = false;
  bool _lastNameTouched = false;
  bool _idTouched = false;
  bool _passwordTouched = false;
  bool _rePasswordTouched = false;

  // Password visibility flags
  bool _passwordVisible = false;
  bool _rePasswordVisible = false;

  //state to track focus on each input field
  @override
  void initState() {
    super.initState();
    // Default values ==============
    _firstNameController.text = "ExampleName";
    _lastNameController.text = "ExampleSurname";
    _passwordController.text = "Password123**";
    _rePasswordController.text = "Password123";
    _studentNoController.text = "2562592";

    // Default values ====================
    _firstNameFocusNode
        .addListener(() => _handleFocusChange(_firstNameFocusNode, () {
              setState(() {
                _firstNameTouched = true;
              });
            }));
    _lastNameFocusNode
        .addListener(() => _handleFocusChange(_lastNameFocusNode, () {
              setState(() {
                _lastNameTouched = true;
              });
            }));
    _idFocusNode.addListener(() => _handleFocusChange(_idFocusNode, () {
          setState(() {
            _idTouched = true;
          });
        }));
    _passwordFocusNode
        .addListener(() => _handleFocusChange(_passwordFocusNode, () {
              setState(() {
                _passwordTouched = true;
              });
            }));
    _rePasswordFocusNode
        .addListener(() => _handleFocusChange(_rePasswordFocusNode, () {
              setState(() {
                _rePasswordTouched = true;
              });
            }));
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _studentNoController.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _rePasswordFocusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange(FocusNode focusNode, VoidCallback callback) {
    if (focusNode.hasFocus) {
      callback();
    }
  }

  //for eye slash icon and password chars
  void _togglePasswordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  void _toggleRePasswordVisibility() {
    setState(() {
      _rePasswordVisible = !_rePasswordVisible;
    });
  }

  // field validation
  String? _validateFirstName(String? value) {
    if (!_firstNameTouched) return null;
    if (value == null || value.isEmpty) {
      return Texts.firstNameEmptyError;
    }
    return null;
  }

  String? _validateLastName(String? value) {
    if (!_lastNameTouched) return null;
    if (value == null || value.isEmpty) {
      return Texts.lastNameEmptyError;
    }
    return null;
  }

  String? _validateID(String? value) {
    if (!_idTouched) return null;
    if (value == null || value.isEmpty) {
      return Texts.idEmptyError;
    }
    if (value.length != 13) {
      return Texts.idLengthError;
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return Texts.idInvalidError;
    }
    if (!_isValidLuhn(value)) {
      return Texts.idInvalidError;
    }
    return null;
  }

  bool _isValidLuhn(String idNumber) {
    int sum = 0;
    bool isDouble = false;
    for (int i = idNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(idNumber[i]);
      if (isDouble) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }
      sum += digit;
      isDouble = !isDouble;
    }
    return sum % 10 == 0;
  }

  String? _validatePassword(String? value) {
    if (!_passwordTouched) return null;
    if (value == null || value.isEmpty) {
      return Texts.passwordEmptyError;
    }
    if (value.length < 6) {
      return Texts.passwordLengthError;
    }
    if (!RegExp(
            r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&_])[A-Za-z\d@$!%*?&_]{6,}$')
        .hasMatch(value)) {
      return Texts.passwordInvalidError;
    }
    return null;
  }

  String? _validateRePassword(String? value) {
    if (!_rePasswordTouched) return null;
    if (value == null || value.isEmpty) {
      return Texts.reEnterPasswordEmptyError;
    }
    if (value != _passwordController.text) {
      return Texts.reEnterPasswordInvalidError;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              // Title
              Text(
                Texts.signUpTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(
                height: TSizes.spaceBtwInputFields,
              ),
              // Input Fields
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    // First Name and Last Name
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _firstNameController,
                            focusNode: _firstNameFocusNode,
                            decoration: const InputDecoration(
                              labelText: Texts.firstName,
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            validator: _validateFirstName,
                          ),
                        ),
                        const SizedBox(
                          width: TSizes.spaceBtwInputFields,
                        ),
                        Expanded(
                          child: TextFormField(
                            // initialValue: "ExampleSurname",
                            controller: _lastNameController,
                            focusNode: _lastNameFocusNode,
                            decoration: const InputDecoration(
                              labelText: Texts.lastName,
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            validator: _validateLastName,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwInputFields,
                    ),

                    // Student Number
                    TextFormField(
                      //initialValue: '2562592',
                      controller: _studentNoController,
                      decoration: const InputDecoration(
                        labelText: Texts.studentNo,
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwInputFields,
                    ),

                    // ID number
                    TextFormField(
                      // initialValue: "0310240640089",
                      controller: _idController,
                      focusNode: _idFocusNode,
                      decoration: const InputDecoration(
                        labelText: Texts.id,
                        prefixIcon: Icon(Iconsax.finger_scan),
                      ),
                      validator: _validateID,
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwInputFields,
                    ),

                    // Password
                    TextFormField(
                      // initialValue: "Password123**",
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        labelText: Texts.password,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible ? Iconsax.eye : Iconsax.eye_slash,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                        prefixIcon: const Icon(Iconsax.password_check),
                      ),
                      validator: _validatePassword,
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwInputFields,
                    ),

                    // Re-Password
                    TextFormField(
                      // initialValue: "Password123**",
                      controller: _rePasswordController,
                      focusNode: _rePasswordFocusNode,
                      obscureText: !_rePasswordVisible,
                      decoration: InputDecoration(
                        labelText: "Re-enter " + Texts.password,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _rePasswordVisible
                                ? Iconsax.eye
                                : Iconsax.eye_slash,
                          ),
                          onPressed: _toggleRePasswordVisibility,
                        ),
                        prefixIcon: const Icon(Iconsax.password_check),
                      ),
                      validator: _validateRePassword,
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwInputFields,
                    ),

                    // Signup button
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() == false) {
                          return;
                        }
                        registerButton();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 20),
                      ),
                      child: const Text(Texts.CreateAcc),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // SIGN UP

  Future<void> registerPart1() async {
    showBottomMessage([CircularProgressIndicator()]);

    print("Sending registration request");

    String url = baseUrl + "/register";
    final uri = Uri.parse(url);
    var body = {
      "studentNo": _studentNoController.text,
    };
    final response = await http.post(uri, body: body);

    print("RESPONSE: ${response}");
    if (response.statusCode == 200) {
      // show popup to check email
      Navigator.of(context).pop(); // remove loading
      showVerifyEmailBottomSheet();
    } else if (response.statusCode == 409) {
      // user already exists
      Navigator.of(context).pop(); // remove loading
      showBottomMessage([
        Text("User already exists"),
      ]);
    } else {
      // something went wrong, try again later
      Navigator.of(context).pop(); // remove loading
      showBottomMessage([Text("Sorry, something went wrong.")]);
    }
  }

  Future<void> registerPart2(String code) async {
    showBottomMessage([CircularProgressIndicator()]);

    String url = baseUrl + "/register/${code}";
    final uri = Uri.parse(url);
    var body = {
      "firstname": _firstNameController.text,
      "lastname": _lastNameController.text,
      "email": "${_studentNoController.text}@students.wits.ac.za",
      "gender": int.parse(_idController.text[6]) <= 4 ? "F" : "M",
      "password": _passwordController.text,
    };
    final response = await http.post(uri, body: body);

    print(response);
    if (response.statusCode == 201) {
      Navigator.of(context).pop(); // remove loading
      showBottomMessage([
        Text("User successfully created"),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // remove current
                Navigator.of(context).pop(); // remove code verifier
                Navigator.pushNamed((context), 'loginpage');
              },
              child: Text("Continue")),
        ),
      ]);
    } else if (response.statusCode == 409) {
      Navigator.of(context).pop(); // remove loading
      showBottomMessage([Text("User already exists")]);
    } else if (response.statusCode == 404) {
      showBottomMessage([
        Text(
          "Invalid code, please re-enter",
        )
      ]);
    } else {
      Navigator.of(context).pop(); // remove loading
      showBottomMessage([
        Text(
            "Sorry, something went wrong. Consider double checking your student number.")
      ]);
    }
  }

  void showBottomMessage(List<Widget> widgets) {
    showModalBottomSheet(
        isScrollControlled: false,
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  top: 40,
                  left: 40,
                  right: 40,
                  bottom: 40 + MediaQuery.of(context).viewInsets.bottom),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...widgets,
                  ],
                ),
              ),
            ),
          );
        });
  }

  void showVerifyEmailBottomSheet() {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  top: 40,
                  left: 60,
                  right: 60,
                  bottom: 40 + MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Almost done..."),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _codeController,
                    decoration: const InputDecoration(
                        hintText: "Enter code sent to your Student email"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: verifyCodeButton,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Text("Verify Code"),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Text("Cancel"),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  //

  Future<void> registerButton() async {
    await registerPart1();
  }

  Future<void> verifyCodeButton() async {
    await registerPart2(_codeController.text);
  }
}

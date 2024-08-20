import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trueclient/trueclient.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'TrueCLient',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LoginPage());
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Here add your token
  Trueclient trueclient = Trueclient(token: '');

  TextEditingController phoneController = TextEditingController();
  TextEditingController otpCodeController = TextEditingController();

  final _phoneFormKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();

  bool showOTPForm = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'TrueClient Example App',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                  key: _phoneFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          }
                          if (!trueclient.validatePhone(value)) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration:
                            const InputDecoration(labelText: 'Phone Number'),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            if (_phoneFormKey.currentState!.validate()) {
                              String phone = phoneController.text;
                              final TrueclientResponse response =
                                  await trueclient.requestOTP(phone: phone);

                              if (response.success) {
                                if (kDebugMode) {
                                  print(response.data);
                                }
                                const snackBar = SnackBar(
                                  content: Text('OTP SMS SEND SUCCESSFULY'),
                                );

                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);

                                setState(() {
                                  showOTPForm = true;
                                });
                              } else {
                                SnackBar snackBar = SnackBar(
                                  content: Text(response.message),
                                );

                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            }
                          },
                          child: const Text('Send OTP Code')),
                    ],
                  )),
              const SizedBox(
                height: 12,
              ),
              !showOTPForm
                  ? Container()
                  : Form(
                      key: _otpFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Otp Code';
                              }
                              return null;
                            },
                            controller: otpCodeController,
                            keyboardType: TextInputType.text,
                            decoration:
                                const InputDecoration(labelText: 'OTP Code'),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                if (_otpFormKey.currentState!.validate()) {
                                  String otp = otpCodeController.text;

                                  if (otp == await trueclient.lastCodeOTP) {
                                    const snackBar = SnackBar(
                                      content: Text('OTP CODE IS CORRECT'),
                                    );

                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else {
                                    const snackBar = SnackBar(
                                      content: Text('OTP CODE IS INCORRECT'),
                                    );

                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                }
                              },
                              child: const Text('Submit')),
                        ],
                      )),
            ],
          ),
        ));
  }
}

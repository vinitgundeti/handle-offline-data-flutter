import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'log_interceptor.dart';
import 'usersclient.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<User> _users = [];
  bool showLoader = false;
  @override
  void _getUsers() async {
    setState(() {
      showLoader = true;
    });
    final dio = Dio();
    dio.interceptors.add(LoginInterceptor());
    final client = UserClient(dio);
    List<User> users = await client.getUsers();
    setState(() {
      _users = users;
      showLoader = false;
    });
  }

  void _removeUsers() {
    setState(() {
      _users = [];
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Retrofit')),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: (() => _getUsers()),
                    child: const Text('Show Data')),
                const SizedBox(
                  width: 8.0,
                ),
                ElevatedButton(
                    onPressed: (() => _removeUsers()),
                    child: const Text('Clear Data')),
              ],
            ),
            showLoader
                ? const Text('Loading...')
                : Expanded(
                    child: ListView.builder(
                      itemCount: _users.length,
                      itemBuilder: (context, index) {
                        User user = _users[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      child: Text(user.name.toString()[0]),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user.name.toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              var url =
                                                  'mailto:${user.email.toString()}';
                                              launchUrl(
                                                Uri.parse(url),
                                              );
                                            },
                                            child: Text(user.email.toString(),
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                )),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.person,
                                            color: Colors.indigo,
                                            size: 16,
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            user.username.toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.language,
                                          color: Colors.indigo,
                                          size: 16,
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            final uri = Uri.parse(
                                                'https://www.${user.website.toString()}');
                                            if (await canLaunchUrl(uri)) {
                                              await launchUrl(uri);
                                            }
                                          },
                                          child: Text(
                                            user.website.toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Contact',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    InkWell(
                                      onTap: (() async {
                                        var url =
                                            Uri.parse("tel:${user.phone}");
                                        if (await canLaunchUrl(url)) {
                                          await launchUrl(url);
                                        } else {
                                          throw 'Could not launch $url';
                                        }
                                      }),
                                      child: Text(' : ${user.phone.toString()}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey)),
                                    )
                                  ],
                                )
                              ]),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ));
  }
}

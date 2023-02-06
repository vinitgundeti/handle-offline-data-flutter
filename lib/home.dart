import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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
        appBar: AppBar(title: Text('Retrofit')),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: (() => _getUsers()), child: Text('Show Data')),
                SizedBox(
                  width: 8.0,
                ),
                ElevatedButton(
                    onPressed: (() => _removeUsers()),
                    child: Text('Clear Data')),
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
                                          SizedBox(height: 4,),
                                          Text(user.email.toString(),
                                              style: const TextStyle(
                                                  color: Colors.grey,)),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ]),
                            ),
                            // child: ListTile(
                            //   title: Text(user.name.toString()),
                            //   subtitle: Text(user.email.toString()),
                            // ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ));
  }
}

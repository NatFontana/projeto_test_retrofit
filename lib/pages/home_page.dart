import 'package:flutter/material.dart';
import 'package:projeto_test_retrofit/models/user_model.dart';
import 'package:projeto_test_retrofit/repository/user_repository.dart';
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _repository = UserRepository(Dio(),
      baseUrl: 'https://61bbe0dae943920017784fd5.mockapi.io/api/');
  final idEditController = TextEditingController();
  final nameEditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projeto Retrofit'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => newUser(),
        child: Icon(Icons.person),
      ),
      body: FutureBuilder<List<UserModel>>(
        future: _repository.findAll(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final users = snapshot.data;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                final user = users[index];
                return ListTile(
                  onTap: () => showDetails(user.id),
                  title: Text(user.id),
                  subtitle: Text(user.name),
                );
              },
            );
          }

          return const Center();
        },
      ),
    );
  }

  void showDetails(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Center(
            child: FutureBuilder<UserModel>(
              future: _repository.findById(id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: 50,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  final user = snapshot.data;
                  return Container(
                    height: 50,
                    child: Center(
                      child: ListTile(
                          title: Text(user?.id ?? 'id is null'),
                          subtitle: Text(user?.name ?? 'name is null')),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.hasError) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(snapshot.data.toString()),
                        const SizedBox(height: 48),
                        Text(snapshot.error.toString())
                      ],
                    ),
                  );
                }

                return const Center();
              },
            ),
          ),
        );
      },
    );
  }

  void newUser() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Form(
            child: Column(
              children: [
                const Text('User ID'),
                const SizedBox(height: 15),
                TextFormField(controller: idEditController),
                const SizedBox(height: 15),
                const Text('User Name'),
                const SizedBox(height: 15),
                TextFormField(controller: nameEditController),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await _repository.save(UserModel(
                  id: idEditController.text,
                  name: nameEditController.text,
                ));
                Navigator.pop(context);
                setState(() {});
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

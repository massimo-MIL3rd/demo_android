import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:noren/edit/edit_shop_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class EditShopPage extends StatefulWidget {
  EditShopPage(this.name, this.message);
  final String name;
  final String message;

  @override
  State<EditShopPage> createState() => _EditShopPageState();
}

class _EditShopPageState extends State<EditShopPage> {
  var isClosed = false;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditShopModel>(
      create: (_) => EditShopModel(
        widget.name,
        widget.message,
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          backgroundColor: Colors.white,
          title: Text('編集ページ'),
        ),
        body: Center(
          child: Consumer<EditShopModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: model.messageController,
                    decoration: InputDecoration(
                        labelText: 'メッセージ',
                        hintText: 'メッセージ',
                        icon: Icon(Icons.message_outlined)),
                    onChanged: (text) {
                      model.setMessage(text);
                    },
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text('Closed    /     Open'),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .snapshots(),
                      initialData: null,
                      builder: (context, snap) {
                        return SizedBox(
                          width: 80,
                          height: 70,
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Switch(
                              value: snap.data == null
                                  ? false
                                  : (snap.data as DocumentSnapshot)['isClosed'],
                              onChanged: (value) {
                                FirebaseFirestore.instance.runTransaction(
                                  (transaction) async {
                                    DocumentSnapshot freshSnap =
                                        await transaction.get(FirebaseFirestore
                                            .instance
                                            .collection('users')
                                            .doc(uid));
                                    await transaction.update(
                                      freshSnap.reference,
                                      {'isClosed': value},
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: model.isUpdated()
                        ? () async {
                            // 追加の処理
                            try {
                              await model.update();
                              Navigator.of(context).pop();
                            } catch (e) {
                              final snackBar = SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(e.toString()),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          }
                        : null,
                    child: Text('更新する'),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

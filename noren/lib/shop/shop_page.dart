import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:noren/shop/shop_model.dart';
import 'package:noren/edit/edit_shop_page.dart';

class ShopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ShopModel>(
      create: (_) => ShopModel()..fetchUser(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          backgroundColor: Colors.white,
          title: Text('マイページ'),
          actions: [
            Consumer<ShopModel>(builder: (context, model, child) {
              return IconButton(
                onPressed: () async {
                  // 画面遷移
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditShopPage(model.name!, model.message!),
                    ),
                  );
                  model.fetchUser();
                },
                icon: Icon(Icons.edit),
              );
            }),
          ],
        ),
        body: Center(
          child: Consumer<ShopModel>(builder: (context, model, child) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      Text(
                        model.name ?? '店名なし',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(model.address ?? '住所なし'),
                      Text(model.phone ?? '電話番号なし'),
                      Text(model.email ?? 'メールアドレスなし'),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        model.isClosed == false ? 'Closed❌' : 'Open🟢',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        model.message ?? 'メッセージなし',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        onPressed: () async {
                          //ログアウト
                          await model.logout();
                          Navigator.of(context).pop();
                        },
                        child: Text('ログアウト'),
                      ),
                    ],
                  ),
                ),
                if (model.isLoading)
                  Container(
                    color: Colors.black54,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}







// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class ShopPage extends StatefulWidget {
//   const ShopPage({Key? key}) : super(key: key);

//   @override
//   _ShopPageState createState() => _ShopPageState();
// }

// class _ShopPageState extends State<ShopPage> {
//   bool isSwitch = false;
//   final _firestore = FirebaseFirestore.instance;
//   String? comment;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Shop Page'),
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           icon: const Icon(Icons.arrow_back_ios),
//         ),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: TextField(
//                     onChanged: (value){
//                       setState((){
//                         comment = value;
//                       });
//                     },
//                   ),
//                 ),
//               ),
//               TextButton(
//                 child: Text('Send'),
//                 onPressed:(){
//                   _firestore
//                     .collection('markers')
//                     .doc('comment')
//                     .update(
//                       {
//                         'text': comment,
//                       },
//                     )
//                     .then((value) => print('更新しました'))
//                     .catchError((e) => print(e));
//                 }, 
//               ),
//             ],
//           ),
//           Switch(
//             value: isSwitch,
//             onChanged: (bool newBool) {
//               setState(() {
//                 isSwitch = newBool;
//               });
//             },
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               primary: isSwitch ? Colors.green : Colors.blue,
//             ),
//             onPressed: () {
//               debugPrint('Tap to Update');
//             },
//             child: const Text('更新'),
//           ),
//         ],
//       ),
//     );
//   }
// }

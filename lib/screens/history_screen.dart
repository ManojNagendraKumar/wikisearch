import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String? _image;

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseFirestore.instance.collection('history').snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.teal.shade600,
            ),
          );
        }
        if (snapShot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'No Search History found!!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        }
        return Container(
          margin: EdgeInsets.only(top: _size.height * 0.08),
          padding: EdgeInsets.symmetric(horizontal: _size.height * 0.015),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: _size.width * 0.03),
                padding: EdgeInsets.only(bottom: _size.height * 0.01),
                child: const Text(
                  'History',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w900),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: snapShot.data!.docs.length,
                    itemBuilder: (ctx, index) {
                      try {
                        if (snapShot.data!.docs[index]['image'] == null) {
                          _image = null;
                        } else {
                          _image = snapShot.data!.docs[index]['image'];
                        }
                      } catch (error) {
                        print(error);
                      }
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 5,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                    margin: const EdgeInsets.all(10),
                                    width: _size.width * 0.15,
                                    height: _size.height * 0.08,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: _image == null
                                          ? Image.asset(
                                              'image/new_image.jpeg',
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              _image!,
                                              fit: BoxFit.cover,
                                            ),
                                    )),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.all(15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapShot.data!.docs[index]['title'],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: _size.height * 0.01,
                                        ),
                                        SizedBox(
                                          child: Text(
                                            snapShot.data!.docs[index]
                                                ['description'],
                                            softWrap: false,
                                            maxLines: 1,
                                            overflow: TextOverflow.fade,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Divider(
                              height: 0,
                              thickness: 1,
                              color: Colors.grey.shade300,
                            ),
                            Container(
                                alignment: Alignment.bottomRight,
                                child: TextButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('history')
                                        .doc(snapShot.data!.docs[index].id)
                                        .delete();
                                  },
                                  child: Text(
                                    'Remove',
                                    style: TextStyle(
                                        color: Colors.red.shade900,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ))
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        );
      },
    ));
  }
}

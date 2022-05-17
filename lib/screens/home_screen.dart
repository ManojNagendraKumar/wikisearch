import 'dart:convert';

import 'package:assessment_app/lists/list_widget.dart';
import 'package:assessment_app/screens/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({Key? key}) : super(key: key);
  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  final _myFocusNode = FocusNode();
  final _newValue = TextEditingController();
  final _myKey = GlobalKey<FormState>();
  Map<String, dynamic>? _apiResponse;
  List? _listLength;

// This method is used to get the api for the searched text by clicking on the search Iconbutton
  Future<void> _searchMethod() async {
    if (_newValue.text.trim().isEmpty) {
      return;
    }
    _myKey.currentState!.save();
    final url = Uri.parse(
        'https://en.wikipedia.org/w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&titles=${_newValue.text}&formatversion=2');
    final response = await http.get(url);
    Map<String, dynamic> _apiResponseCollected = json.decode(response.body);
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      String? _description;
      String? _image;
      String? _alias;
      String? _label;
      String? _pageImage;
      var _pageid;
      String? _title;

      try {
        if (_apiResponseCollected['query'] == null ||
            _apiResponseCollected['query']['pages'][0]['pageimage'] == null) {
          _pageImage = null;
        } else {
          _pageImage = _apiResponseCollected['query']['pages'][0]['pageimage'];
        }
      } catch (error) {
        print(error);
      }
      try {
        if (_apiResponseCollected['query'] == null ||
            _apiResponseCollected['query']['pages'][0]['terms']['alias'] ==
                null) {
          _alias = null;
        } else {
          _alias =
              _apiResponseCollected['query']['pages'][0]['terms']['alias'][0];
        }
      } catch (error) {
        print(error);
      }
      try {
        if (_apiResponseCollected['query'] == null ||
            _apiResponseCollected['query']['pages'][0]['terms']
                    ['description'] ==
                null) {
          _description = null;
        } else {
          _description = _apiResponseCollected['query']['pages'][0]['terms']
              ['description'][0];
        }
      } catch (error) {
        print(error);
      }
      try {
        if (_apiResponseCollected['query'] == null ||
            _apiResponseCollected['query']['pages'][0]['thumbnail']['source'] ==
                null) {
          _image = null;
        } else {
          _image =
              _apiResponseCollected['query']['pages'][0]['thumbnail']['source'];
        }
      } catch (error) {
        print(error);
      }
      try {
        if (_apiResponseCollected['query'] == null ||
            _apiResponseCollected['query']['pages'][0]['terms']['label'] ==
                null) {
          _label = null;
        } else {
          _label =
              _apiResponseCollected['query']['pages'][0]['terms']['label'][0];
        }
      } catch (error) {
        print(error);
      }
      try {
        if (_apiResponseCollected['query']['pages'] == null) {
          _pageid = null;
          _title = null;
        } else {
          _pageid = _apiResponseCollected['query']['pages'][0]['pageid'];
          _title = _apiResponseCollected['query']['pages'][0]['title'];
        }
      } catch (error) {
        print(error);
      }
      return DetailsScreen(
        label: _label,
        pageid: _pageid,
        alias: _alias,
        title: _title,
        description: _description,
        image: _image,
        pageImage: _pageImage,
      );
    }));
  }

// To clear the text entered by user
  void _clear() {
    setState(() {
      _newValue.clear();
    });
  }

// This method is used to get the api's for the changing text entered by the user
  Future<void> _onSearched(String value) async {
    if (value.trim().isEmpty) {
      return;
    }
    try {
      final url = Uri.parse(
          'https://en.wikipedia.org/w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&generator=search&gsrsearch=${_newValue.text}&gsrnamespace=0&gsrlimit=5&formatversion=2');
      final response = await http.get(url);
      setState(() {
        _apiResponse = json.decode(response.body) as Map<String, dynamic>;
        _listLength = _apiResponse!['query']['pages'];
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: _size.height * 0.08),
            padding: EdgeInsets.symmetric(horizontal: _size.height * 0.015),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: _size.width * 0.05),
                  child: Text(
                    'Wikisearch',
                    style: TextStyle(
                        color: Colors.teal.shade600,
                        fontSize: 20,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                SizedBox(height: _size.height * 0.01),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  elevation: 7,
                  child: Row(children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(_size.width * 0.01),
                        child: Form(
                          key: _myKey,
                          child: Container(
                            margin: EdgeInsets.only(left: _size.width * 0.05),
                            child: TextFormField(
                              cursorColor: Colors.black,
                              cursorHeight: _size.height * 0.025,
                              controller: _newValue,
                              focusNode: _myFocusNode,
                              decoration: const InputDecoration(
                                  hintText: 'Search here...',
                                  border: InputBorder.none),
                              onChanged: _onSearched,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (_newValue.text.trim().isNotEmpty)
                      IconButton(
                          onPressed: _clear,
                          icon: const Icon(Icons.clear_rounded)),
                    const SizedBox(
                      width: 5,
                    ),
                    IconButton(
                        onPressed: _searchMethod,
                        icon: const Icon(Icons.search))
                  ]),
                ),
              ],
            ),
          ),
          if (_newValue.text.trim().isNotEmpty)
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: _size.width * 0.02),
                child: MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: ListView.builder(
                      itemCount: _listLength!.length,
                      itemBuilder: (ctx, index) {
                        String? _description;
                        String? _image;
                        String? _alias;
                        String? _label;
                        String? _pageImage;
                        var _pageid;
                        String? _title;
                        try {
                          if (_apiResponse!['query']['pages'] == null) {
                            _pageid = null;
                            _title = null;
                          } else {
                            _pageid = _apiResponse!['query']['pages'][index]
                                ['pageid'];
                            _title =
                                _apiResponse!['query']['pages'][index]['title'];
                          }
                        } catch (error) {
                          print(error);
                        }
                        try {
                          if (_apiResponse!['query'] == null ||
                              _apiResponse!['query']['pages'][index]['terms']
                                      ['description'] ==
                                  null) {
                            _description = null;
                          } else {
                            _description = _apiResponse!['query']['pages']
                                [index]['terms']['description'][0];
                          }
                        } catch (error) {
                          print(error);
                        }
                        try {
                          if (_apiResponse!['query']['pages'][index]
                                  ['thumbnail'] ==
                              null) {
                            _image = null;
                          } else {
                            _image = _apiResponse!['query']['pages'][index]
                                ['thumbnail']['source'];
                          }
                        } catch (error) {
                          print(error);
                        }
                        try {
                          if (_apiResponse!['query']['pages'][index]['terms'] ==
                                  null ||
                              (_apiResponse!['query']['pages'][index]['terms']
                                      ['label']) ==
                                  null) {
                            _label = null;
                          } else {
                            _label = _apiResponse!['query']['pages'][index]
                                ['terms']['label'][0];
                          }
                        } catch (error) {
                          print(error);
                        }
                        try {
                          if (_apiResponse!['query']['pages'][index]
                                  ['pageimage'] ==
                              null) {
                            _pageImage = null;
                          } else {
                            _pageImage = _apiResponse!['query']['pages'][index]
                                ['pageimage'];
                          }
                        } catch (error) {
                          print(error);
                        }
                        try {
                          if (_apiResponse!['query']['pages'][index]['terms'] ==
                                  null ||
                              (_apiResponse!['query']['pages'][index]['terms']
                                      ['alias']) ==
                                  null) {
                            _alias = null;
                          } else {
                            _alias = _apiResponse!['query']['pages'][index]
                                ['terms']['alias'][0];
                          }
                        } catch (error) {
                          print(error);
                        }
                        return ListWidget(
                          pageId: _pageid,
                          title: _title,
                          label: _label,
                          pageImage: _pageImage,
                          alias: _alias,
                          description: _description,
                          image: _image,
                        );
                      }),
                ),
              ),
            )
        ],
      ),
    );
  }
}

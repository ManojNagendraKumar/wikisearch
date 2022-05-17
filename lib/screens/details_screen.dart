import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailsScreen extends StatefulWidget {
  var pageid;
  String? title;
  String? description;
  String? image;
  String? label;
  String? pageImage;
  String? alias;

  DetailsScreen(
      {this.pageid,
      this.alias,
      this.description,
      this.image,
      this.label,
      this.pageImage,
      this.title});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  void initState() {
    super.initState();
    _addDataToFirebase();
  }

// Add the details to the Firebase Firestore
  Future<void> _addDataToFirebase() async {
    if (widget.title == null ||
        widget.description == null ||
        widget.description == 'Wikimedia disambiguation page') {
      return;
    }
    await FirebaseFirestore.instance.collection('history').add({
      'pageid': widget.pageid,
      'title': widget.title,
      'description': widget.description,
      'image': widget.image,
      'alias': widget.alias,
      'label': widget.label,
      'pageImage': widget.pageImage
    });
  }

  Widget _design(String heading, String? content) {
    return Container(
      margin: const EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade600),
          ),
          Divider(
            height: 10,
            color: Colors.grey.shade400,
            thickness: 1,
          ),
          Container(
            padding: const EdgeInsets.only(top: 4),
            child: content == null
                ? const Center(
                    child: Text(
                      'Please check the entered text',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                : Text(
                    content,
                    style: const TextStyle(fontSize: 16),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: Colors.teal.shade400,
            expandedHeight: _size.height * 0.4,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.title == null ? '' : widget.title!,
                style: const TextStyle(color: Colors.black),
                overflow: TextOverflow.fade,
              ),
              background: Container(
                  child: widget.image == null
                      ? Image.asset(
                          'image/new_image.jpeg',
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                        )
                      : Image.network(
                          widget.image!,
                          fit: BoxFit.cover,
                        )),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(height: _size.height * 0.02),
            _design(
                'Description',
                widget.description == null ||
                        widget.description == 'Wikimedia disambiguation page'
                    ? 'No information available'
                    : widget.description),
            _design('Alias', widget.alias ?? 'No information available'),
            _design('Label', widget.label ?? 'No information available'),
            _design(
                'Page Image', widget.pageImage ?? 'No information available'),
            SizedBox(
              height: _size.height * 0.5,
            )
          ]))
        ],
      ),
    );
  }
}

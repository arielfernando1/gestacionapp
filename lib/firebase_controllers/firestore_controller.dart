import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_test/classes/book.dart';
import '../classes/post.dart';

class Firestore {
  // add post to firestore by uuid
  Future<void> addPost(Post post) async {
    final firebaseFirestore = FirebaseFirestore.instance;
    try {
      await firebaseFirestore.collection('posts').add(post.toJson());
    } on FirebaseException catch (e) {
      log('Error adding post: $e');
    }
  }

  // list all posts only for current uuid
  Future<List<Post>> listAll(String uuid) async {
    final firebaseFirestore = FirebaseFirestore.instance;
    //get posts if uuid is equal to current user uuid
    final querySnapshot = await firebaseFirestore
        .collection('posts')
        .where('uuid', isEqualTo: uuid)
        .orderBy(
          'date_created',
          descending: true,
        )
        .get();
    final posts = <Post>[];
    for (final doc in querySnapshot.docs) {
      final post = Post.fromJson(doc.data());
      // get post id
      post.id = doc.id;
      posts.add(post);
    }
    return posts;
  }

  // update post
  Future<void> updatePost(Post post) async {
    final firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore
        .collection('posts')
        .doc(post.id)
        .update(post.toJson())
        .then((value) => log('Post ${post.id} updated'))
        .catchError((error) => log('Error updating post: $error'));
  }

  //destroy post by id
  Future<void> destroyPost(String id) async {
    final firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore.collection('posts').doc(id).delete();
  }

  // list all books
  Future<List<Book>> listAllBooks() async {
    final firebaseFirestore = FirebaseFirestore.instance;
    //get posts if uuid is equal to current user uuid
    final querySnapshot = await firebaseFirestore.collection('books').get();
    final books = <Book>[];
    for (final doc in querySnapshot.docs) {
      final book = Book.fromJson(doc.data());
      books.add(book);
    }
    return books;
  }
}

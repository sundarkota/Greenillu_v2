import 'package:flutter/material.dart';
import 'package:flutter_wordpress/flutter_wordpress.dart' as wp;
import 'package:flutter_html/flutter_html.dart';
//import 'package:url_launcher/url_launcher.dart';
import 'package:greenillu/appconfig/config.dart';
import 'package:greenillu/widgets/app_bar.dart';
import 'package:greenillu/widgets/appdrawer.dart';
import 'details_post.dart';


class PostList extends StatelessWidget {
  static const String routeName = '/posts';

  wp.WordPress wordPress = wp.WordPress(
      baseUrl: AppConfig.Appurls['baseurl']
  );

  _fetchPosts() {
    Future<List<wp.Post>> posts = wordPress.fetchPosts(
        postParams: wp.ParamsPostList(
          context: wp.WordPressContext.view,
          pageNum: 1,
          perPage: 10,
        ),
        fetchAuthor: true,
        fetchFeaturedMedia: true,
        fetchComments: true
    );

    return posts;
  }

  _getPostImage(wp.Post post) {
    if (post.featuredMedia == null) {
      return SizedBox();
    }
    return Image.network(post.featuredMedia.sourceUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WordPress Demo API'),
        centerTitle: true,
      ),
      drawer: AppDrawer(),
      body: Container(
        child: FutureBuilder(
          future: _fetchPosts(),
          builder: (BuildContext context, AsyncSnapshot<List<wp.Post>> snapshot) {
            if (snapshot.connectionState == ConnectionState.none) {
              return Container();
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                wp.Post post = snapshot.data[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailsPost(post)
                        )
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            _getPostImage(post),
                            SizedBox(height: 10,),
                            Text(
                              post.title.rendered.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                              ),
                            ),
                            SizedBox(height: 15,),
                            Html(
                              data: post.excerpt.rendered.toString(),
                              onLinkTap: (String link) {
                                _launchUrl(link);
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(post.date.toString().replaceAll('T', ' ')),
                                Text(post.author.name),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }


}

_launchUrl(String link) async {
  /*if (await canLaunch(link)) {
    await launch(link);
  } else {
    throw 'Cannot launch $link';
  }*/
}

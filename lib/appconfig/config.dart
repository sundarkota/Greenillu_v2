class AppConfig{

  static const Appurls = {
                        'baseurl' : "http://dev.greenillu.com/",
                        'reporturl' : "http://dev.greenillu.com/",
                        'wpapi' : "http://dev.greenillu.com/wp-json/"
                      };
  static const Namespaces = {
      /*"oembed/1.0",
      "jetpack/v4",
      "jwt-auth/v1",*/
      'token': "jwt-auth/v1/token",
      'menu' : "menus/v1",
      'wcfmmps': "wcfmmp/v1",
      'wp' : "wp/v2",
      'wpcom' : "wpcom/v2",
      'wc' : "wc/v3",
    'products':'wc/v3/products/',
    'wc_prd':'wcfmmp/v1/products/',
    'cart':'wc/store/cart/items/',
      /*"wc-kliken/v1",
      "wc/blocks",
      "wc/store",
      "wc/v1",
      "wc/v2",
      "wc/v3",
      "wccom-site/v1",
      "wc-analytics",
      "wc-admin",
      "mailchimp-for-woocommerce/v1",
      "wp/v2"*/
  };
  static const perpage = {
    'all' : 6,
    'cart' : 20
  };
  static const Tokens = {
    'auth' : "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9kZXYuZ3JlZW5pbGx1LmNvbSIsImlhdCI6MTU5MDc3OTE5MywibmJmIjoxNTkwNzc5MTkzLCJleHAiOjE1OTEzODM5OTMsImRhdGEiOnsidXNlciI6eyJpZCI6IjEifX19.2cV8-f9-Jyfnod7k3XQ7AH93oT-ejNlGQsXajJfIt8Q"
  };

  static getApiUrl(endpoint){
    return Appurls['wpapi'] + ((endpoint!="")?Namespaces[endpoint]:"");
  }

  static getWebUrl(endpoint){
    return Appurls['baseurl'] + ((endpoint!="")?Namespaces[endpoint]:"");
  }

  static getReportUrl(endpoint){
    return Appurls['reporturl'] + ((endpoint!="")?Namespaces[endpoint]:"");
  }

  static getImgUrl(img){
    return Appurls['baseurl'] + ((img!="")?img:"");
  }
}

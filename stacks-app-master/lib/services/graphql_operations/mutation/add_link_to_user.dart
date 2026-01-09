const String addLinkToUserQuery = """
  mutation(\$target_url: String!, \$latitude : Float, \$longitude : Float){
    add_link(input : {target_url: \$target_url, latitude : \$latitude, longitude : \$longitude}){
      target_url
      id
      title
      description
      image_url
      latitude
      longitude
    }
  }
""";

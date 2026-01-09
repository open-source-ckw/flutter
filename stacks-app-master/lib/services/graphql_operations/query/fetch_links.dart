const String fetchCollectionsLinksQuery = """
query GetStacks(\$page : Int!){
  stacks{
    id
    name
    links(page: \$page){
      id
      title
      description
      tags
      favicon_url
      target_url
      image_url
      latitude
      longitude
      __typename
      updated_at
      media_files{
        file_url
    		filename
   			id
    		metadata
      }
    }
  }
}
""";

const String fetchCollectionsSingelLinksQuery = """
query GetSingelStacks(\$page : Int!, \$id : ID!){
  stack(id: \$id){
    id
    name
    links(page: \$page){
      id
      title
      description
      tags
      favicon_url
      target_url
      image_url
      latitude
      longitude
      __typename
      updated_at
      rating{
      average_rating
      ratings_count
    	}
      media_files{
        file_url
    		filename
   			id
    		metadata
      }
      user{
    	email
    	id
  	}
    }
  }
}""";

const String fetchLinksQuery = """
  query(\$page : Int!){
    links(page: \$page){
      id
      target_url
      description
      title
      image_url
      latitude
      longitude
      tags
      favicon_url
      updated_at
    user{
    	email
    	id
  	}
    rating{
      average_rating
      ratings_count
    }
    media_files{
      file_url
    	filename
    	id
    	metadata
    }
    }
  }
""";

const String getLinkDetailsByIdQuery = """
  query(\$id : ID!){
    link(id : \$id){
    id
    title
    description
    image_url
    favicon_url
    latitude
    longitude
    rating{
      average_rating
      ratings_count
    }
    media_files{
    file_url
    filename
    id
    metadata
  	}
    tags
    target_url
    updated_at
    }
  }
""";

const String fetchLink = """
query  {
links(page: 1){
description
id
image_url
latitude
longitude
target_url
title
updated_at
}}
""";

const String getLinkByIdQuery = """
  query(\$id : ID!){
    link(id : \$id){
      target_url
    }
  }
""";

const String getSearchLinkQuery = """ 
query (\$page : Int!, \$query : String!) {
links(page: \$page, query:\$query){
description
id
image_url
latitude
longitude
favicon_url
target_url
title
updated_at
}}""";

const String getPlacesLinksQuery = """ 
query (\$page : Int!, \$boundary : BoundaryBoxInput){
places(page: \$page, boundary: \$boundary){
    id
    latitude
    longitude
    link{
      id
      title
      description
      tags
      favicon_url
      image_url
      latitude
      longitude
      target_url
      updated_at
      user{
        email
        id
      }
      rating{
        average_rating
        ratings_count
      }
      media_files{
        file_url
        filename
        id
        metadata
      }
    }
  }}""";
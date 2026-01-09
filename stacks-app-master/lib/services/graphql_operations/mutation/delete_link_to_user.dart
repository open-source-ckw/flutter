const String deleteLinkToUserQuery = """
mutation DeleteLink(\$id : ID!){
  delete_link(input: {link_id: \$id})
}
""";
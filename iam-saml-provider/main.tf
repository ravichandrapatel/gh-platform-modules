# IAM SAML provider: single provider for federated authentication.

data "aws_secretsmanager_secret_version" "saml" {
  count     = var.saml_metadata_secret_id != null ? 1 : 0
  secret_id = var.saml_metadata_secret_id
}

resource "aws_iam_saml_provider" "this" {
  name = var.name
  saml_metadata_document = var.saml_metadata_secret_id != null ? (
    var.saml_metadata_secret_key != null ?
    jsondecode(data.aws_secretsmanager_secret_version.saml[0].secret_string)[var.saml_metadata_secret_key] :
    data.aws_secretsmanager_secret_version.saml[0].secret_string
  ) : var.saml_metadata_document

  tags = var.tags

  lifecycle {
    precondition {
      condition     = var.saml_metadata_document != null || var.saml_metadata_secret_id != null
      error_message = "Either saml_metadata_document or saml_metadata_secret_id must be provided."
    }
  }
}

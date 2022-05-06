resource "azurerm_storage_account" "freedom_storage_acct" {
  name                     = "freedomstorageinsights"
  resource_group_name      = azurerm_resource_group.rg_1.name
  location                 = azurerm_resource_group.rg_1.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true
}

resource "azurerm_storage_container" "freedom_blob" {
  name                  = "freedomblob"
  storage_account_name  = azurerm_storage_account.freedom_storage_acct.name
  container_access_type = "container"
}

resource "aws_s3_bucket" "freedom_bucket" {
  bucket = "terraform-s3-freedom"
  policy = file("s3_policy.json")
}

resource "aws_s3_bucket_acl" "public" {
  bucket = aws_s3_bucket.freedom_bucket.id
  acl    = "public-read"
}
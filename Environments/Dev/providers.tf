terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.50.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
  subscription_id = "2a6429ab-34bc-4c09-812c-9e5d8ceee0d7"
}
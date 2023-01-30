# Create User Identity for VM
resource "azurerm_user_assigned_identity" "main" {
  location            = data.azurerm_resource_group.current.location
  name                = "${local.environment}-identityforVM"
  resource_group_name = data.azurerm_resource_group.current.name
}

# Defination custom role for resource group
resource "azurerm_role_definition" "read_container_registry" {
    name = "${local.environment}-readContainerRegistry"
    scope = data.azurerm_resource_group.current.id
    permissions {
      actions = [   "Microsoft.ContainerRegistry/checkNameAvailability/read",
                    "Microsoft.ContainerRegistry/locations/operationResults/read",
                    "Microsoft.ContainerRegistry/operations/read",
                    "Microsoft.ContainerRegistry/registries/read",
                    "Microsoft.ContainerRegistry/registries/privateEndpointConnections/read",
                    "Microsoft.ContainerRegistry/registries/privateEndpointConnections/operationStatuses/read",
                    "Microsoft.ContainerRegistry/registries/privateEndpointConnectionProxies/read",
                    "Microsoft.ContainerRegistry/registries/privateEndpointConnectionProxies/operationStatuses/read",
                    "Microsoft.ContainerRegistry/registries/agentpools/read",
                    "Microsoft.ContainerRegistry/registries/builds/read",
                    "Microsoft.ContainerRegistry/registries/buildTasks/read",
                    "Microsoft.ContainerRegistry/registries/buildTasks/steps/read",
                    "Microsoft.ContainerRegistry/registries/deleted/read",
                    "Microsoft.ContainerRegistry/registries/listPolicies/read",
                    "Microsoft.ContainerRegistry/registries/listUsages/read",
                    "Microsoft.ContainerRegistry/registries/metadata/read",
                    "Microsoft.ContainerRegistry/registries/operationStatuses/read",
                    "Microsoft.ContainerRegistry/registries/providers/Microsoft.Insights/diagnosticSettings/read",
                    "Microsoft.ContainerRegistry/registries/pull/read",
                    "Microsoft.ContainerRegistry/registries/quarantine/read",
                    "Microsoft.ContainerRegistry/registries/runs/read",
                    "Microsoft.ContainerRegistry/registries/taskruns/read",
                    "Microsoft.ContainerRegistry/registries/tasks/read",
                    "Microsoft.ContainerRegistry/registries/connectedRegistries/read",
                    "Microsoft.ContainerRegistry/registries/eventGridFilters/read",
                    "Microsoft.ContainerRegistry/registries/exportPipelines/read",
                    "Microsoft.ContainerRegistry/registries/importPipelines/read",
                    "Microsoft.ContainerRegistry/registries/pipelineRuns/read",
                    "Microsoft.ContainerRegistry/registries/pipelineRuns/operationStatuses/read",
                    "Microsoft.ContainerRegistry/registries/replications/read",
                    "Microsoft.ContainerRegistry/registries/replications/operationStatuses/read",
                    "Microsoft.ContainerRegistry/registries/scopeMaps/read",
                    "Microsoft.ContainerRegistry/registries/scopeMaps/operationStatuses/read",
                    "Microsoft.ContainerRegistry/registries/tokens/read",
                    "Microsoft.ContainerRegistry/registries/tokens/operationStatuses/read",
                    "Microsoft.ContainerRegistry/registries/webhooks/read",
                    "Microsoft.ContainerRegistry/registries/webhooks/operationStatuses/read",
                    "Microsoft.ContainerRegistry/registries/providers/Microsoft.Insights/logDefinitions/read",
                    "Microsoft.ContainerRegistry/registries/providers/Microsoft.Insights/metricDefinitions/read"]
      not_actions = []
      data_actions = []
      not_data_actions = []
    }
}

# Assign the role for the identity provider with custom role for resource group
resource "azurerm_role_assignment" "assign_vm_read_container_registry" {
    scope = data.azurerm_resource_group.current.id
    principal_id = azurerm_user_assigned_identity.main.principal_id
    role_definition_id = azurerm_role_definition.read_container_registry.role_definition_resource_id
}

resource "azurerm_role_assignment" "assign_vm_read_container_storage" {
    scope = data.azurerm_resource_group.current.id
    principal_id = azurerm_user_assigned_identity.main.principal_id
    role_definition_name = "Storage Blob Data Reader"
}
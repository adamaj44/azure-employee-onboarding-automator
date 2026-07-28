param workflows_logic_employee_onboarding_name string = 'logic-employee-onboarding'
param connections_azuread_1_externalid string = '/subscriptions/9b99de08-3624-4eec-9b3d-75d7406ce0b1/resourceGroups/rg-onboarding-automator/providers/Microsoft.Web/connections/azuread-1'

resource workflows_logic_employee_onboarding_name_resource 'Microsoft.Logic/workflows@2017-07-01' = {
  name: workflows_logic_employee_onboarding_name
  location: 'southindia'
  properties: {
    state: 'Enabled'
    definition: {
      metadata: {
        notes: {}
      }
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      parameters: {
        '$connections': {
          defaultValue: {}
          type: 'Object'
        }
      }
      triggers: {
        When_an_HTTP_request_is_received: {
          type: 'Request'
          kind: 'Http'
          inputs: {
            schema: {
              type: 'object'
              properties: {
                FullName: {
                  type: 'string'
                }
                Email: {
                  type: 'string'
                }
                Department: {
                  type: 'string'
                }
                JobTitle: {
                  type: 'string'
                }
              }
              required: [
                'FullName'
                'Email'
                'Department'
                'JobTitle'
              ]
            }
          }
        }
      }
      actions: {
        Create_user: {
          runAfter: {}
          type: 'ApiConnection'
          inputs: {
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'azuread\'][\'connectionId\']'
              }
            }
            method: 'post'
            body: {
              accountEnabled: true
              displayName: '@triggerBody()?[\'FullName\']'
              mailNickname: '@replace(triggerBody()?[\'FullName\'], \' \', \'.\')'
              passwordProfile: {
                password: 'Welcome2026!#'
              }
              userPrincipalName: '@triggerBody()?[\'Email\']'
            }
            path: '/v1.0/users'
          }
        }
        Switch: {
          runAfter: {
            Create_user: [
              'Succeeded'
            ]
          }
          cases: {
            Case: {
              case: 'IT'
              actions: {
                Add_user_to_group: {
                  type: 'ApiConnection'
                  inputs: {
                    host: {
                      connection: {
                        name: '@parameters(\'$connections\')[\'azuread\'][\'connectionId\']'
                      }
                    }
                    method: 'post'
                    body: {
                      '@@odata.id': '@body(\'Create_user\')?[\'id\']'
                    }
                    path: '/v1.0/groups/@{encodeURIComponent(\'c7d13c01-7bf0-4e5b-9969-c025d8b3aeec\')}/members/$ref'
                  }
                }
              }
            }
            Case_2: {
              case: 'Sales'
              actions: {
                Add_user_to_group_1: {
                  type: 'ApiConnection'
                  inputs: {
                    host: {
                      connection: {
                        name: '@parameters(\'$connections\')[\'azuread\'][\'connectionId\']'
                      }
                    }
                    method: 'post'
                    body: {
                      '@@odata.id': '@body(\'Create_user\')?[\'id\']'
                    }
                    path: '/v1.0/groups/@{encodeURIComponent(\'9555dacc-e400-42d8-9b11-c816baa8cfb5\')}/members/$ref'
                  }
                }
              }
            }
            Case_3: {
              case: 'HR'
              actions: {
                Add_user_to_group_2: {
                  type: 'ApiConnection'
                  inputs: {
                    host: {
                      connection: {
                        name: '@parameters(\'$connections\')[\'azuread\'][\'connectionId\']'
                      }
                    }
                    method: 'post'
                    body: {
                      '@@odata.id': '@body(\'Create_user\')?[\'id\']'
                    }
                    path: '/v1.0/groups/@{encodeURIComponent(\'e9f39347-a07d-4227-966a-97e168298ec0\')}/members/$ref'
                  }
                }
              }
            }
          }
          default: {
            actions: {}
          }
          expression: '@triggerBody()?[\'Department\']'
          type: 'Switch'
        }
        Response: {
          runAfter: {
            Switch: [
              'Succeeded'
            ]
          }
          type: 'Response'
          kind: 'Http'
          inputs: {
            statusCode: 200
            body: {
              status: 'Success'
              message: 'User onboarded and added to group successfully.'
            }
          }
        }
      }
      outputs: {}
    }
    parameters: {
      '$connections': {
        value: {
          azuread: {
            id: '/subscriptions/9b99de08-3624-4eec-9b3d-75d7406ce0b1/providers/Microsoft.Web/locations/southindia/managedApis/azuread'
            connectionId: connections_azuread_1_externalid
            connectionName: 'azuread-1'
            connectionProperties: {}
          }
        }
      }
    }
  }
}

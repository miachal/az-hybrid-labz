#### Ograniczenie regionów tworzenia usług za pomocą Azure Policy

```
> az policy assignment list --disable-scope-strict-match -o table
Description                                                                                                                                                                                                                                                        DisplayName                                                       EnforcementMode    Name                   PolicyDefinitionId                                                                            Scope
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  ----------------------------------------------------------------  -----------------  ---------------------  --------------------------------------------------------------------------------------------  ---------------------------------------------------
This is the default set of policies monitored by Azure Security Center. It was automatically assigned as part of onboarding to Security Center. The default assignment contains only audit policies. For more information please visit https://aka.ms/ascpolicies  ASC Default                                                       Default            SecurityCenterBuiltIn  /providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-847f-89da613e70a8  /subscriptions/<id>
```
```
> az policy definition list -o table | grep -i "allowed location"
This policy enables you to restrict the locations your organization can specify when deploying Azure Cosmos DB resources. Use to enforce your geo-compliance requirements.                                                                                                                                                                                                                                                                                                                                                        Azure Cosmos DB allowed locations                                                                                                 Indexed                                 0473574d-2d43-4217-aefe-941fcdf7e684  BuiltIn
This policy enables you to restrict the locations your organization can specify when deploying resources. Use to enforce your geo-compliance requirements. Excludes resource groups, Microsoft.AzureActiveDirectory/b2cDirectories, and resources that use the 'global' region.                                                                                                                                                                                                                                                   Allowed locations                                                                                                                 Indexed                                 e56962a6-4747-49cd-b67b-bf8b01975c4c  BuiltIn
This policy enables you to restrict the locations your organization can create resource groups in. Use to enforce your geo-compliance requirements.                                                                                                                                                                                                                                                                                                                                                                               Allowed locations for resource groups                                                                                             All                                     e765b5de-1225-4ba3-bd56-1ac6695af988  BuiltIn
```

https://www.azadvertizer.net/azpolicyadvertizer/e56962a6-4747-49cd-b67b-bf8b01975c4c.html

```
> az policy assignment create --scope /subscriptions/<id>/wsb-lab04 --policy e56962a6-4747-49cd-b67b-bf8b01975c4c -p '{ "listOfAllowedLocations": { "value": ["westeurope"] }'
(InvalidApiVersionParameter) The api-version '2021-06-01' is invalid.
```

```
> az group show -n wsb-lab04 -o tsv --query id
/subscriptions/<id>/resourceGroups/wsb-lab04
```

Czyli brakło trochę jeśli chodzi o poprawność scope'a. ^^'

```
> az policy assignment create --scope /subscriptions/b02022f8-aabf-489a-ad78-d7139a477ad0/resourceGroups/wsb-lab04 --policy e56962a6-4747-49cd-b67b-bf8b01975c4c -p '{ "listOfAllowedLocations": { "value": ["westeurope"] }}'
```

```
> az policy assignment list --disable-scope-strict-match -o table
Description                                                                                                                                                                                                                                                        DisplayName                                                       EnforcementMode    Name                    PolicyDefinitionId                                                                            Scope                                                                         ResourceGroup
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------  ----------------------------------------------------------------  -----------------  ----------------------  --------------------------------------------------------------------------------------------  ----------------------------------------------------------------------------  ---------------
This is the default set of policies monitored by Azure Security Center. It was automatically assigned as part of onboarding to Security Center. The default assignment contains only audit policies. For more information please visit https://aka.ms/ascpolicies  ASC Default                                                       Default            SecurityCenterBuiltIn   /providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-847f-89da613e70a8  /subscriptions/<id>
                                                                                                                                                                                                                                                                                                                                     Default            1RYdDsXlROaC_4mhp0_JMA  /providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c     /subscriptions/<id>/resourceGroups/wsb-lab04                                  wsb-lab04
```

Spróbujmy teraz utworzyć VMkę w rg objętej w/w polityką.

```
> az vm create -n usVM -g wsb-lab04 -l westus --image UbuntuLTS --generate-ssh-keys
```

i cyk piękny error na dwa ekrany... :)

```
"details": [
      {
        "code": "RequestDisallowedByPolicy",
        "target": "usVMVNET",
        "message": "Resource 'usVMVNET' was disallowed by policy. Policy identifiers: '[{\"policyAssignment\":{\"name\":\"1RYdDsXlROaC_4mhp0_JMA\",\"id\":\"/subscriptions/<id>/resourceGroups/wsb-lab04/providers/Microsoft.Authorization/policyAssignments/1RYdDsXlROaC_4mhp0_JMA\"},\"policyDefinition\":{\"name\":\"Allowed locations\",\"id\":\"/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c\"}}]'.",
        "additionalInfo": [
         {
            "type": "PolicyViolation",
            "info": {
              "evaluationDetails": {
                "evaluatedExpressions": [
                  {
                    "result": "True",
                    "expressionKind": "Field",
                    "expression": "location",
                    "path": "location",
                    "expressionValue": "westus",
                    "targetValue": ["westeurope"],
                    "operator": "NotIn"
                  },           
```

spróbujmy utworzyć jeszcze taką samą VMkę, ale w dozwolonej lokacji

```
> az vm create -n euVM -g wsb-lab04 -l westeurope --image UbuntuLTS --generate-ssh-keys
{
  "fqdns": "",
  "id": "/subscriptions/<id>/resourceGroups/wsb-lab04/providers/Microsoft.Compute/virtualMachines/euVM",
  "location": "westeurope",
  "macAddress": "00-22-48-7F-2E-1A",
  "powerState": "VM running",
  "privateIpAddress": "10.0.0.4",
  "publicIpAddress": "108.143.104.192",
  "resourceGroup": "wsb-lab04",
  "zones": ""
}
```

co ciekawe jeśli nie wskażemy parametru z lokacją, vmka zostanie utworzona w zgodnej z polityką.

Usuwamy politykę.
```
> az policy assignment delete -n 1RYdDsXlROaC_4mhp0_JMA -g wsb-lab04
```


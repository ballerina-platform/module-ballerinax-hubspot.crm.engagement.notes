// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;

listener http:Listener httpListener = new (9090);

http:Service mockService = service object {

    resource function post crm/v3/objects/notes/batch/upsert(@http:Payload BatchInputSimplePublicObjectBatchInputUpsert payload, map<string|string[]> headers = {}) returns BatchResponseSimplePublicUpsertObject|error {
        return {
            "completedAt": "2025-01-07T08:47:48.319Z",
            "requestedAt": "2025-01-07T08:47:48.319Z",
            "startedAt": "2025-01-07T08:47:48.319Z",
            "results": [
                {
                    "createdAt": "2025-01-07T08:47:48.319Z",
                    "archived": true,
                    "archivedAt": "2025-01-07T08:47:48.319Z",
                    "new": true,
                    "id": "string",
                    "properties": {
                        "additionalProp1": "string1",
                        "additionalProp2": "string2",
                        "additionalProp3": "string3"
                    },
                    "updatedAt": "2025-01-07T08:47:48.319Z"
                }
            ],
            "status": "COMPLETE"
        };
    }
};

function init() returns error? {
    check httpListener.attach(mockService, "/");
    check httpListener.'start();
}

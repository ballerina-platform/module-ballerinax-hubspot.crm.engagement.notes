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

import ballerina/oauth2;
import ballerina/os;
import ballerina/test;
import ballerina/time;

// Variable to select test mode
configurable boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";

// Variables required for authentication
configurable string clientId = isLiveServer ? os:getEnv("clientId") : "test";
configurable string clientSecret = isLiveServer ? os:getEnv("clientSecret") : "test";
configurable string refreshToken = isLiveServer ? os:getEnv("refreshToken") : "test";

configurable string serviceUrl = isLiveServer ? "https://api.hubapi.com/crm/v3/objects/notes" : "http://localhost:9090/crm/v3/objects/notes";

// ID of the test company created for testing
final string companyId = "27985240367";

final Client hubSpotNotes = check initClient();

isolated function initClient() returns Client|error {
    if isLiveServer {
        OAuth2RefreshTokenGrantConfig auth = {
            clientId,
            clientSecret,
            refreshToken,
            credentialBearer: oauth2:POST_BODY_BEARER
        };
        return check new ({auth}, serviceUrl);
    }
    return check new ({
        auth: {
            token: "test-token"
        }
    }, serviceUrl);
}

@test:Config {
    groups: ["live_tests"],
    enable: isLiveServer
}
isolated function testPost_batch_read_read() returns error? {
    // Create a batch of notes in order to read them later
    BatchInputSimplePublicObjectInputForCreate createPayload =
    {
        inputs: [
            {
                associations: [
                    {
                        types: [
                            {
                                associationCategory: "HUBSPOT_DEFINED",
                                associationTypeId: 190
                            }
                        ],
                        to: {
                            id: companyId
                        }
                    }
                ],
                properties: {
                    "hs_timestamp": time:utcToString(time:utcNow()),
                    "hs_note_body": "Hello World 1"
                }
            },
            {
                associations: [
                    {
                        types: [
                            {
                                associationCategory: "HUBSPOT_DEFINED",
                                associationTypeId: 190
                            }
                        ],
                        to: {
                            id: companyId
                        }
                    }
                ],
                properties: {
                    "hs_timestamp": time:utcToString(time:utcNow()),
                    "hs_note_body": "Hello World 2"
                }
            }
        ]
    };

    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors createResponse = check hubSpotNotes->/batch/create.post(createPayload);
    SimplePublicObject[] createResults = createResponse.results;

    // Read the notes
    BatchReadInputSimplePublicObjectId payload =
    {
        propertiesWithHistory: [],
        inputs: [
            {id: createResults[0].id},
            {id: createResults[1].id}
        ],
        properties: []
    };

    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors response = check hubSpotNotes->/batch/read.post(payload);
    test:assertTrue(response.results.length() > 0);
}

@test:Config {
    groups: ["mock_tests"],
    enable: !isLiveServer
}
function testPost_batch_upsert() returns error? {
    BatchInputSimplePublicObjectBatchInputUpsert payload =
    {
        inputs: [
            {
                idProperty: "unique_property",
                id: "property_value_1",
                properties: {
                    "hs_note_body": "ABC"
                }
            },
            {
                idProperty: "unique_property",
                id: "property_value_2",
                properties: {
                    "hs_note_body": "ABCD"
                }
            }
        ]
    };

    BatchResponseSimplePublicUpsertObject response = check hubSpotNotes->/batch/upsert.post(payload);
    test:assertTrue(response.status is "COMPLETE");
}

@test:Config {
    groups: ["live_tests"],
    enable: isLiveServer
}
isolated function testPost_search_doSearch() returns error? {
    PublicObjectSearchRequest payload1 =
    {
        filterGroups: [
            {
                filters: [
                    {
                        propertyName: "hs_note_body",
                        value: "Hello",
                        operator: "EQ"
                    }
                ]
            }
        ]
    };

    CollectionResponseWithTotalSimplePublicObjectForwardPaging response = check hubSpotNotes->/search.post(payload1);
    test:assertTrue(response.results.length() > 0);

    PublicObjectSearchRequest payload2 =
    {
        filterGroups: [
            {
                filters: [
                    {
                        propertyName: "hs_note_body",
                        value: "Not Hello",
                        operator: "EQ"
                    }
                ]
            }
        ]
    };

    response = check hubSpotNotes->/search.post(payload2);
    test:assertTrue(response.results.length() == 0);
}

@test:Config {
    groups: ["live_tests"],
    enable: isLiveServer
}
isolated function testPost_batch_update_update() returns error? {
    // Create a batch of notes in order to read them later
    BatchInputSimplePublicObjectInputForCreate createPayload =
    {
        inputs: [
            {
                associations: [
                    {
                        types: [
                            {
                                associationCategory: "HUBSPOT_DEFINED",
                                associationTypeId: 190
                            }
                        ],
                        to: {
                            id: companyId
                        }
                    }
                ],
                properties: {
                    "hs_timestamp": time:utcToString(time:utcNow()),
                    "hs_note_body": "Hello World 1"
                }
            },
            {
                associations: [
                    {
                        types: [
                            {
                                associationCategory: "HUBSPOT_DEFINED",
                                associationTypeId: 190
                            }
                        ],
                        to: {
                            id: companyId
                        }
                    }
                ],
                properties: {
                    "hs_timestamp": time:utcToString(time:utcNow()),
                    "hs_note_body": "Hello World 2"
                }
            }
        ]
    };

    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors createResponse = check hubSpotNotes->/batch/create.post(createPayload);
    SimplePublicObject[] createResults = createResponse.results;

    // Update the notes
    BatchInputSimplePublicObjectBatchInput payload =
    {
        inputs: [
            {
                id: createResults[0].id,
                properties: {
                    "hs_note_body": "Greetings 1"
                }
            },
            {
                id: createResults[1].id,
                properties: {
                    "hs_note_body": "Greetings 2"
                }
            }
        ]
    };

    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors response = check hubSpotNotes->/batch/update.post(payload);

    SimplePublicObject[] results = response.results;
    foreach SimplePublicObject result in results {
        test:assertTrue(result.id == createResults[0].id || result.id == createResults[1].id);
    }
}

@test:Config {
    groups: ["live_tests"],
    enable: isLiveServer
}
isolated function testPost_batch_create_create() returns error? {
    BatchInputSimplePublicObjectInputForCreate payload =
    {
        inputs: [
            {
                associations: [
                    {
                        types: [
                            {
                                associationCategory: "HUBSPOT_DEFINED",
                                associationTypeId: 190
                            }
                        ],
                        to: {
                            id: companyId
                        }
                    }
                ],
                properties: {
                    "hs_timestamp": time:utcToString(time:utcNow()),
                    "hs_note_body": "Hello World 1"
                }
            },
            {
                associations: [
                    {
                        types: [
                            {
                                associationCategory: "HUBSPOT_DEFINED",
                                associationTypeId: 190
                            }
                        ],
                        to: {
                            id: companyId
                        }
                    }
                ],
                properties: {
                    "hs_timestamp": time:utcToString(time:utcNow()),
                    "hs_note_body": "Hello World 2"
                }
            }
        ]
    };

    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors response = check hubSpotNotes->/batch/create.post(payload);
    test:assertEquals(response.status, "COMPLETE");
}

@test:Config {
    groups: ["live_tests"],
    enable: isLiveServer
}
isolated function testPost_batch_archive_archive() returns error? {
    // Create a batch of notes in order to read them later
    BatchInputSimplePublicObjectInputForCreate createPayload =
    {
        inputs: [
            {
                associations: [
                    {
                        types: [
                            {
                                associationCategory: "HUBSPOT_DEFINED",
                                associationTypeId: 190
                            }
                        ],
                        to: {
                            id: companyId
                        }
                    }
                ],
                properties: {
                    "hs_timestamp": time:utcToString(time:utcNow()),
                    "hs_note_body": "Hello World 1"
                }
            },
            {
                associations: [
                    {
                        types: [
                            {
                                associationCategory: "HUBSPOT_DEFINED",
                                associationTypeId: 190
                            }
                        ],
                        to: {
                            id: companyId
                        }
                    }
                ],
                properties: {
                    "hs_timestamp": time:utcToString(time:utcNow()),
                    "hs_note_body": "Hello World 2"
                }
            }
        ]
    };

    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors createResponse = check hubSpotNotes->/batch/create.post(createPayload);
    SimplePublicObject[] createResults = createResponse.results;

    // Delete the notes
    BatchInputSimplePublicObjectId payload =
    {
        inputs: [
            {id: createResults[0].id},
            {id: createResults[1].id}
        ]
    };

    error? response = hubSpotNotes->/batch/archive.post(payload);
    test:assertEquals(response, ());
}

@test:Config {
    groups: ["live_tests"],
    enable: isLiveServer
}
isolated function testGet_getById() returns error? {
    // Create a note in order to get it later
    SimplePublicObjectInputForCreate createPayload =
    {
        associations: [
            {
                types: [
                    {
                        associationCategory: "HUBSPOT_DEFINED",
                        associationTypeId: 190
                    }
                ],
                to: {
                    id: companyId
                }
            }
        ],
        properties: {
            "hs_timestamp": time:utcToString(time:utcNow()),
            "hs_note_body": "Hello"
        }
    };

    SimplePublicObject createResponse = check hubSpotNotes->/.post(createPayload);

    // Delete the note
    SimplePublicObjectWithAssociations response = check hubSpotNotes->/[createResponse.id]();
    test:assertNotEquals(response.id, "");
}

@test:Config {
    groups: ["live_tests"],
    enable: isLiveServer
}
isolated function testPatch_update() returns error? {
    // Create a note in order to get it later
    SimplePublicObjectInputForCreate createPayload =
    {
        associations: [
            {
                types: [
                    {
                        associationCategory: "HUBSPOT_DEFINED",
                        associationTypeId: 190
                    }
                ],
                to: {
                    id: companyId
                }
            }
        ],
        properties: {
            "hs_timestamp": time:utcToString(time:utcNow()),
            "hs_note_body": "Hello"
        }
    };

    SimplePublicObject createResponse = check hubSpotNotes->/.post(createPayload);

    // Update the note
    SimplePublicObjectInput payload =
    {
        properties: {
            "hs_note_body": "Greetings"
        }
    };

    SimplePublicObject response = check hubSpotNotes->/[createResponse.id].patch(payload);
    test:assertEquals(response.id, createResponse.id);
}

@test:Config {
    groups: ["live_tests"],
    enable: isLiveServer
}
isolated function testDelete_archive() returns error? {
    // Create a note in order to get it later
    SimplePublicObjectInputForCreate createPayload =
    {
        associations: [
            {
                types: [
                    {
                        associationCategory: "HUBSPOT_DEFINED",
                        associationTypeId: 190
                    }
                ],
                to: {
                    id: companyId
                }
            }
        ],
        properties: {
            "hs_timestamp": time:utcToString(time:utcNow()),
            "hs_note_body": "Hello"
        }
    };

    SimplePublicObject createResponse = check hubSpotNotes->/.post(createPayload);

    // Delete the note
    error? response = hubSpotNotes->/[createResponse.id].delete();
    test:assertEquals(response, ());
}

@test:Config {
    groups: ["live_tests"],
    enable: isLiveServer
}
isolated function testGet_notes_getPage() returns error? {
    CollectionResponseSimplePublicObjectWithAssociationsForwardPaging response = check hubSpotNotes->/();
    test:assertTrue(response.results.length() > 0);
}

@test:Config {
    groups: ["live_tests"],
    enable: isLiveServer
}
isolated function testPost_notes_create() returns error? {
    SimplePublicObjectInputForCreate payload =
    {
        associations: [
            {
                types: [
                    {
                        associationCategory: "HUBSPOT_DEFINED",
                        associationTypeId: 190
                    }
                ],
                to: {
                    id: companyId
                }
            }
        ],
        properties: {
            "hs_timestamp": time:utcToString(time:utcNow()),
            "hs_note_body": "Hello"
        }
    };

    SimplePublicObject response = check hubSpotNotes->/.post(payload);
    test:assertNotEquals(response.createdAt, "");
}

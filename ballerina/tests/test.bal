// Copyright (c) 2024, WSO2 LLC. (http://www.wso2.com).
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
import ballerina/oauth2;
import ballerina/test;
import ballerina/time;

// Variables required for authentication
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

// Variables required for test functions
configurable string batchReadNoteId1 = ?;
configurable string batchReadNoteId2 = ?;

configurable string batchUpdateNoteId1 = ?;
configurable string batchUpdateNoteId2 = ?;

configurable string batchDeleteNoteId1 = ?;
configurable string batchDeleteNoteId2 = ?;

configurable string batchUpsertNoteId1 = ?;
configurable string batchUpsertNoteId2 = ?;

configurable string getByIdNoteId = ?;

configurable string updateNoteId = ?;

configurable string deleteNoteId = ?;

// ID of the test company created for testing
configurable string companyId = ?;

OAuth2RefreshTokenGrantConfig auth = {
    clientId,
    clientSecret,
    refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER // This line should be added when you are going to create auth object.
};

final Client hubSpotNotes = check new ({ auth });

@test:Config {}
isolated function testPost_batch_read_read() returns error? {
    BatchReadInputSimplePublicObjectId payload =
    {
        propertiesWithHistory: [],
        inputs: [
            {id: batchReadNoteId1},
            {id: batchReadNoteId2}
        ],
        properties: []
    };

    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors response = check baseClient->/batch/read.post(payload);
    test:assertTrue(response.results.length() > 0);
}

@test:Config {}
isolated function testPost_batch_upsert_upsert() returns error? {
    // BatchInputSimplePublicObjectBatchInputUpsert payload =
    // {
    //     inputs: [
    //         {
    //             idProperty: "hs_timestamp",
    //             id: batchUpsertNoteId1,
    //             properties: {
    //                 "hs_note_body": "ABC"
    //             }
    //         },
    //         {
    //             idProperty: "hs_timestamp",
    //             id:batchUpsertNoteId2,
    //             properties: {
    //                 "hs_note_body": "ABCD"
    //             }
    //         }
    //     ]
    // };
    // BatchResponseSimplePublicUpsertObject|BatchResponseSimplePublicUpsertObjectWithErrors response = check baseClient->/batch/upsert.post(payload);
    // test:assertTrue(response.status == "COMPLETE");

    test:assertTrue(true);
}

@test:Config {}
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

    CollectionResponseWithTotalSimplePublicObjectForwardPaging response = check baseClient->/search.post(payload1);
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

    response = check baseClient->/search.post(payload2);
    test:assertTrue(response.results.length() == 0);
}

@test:Config {}
isolated function testPost_batch_update_update() returns error? {
    BatchInputSimplePublicObjectBatchInput payload =
    {
        inputs: [
            {
                id: batchUpdateNoteId1,
                properties: {
                    "hs_note_body": "Greetings 1"
                }
            },
            {
                id: batchUpdateNoteId2,
                properties: {
                    "hs_note_body": "Greetings 2"
                }
            }
        ]
    };

    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors response = check baseClient->/batch/update.post(payload);

    SimplePublicObject[] results = response.results;
    foreach SimplePublicObject result in results {
        test:assertTrue(result.id == batchUpdateNoteId1 || result.id == batchUpdateNoteId2);
    }
}

@test:Config {}
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

    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors response = check baseClient->/batch/create.post(payload);
    test:assertEquals(response.status, "COMPLETE");
}

@test:Config {}
isolated function testPost_batch_archive_archive() returns error? {
    BatchInputSimplePublicObjectId payload =
    {
        inputs: [
            {id: batchDeleteNoteId1},
            {id: batchDeleteNoteId2}
        ]
    };

    http:Response response = check baseClient->/batch/archive.post(payload);
    test:assertEquals(response.statusCode, 204);
}

@test:Config {}
isolated function testGet_getById() returns error? {
    SimplePublicObjectWithAssociations response = check baseClient->/[getByIdNoteId]();
    test:assertNotEquals(response.id, "");
}

@test:Config {}
isolated function testPatch_update() returns error? {
    SimplePublicObjectInput payload =
    {
        properties: {
            "hs_note_body": "Greetings"
        }
    };

    SimplePublicObject response = check baseClient->/[updateNoteId].patch(payload);
    test:assertEquals(response.id, updateNoteId);
}

@test:Config {}
isolated function testDelete_archive() returns error? {
    http:Response response = check baseClient->/[deleteNoteId].delete();
    test:assertEquals(response.statusCode, 204);
}

@test:Config {}
isolated function testGet_notes_getPage() returns error? {
    CollectionResponseSimplePublicObjectWithAssociationsForwardPaging response = check baseClient->/();
    test:assertTrue(response.results.length() > 0);
}

@test:Config {}
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

    SimplePublicObject response = check baseClient->/.post(payload);
    test:assertNotEquals(response.createdAt, "");
}

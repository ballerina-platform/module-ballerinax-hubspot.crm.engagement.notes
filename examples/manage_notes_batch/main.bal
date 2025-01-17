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
import ballerina/io;
import ballerina/oauth2;
import ballerina/time;
import ballerinax/hubspot.crm.engagement.notes as hsengnotes;

// Variables required for authentication
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

// ID of the test company created for testing
configurable string companyId = ?;

hsengnotes:OAuth2RefreshTokenGrantConfig auth = {
    clientId,
    clientSecret,
    refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER
};
final hsengnotes:Client hubSpotNotes = check new ({auth});

public function main() returns error? {
    // Create a batch of notes
    hsengnotes:BatchInputSimplePublicObjectInputForCreate createPayload =
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

    hsengnotes:BatchResponseSimplePublicObject|hsengnotes:BatchResponseSimplePublicObjectWithErrors createResponse = check hubSpotNotes->/batch/create.post(createPayload);
    hsengnotes:SimplePublicObject[] notes = createResponse.results;
    string[] noteIds = [];
    foreach hsengnotes:SimplePublicObject note in notes {
        noteIds.push(note.id);
        io:println("Note created with id: ", note.id);
    }

    // Update the batch of notes
    hsengnotes:BatchInputSimplePublicObjectBatchInput updatePayload =
    {
        inputs: [
            {
                id: noteIds[0],
                properties: {
                    "hs_note_body": "Greetings 1"
                }
            },
            {
                id: noteIds[1],
                properties: {
                    "hs_note_body": "Greetings 2"
                }
            }
        ]
    };

    hsengnotes:BatchResponseSimplePublicObject|hsengnotes:BatchResponseSimplePublicObjectWithErrors updateResponse = check hubSpotNotes->/batch/update.post(updatePayload);

    if (updateResponse.status == "COMPLETE") {
        io:println("Notes updated successfully.");
    }

    // Getting the batch of notes
    hsengnotes:BatchReadInputSimplePublicObjectId readPayload =
    {
        propertiesWithHistory: [],
        inputs: [
            {id: noteIds[0]},
            {id: noteIds[1]}
        ],
        properties: []
    };

    hsengnotes:BatchResponseSimplePublicObject|hsengnotes:BatchResponseSimplePublicObjectWithErrors readResponse = check hubSpotNotes->/batch/read.post(readPayload);
    io:println("Notes: ");
    io:println(readResponse.results);

    // Delete the batch of notes
    hsengnotes:BatchInputSimplePublicObjectId deletePayload =
    {
        inputs: [
            {id: noteIds[0]},
            {id: noteIds[1]}
        ]
    };

    http:Response _ = check hubSpotNotes->/batch/archive.post(deletePayload);
}

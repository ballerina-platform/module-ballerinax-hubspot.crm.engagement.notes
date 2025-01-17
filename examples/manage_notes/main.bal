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
    // Creating a note
    io:println("Creating a note...");

    hsengnotes:SimplePublicObjectInputForCreate createPayload =
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
            "hs_note_body": "Spoke with decision maker Carla. Attached the proposal and draft of contract."
        }
    };

    hsengnotes:SimplePublicObject createResponse = check hubSpotNotes->/.post(createPayload);

    string noteId = createResponse.id;
    io:println("Note created with id: ", noteId);

    // Updating the body of the created note
    io:println("Updating the note...");

    hsengnotes:SimplePublicObjectInput payload =
    {
        properties: {
            "hs_note_body": "Spoke with decision maker Carla."
        }
    };

    hsengnotes:SimplePublicObject updateResponse = check hubSpotNotes->/[noteId].patch(payload);
    io:println("Note updated at: ", updateResponse.updatedAt);
    io:println("Updated content: ", updateResponse.properties);

    // Getting the newly updated note
    io:println("Reading the note...");

    hsengnotes:SimplePublicObjectWithAssociations readResponse = check hubSpotNotes->/[noteId]();
    io:println("Note content: ", readResponse.properties);

    // Search for the new note by content
    io:println("Searching for the note containing \"Carla\"...");

    hsengnotes:PublicObjectSearchRequest searchPayload =
    {
        filterGroups: [
            {
                filters: [
                    {
                        propertyName: "hs_note_body",
                        value: "Called to Carla.",
                        operator: "EQ"
                    }
                ]
            }
        ]
    };

    hsengnotes:CollectionResponseWithTotalSimplePublicObjectForwardPaging searchResponse = check hubSpotNotes->/search.post(searchPayload);
    io:println("Results received: ", searchResponse.results);

    // Delete note
    io:println("Deleting note...");

    http:Response _ = check hubSpotNotes->/[noteId].delete();

    // Getting all available notes
    io:println("All notes: ");

    hsengnotes:CollectionResponseSimplePublicObjectWithAssociationsForwardPaging readAllResponse = check hubSpotNotes->/();
    io:println(readAllResponse);
}

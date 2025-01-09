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
    credentialBearer: oauth2:POST_BODY_BEARER // This line should be added when you are going to create auth object.
};
final hsengnotes:Client hubSpotNotes = check new ({ auth });

public function main() returns error? {
    // Create a batch of notes
    engagementNotes:BatchInputSimplePublicObjectInputForCreate createPayload =
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

    engagementNotes:BatchResponseSimplePublicObject|engagementNotes:BatchResponseSimplePublicObjectWithErrors createResponse = check hubSpotNotes->/batch/create.post(createPayload);
    engagementNotes:SimplePublicObject[] notes = createResponse.results;
    string[] noteIds = [];
    foreach engagementNotes:SimplePublicObject note in notes {
        noteIds.push(note.id);
        io:println("Note created with id: ", note.id);
    }

    // Update the batch of notes
    engagementNotes:BatchInputSimplePublicObjectBatchInput updatePayload =
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

    engagementNotes:BatchResponseSimplePublicObject|engagementNotes:BatchResponseSimplePublicObjectWithErrors updateResponse = check hubSpotNotes->/batch/update.post(updatePayload);

    if (updateResponse.status == "COMPLETE") {
        io:println("Notes updated successfully.");
    }

    // Getting the batch of notes
    engagementNotes:BatchReadInputSimplePublicObjectId readPayload =
    {
        propertiesWithHistory: [],
        inputs: [
            {id: noteIds[0]},
            {id: noteIds[1]}
        ],
        properties: []
    };

    engagementNotes:BatchResponseSimplePublicObject|engagementNotes:BatchResponseSimplePublicObjectWithErrors readResponse = check hubSpotNotes->/batch/read.post(readPayload);
    io:println("Notes: ");
    io:println(readResponse.results);

    // Delete the batch of notes
    engagementNotes:BatchInputSimplePublicObjectId deletePayload =
    {
        inputs: [
            {id: noteIds[0]},
            {id: noteIds[1]}
        ]
    };

    http:Response _ = check hubSpotNotes->/batch/archive.post(deletePayload);
}

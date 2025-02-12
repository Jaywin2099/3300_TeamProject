# 3300_TeamProject

This is the home repository for our SLU CSCI 3300 class's team agile project.

# The Swifties

We are currently developing an AR fact-of-the-day IOS app that also scans and reports information on whatever you'd like using image recognition.

# Proposal

https://docs.google.com/document/d/1Eh71lubu4J4SXxOPYAtuUQO7x9CFO4OVhPkMom9wmQE/edit?tab=t.0

# High-Level Design

## Classes

Object Diagram

Objects:

ARModel

Attributes: modelID, modelData

Methods: loadModel(), render()

TextBoard

Attributes: textContent, position

Methods: displayText()

ScreenshotAPI

Attributes: imageData

Methods: sendScreenshot()

CameraView

Attributes: liveFeed, selectedView

Methods: captureImage()

Sidebar

Attributes: savedFacts

Methods: showFacts(), hide()

AIProcessor

Attributes: imageDescription, factData

Methods: translateImageToText(), fetchFacts()

Database

Attributes: storedImages, storedFacts

Methods: saveFact(), retrieveFact()

Relationships:

CameraView captures images and sends to AIProcessor.

AIProcessor processes images and retrieves facts from the Database.

Sidebar displays facts retrieved from the Database.

ARModel loads and renders 3D models based on AIProcessor output.

ScreenshotAPI sends captured images to an external API.

System Diagram

Components:

User Interface (UI)

Camera View

Sidebar

AR Visualization

Settings Page

Feed for previously learned information

AI API

Image Processing (Translation to text, object recognition)

Fact Retrieval (ChatGPT integration for expanded information)

Database

Stores references to previously seen images

Stores vector matches for similar objects

Stores retrieved descriptions and facts

API Integrations

External AI for object recognition

External knowledge databases for facts

Interactions:

UI captures user input and sends images to AI API.

AI API processes image and queries the Database.

Database returns relevant facts and related objects.

UI displays the retrieved information in either AR visualization or sidebar.

Screenshots can be saved and sent to an external API.

UML Class Diagram

Classes:

CameraView

Attributes: liveFeed, selectedView

Methods: captureImage()

ARModel

Attributes: modelID, modelData

Methods: loadModel(), render()

TextBoard

Attributes: textContent, position

Methods: displayText()

Sidebar

Attributes: savedFacts

Methods: showFacts(), hide()

AIProcessor

Attributes: imageDescription, factData

Methods: translateImageToText(), fetchFacts()

Database

Attributes: storedImages, storedFacts

Methods: saveFact(), retrieveFact()

ScreenshotAPI

Attributes: imageData

Methods: sendScreenshot()

Relationships:

CameraView → AIProcessor (uses AI to analyze images)

AIProcessor → Database (stores/retrieves data)

AIProcessor → ARModel (displays relevant 3D models)

AIProcessor → Sidebar (sends facts for display)

CameraView → ScreenshotAPI (sends screenshots externally)

Sidebar → Database (fetches saved facts for display)


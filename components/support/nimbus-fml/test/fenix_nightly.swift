/* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import FeatureManifest
import Foundation

let nimbus = MyNimbus.shared;

let feature = nimbus.features.homescreen.value()
assert(feature.sectionsEnabled[HomeScreenSection.topSites] == true)
assert(feature.sectionsEnabled[HomeScreenSection.jumpBackIn] == true)
assert(feature.sectionsEnabled[HomeScreenSection.recentlySaved] == true)
assert(feature.sectionsEnabled[HomeScreenSection.recentExplorations] == true)
assert(feature.sectionsEnabled[HomeScreenSection.pocket] == true)

// Test whether we can selectively override the property based default.
let api = MockNimbus(("homescreen", """
{
    "sections-enabled": {
        "pocket": false
    }
}
"""), ("nimbus-validation", """
{
    "settings-title": "hello"
}
"""), ("search-term-groups",  """
{
    "enabled": true
}
"""))
shared.api = api
let feature1 = nimbus.features.homescreen.value()
assert(feature1.sectionsEnabled[HomeScreenSection.topSites] == true)
assert(feature1.sectionsEnabled[HomeScreenSection.jumpBackIn] == true)
assert(feature1.sectionsEnabled[HomeScreenSection.recentlySaved] == true)
assert(feature1.sectionsEnabled[HomeScreenSection.recentExplorations] == true)
assert(feature1.sectionsEnabled[HomeScreenSection.pocket] == false)

// Record the exposure and test it.
nimbus.features.homescreen.recordExposure()
assert(api.isExposed(featureId: "homescreen"))

let validationFeature = nimbus.features.nimbusValidation.value()
assert(validationFeature.settingsTitle == "hello")
assert(validationFeature.settingsPunctuation == "")
assert(validationFeature.settingsIcon == "mozac_ic_settings")
// Record the exposure and test it.
nimbus.features.nimbusValidation.recordExposure()
assert(api.isExposed(featureId: "nimbus-validation"))

let searchTermGroupsFeature = nimbus.features.searchTermGroups.value()
assert(searchTermGroupsFeature.enabled == true)

nimbus.features.searchTermGroups.recordExposure()
assert(api.isExposed(featureId: "search-term-groups"))

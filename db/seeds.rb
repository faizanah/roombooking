PaperTrail.enabled = false

adc = CamdramVenue.create(camdram_id: 29)
bar = CamdramVenue.create(camdram_id: 68)
larkum = CamdramVenue.create(camdram_id: 69)
playroom = CamdramVenue.create(camdram_id: 30)
adc_venues = [adc, bar, larkum]
playroom_venues = [playroom]

Room.create(name: 'Stage', camdram_venues: adc_venues)
Room.create(name: 'Larkum Studio', camdram_venues: adc_venues)
Room.create(name: 'Dressing Room 1', camdram_venues: adc_venues)
Room.create(name: 'Dressing Room 2', camdram_venues: adc_venues)
Room.create(name: 'Bar', camdram_venues: adc_venues)
Room.create(name: 'Playroom Auditorium', camdram_venues: playroom_venues)
Room.create(name: 'Playroom Dressing Room 1', camdram_venues: playroom_venues)
Room.create(name: 'Playroom Dressing Room 2', camdram_venues: playroom_venues)

cj = User.create(name: "Charlie Jonas", email: "charlie@charliejonas.co.uk", admin: true, sysadmin: true, blocked: false)
ProviderAccount.create(provider: "camdram", uid: "3807", user: cj)

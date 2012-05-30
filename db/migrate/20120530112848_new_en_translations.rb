class NewEnTranslations < ActiveRecord::Migration

  TRANSLATIONS = YAML.load(
    File.read(File.expand_path( __FILE__ )).split('__END__').last )

  def up
    ActiveRecord::Base.transaction do

      # Update Questions and Answers

      QuestionSet.where(name: %w( mixer2050 gasmixer )).each do |set|
        say_with_time "Updating #{ set.name } translations" do
          update_question_set_translations!(set)
        end
      end

      # Update pop-up messages.

      say_with_time 'Updating popup translations' do
        Popup.all.each do |popup|
          popup_tr = TRANSLATIONS['popup'].fetch(popup.code)

          popup.title_en = popup_tr['title']
          popup.body_en  = popup_tr['body']

          popup.save!

          say "  Updated #{ popup.code } popup"
        end
      end

    end # Transaction.
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  #######
  private
  #######

  # Given a question set, updates the English translations for all of the
  # related questions and answers.
  def update_question_set_translations!(question_set)
    translations = translation_for(TRANSLATIONS, question_set.name.strip)

    question_set.questions(includes: :answers).each do |question|
      question_tr = translation_for(translations, question.text_nl.strip)
      answers_tr  = question_tr['answers']

      question.text_en        = question_tr['text']
      question.description_en = question_tr['description']

      question.save!

      say "  Saved question: #{ question.text_nl[0..60] } (#{ question.id })"

      question.answers.each do |answer|
        answer.text_en = translation_for(answers_tr, answer.text_nl.strip)
        answer.save!

        say "    Saved answer: #{ answer.text_nl[0..60] } (#{ answer.id })"
      end
    end
  end

  # Returns the translation identified by "key". If the key is not present, an
  # exception is raised. The given key will be truncated immediately prior to
  # a newline since YAML is a bit iffy with newlines in hash keys.
  def translation_for(translations, key)
    key = key.split(/\r?\n/, 2).first

    unless translations.key?(key)
      error = [
        "No translation #{ key.inspect }, available:", "",
        translations.keys.map { |s| "  - #{s}" }.join("\n") ]

      raise error.join("\n")
    end

    found = translations[key]
  end

end

__END__
---
gasmixer:
  "Wat denk jij dat er met onze welvaart gaat gebeuren tussen 2011 en 2030?":
    text: "What do you think will happen to our prosperity between 2011 and 2030?"
    description: |-
      Let's start with a question about growth of the economy and energy use:<br/>
      If we all become more prosperous, we will use more energy. We will own more appliances, larger homes, and will travel more. [Growing consumption](/info/consumption) will lead to higher industrial output. Even if our fellow countrymen do not consume more, our economy may still grow because of increasing exports to a [rapidly growing global population](/info/world_population).<br/>
      If the economy shrinks, exactly the opposite is expected to happen.
    answers:
      "Ik word een beetje rijker en Nederland ook. De economie groeit langzaam.": "I will be a little wealthier, as will be my country. The economy will grow slowly."
      "Ik blijf even rijk en Nederland blijft even rijk. De economie groeit soms een beetje en krimpt soms een beetje.": "My wealth – and that of my country – will remain the same. The economy will occasionally grow and shrink a little."
      "Ik word misschien wel rijker maar de Nederlanders worden langzaam armer. De economie krimpt langzaam": "I will likely grow wealthier, but many will become slightly poorer than today. The economy will slowly shrink."
      "Mijn familie en ik worden net als de meeste Nederlanders veel rijker. De economie groeit snel.": "My family and I will become quite a lot richer, as will most others in my country. The economy will grow quickly."

  "Hoe verandert de prijs van aardgas tussen 2011 en 2030?":
    text: "How will the price of natural gas change from 2011 to 2030?"
    description: |-
      Your vision of the future will be strongly influenced by future energy costs. <br/>
      Energy prices may rise due to [increased demand](/info/demand_growth), global population growth or increased prosperity. Of course, the cost of extracting fossil fuels may also rise, for example because more natural gas comes from [shale gas formations](/info/unconventional_gas). <br/>
      Some developments may lower prices, such as increased [savings](/info/savings), finds of large reserves of natural gas, or falling costs of [renewable energy](/info/renewable).
    answers:
      "Het blijft even duur. De energierekening bij ons thuis blijft gelijk.": "Everything will cost the same as it does today. Our energy bill will not change."
      "Het wordt duurder. Ieder jaar stijgt de energierekening een klein beetje.": "Prices will rise and every year our energy bill will be a little higher."
      "Ieder jaar wordt de energierekening bij ons thuis fors duurder. Ons gezin houdt minder geld over voor leuke dingen als vakanties en mooie spullen.": "Every year our energy bill will be considerably higher. My family will have less money to spend on holidays or luxuries."
      "Het wordt goedkoper. De energierekening wordt ieder jaar iets lager.": "Everything will become a little cheaper and our energy bill will be lower each year."
      "Het wordt veel goedkoper. En dus houden we meer geld over voor leuke dingen.": "Everything will become much cheaper. My family will have more money to spend on doing nice things."

  "Hoe kunnen we het beste onze huizen verwarmen in 2030?":
    text: "What is the best option for heating our homes in 2030?"
    description: |-
      Gas-fired heating became available in our country in the 1960s. In some countries, more than 90% of homes are still heated this way.<br/>
      Today, technology has become available to make more efficient use of natural gas for both heating and cooling. Which devices do you prefer: high-yield boilers, [micro-CHPs](/info/micro_chp), [gas-powered heat pumps](/info/heat_pumps_gas), or [electric heat pumps](/info/heat_pumps_el) which draw heat from the ground?
    answers:
      "Alle huizen verwarmen met een HR-combi ketel": "Heat all homes using high-yield gas boilers."
      "Alle huizen verwarmen met een HRe ketel (= micro-WKK)": "Heat all homes using micro-CHPs."
      "Alle huizen verwarmen met gaswarmtepompen": "Heat all homes using gas-powered heat pumps."
      "Alle huizen verwarmen met een elektrische warmtepomp en bodemwarmte": "Heat all homes using electric heat pumps which draw heat from the ground."

  "Hoe kunnen we het beste koken in 2030?":
    text: "What is the best technology for cooking in 2030?"
    description: |-
      We traditionally tend to cook using gas, but electric cooking is increasingly common. There are several different electric technologies: resistive, halogen, and induction stoves. Does this even make much impact when it comes to energy use?
    answers:
      "Iedereen kookt op gas": "Everyone will use gas."
      "Iedereen kookt op elektrische kookplaten": "Everyone will use resistive electric stoves."
      "Iedereen kookt op halogeen kookplaten": "Everyone will use halogen stoves."
      "Iedereen kookt op inductie kookplaten": "Everyone will use induction stoves."
      "Iedereen kookt op hout": "Everyone will cook on wood-fired stoves."

  "Nu neem je misschien vaak de auto, maar wat ga jij in de toekomst doen?":
    text: "Nowadays you may still take your car to go places, but what will you do in the future?"
    description: |-
      Cars use approximately 10% of all energy in our country. Their use is still growing. This trend is partly to blame for declining air quality and traffic congestion. Governments tend to want to stimulate the use of public transport as much as possible.<br/>
      The extent to which this will be successful depends on future fuel prices. Should oil prices remain high, more people will either not take their cars or avoid buying one altogether.
    answers:
      "Ik ga dan ook overal naartoe met de auto. Mijn werk, de school van de kinderen en familiebezoek doe ik allemaal met de auto.": "I will still use my car to go everywhere such as work, school, and family visits."
      "Ik probeer zoveel mogelijk met de fiets te doen en als het handig is ga ik soms met de bus en de trein. Voor de rest gebruik ik de auto.": "I will try and use my bicycle as much as I can, and use public transport when it is convenient. For all other places I will still need my car."
      "Ik ga alleen nog maar met de bus, de trein en op de fiets. Ik neem later geen auto.": "I will only use public transport or my bicycle; I will not buy a car."

  "De EU wil dat er in onze steden in 2050 geen auto's meer op benzine of diesel rijden, maar waar gaan we dan in rijden?":
    text: "The EU plans to ban gasoline and diesel-fuelled cars from cities in 2050, but what will we use instead?"
    description: |-
      Gasoline and diesel-fuelled engines require cooling, and this results in energy being wasted. Friction inside the engine and gear box also cause further losses.<br/>
      There is an alternative: electric motors need almost no cooling and experience less friction. Of course, electric cars are weighed down by heavy battery packs resulting in higher energy consumption.
    answers:
      "Ik blijf rijden op benzine of diesel en we komen in opstand tegen de EU.": "I will not give up my gasoline or diesel-fuelled car and will rise up against the EU."
      "Ik ga rijden op aardgas net als de rest van de Nederlanders": "My fellow citizens and I will start using vehicles powered by natural gas."
      "We gaan allemaal op elektriciteit rijden. De elektriciteit die daarvoor nodig is importeren we uit het buitenland.": "Everyone will use electric cars with the required electricity imported from neighboring countries."
      "We gaan allemaal op elektriciteit rijden. De elektriciteit wordt opgewekt met windmolens op land.": "Everyone will use electric cars. The electricity required will be generated using inland wind turbines."

  "Wat voor nieuwe elektriciteitscentrales moeten we bouwen?":
    text: "What kind of power plants should we build in the future?"
    description: |-
      In the near future our country will need new power plants. Will they be coal, nuclear, gas, biomass, wind or solar power plants? Each choice has its own pros and cons; which advantage will you exploit, and which disadvantages do you want to avoid?
    answers:
      "De helft van alle centrales wordt vervangen door moderne kolencentrales": "Half of our power plants will be replaced by modern, coal-fired power plants."
      "De helft van alle centrales wordt vervangen door moderne gascentrales": "Half of our power plants will be replaced by modern, gas-fired power plants."
      "De helft van alle centrales wordt vervangen door kerncentrales": "Half of our power plants will be replaced by nuclear power plants."
      "De helft van alle centrales wordt vervangen door windmolenparken op zee": "Half of our power plants will be replaced by off-shore wind turbines."
      "De helft van alle centrales wordt vervangen door zonnepanelen op daken, parkeerplaatsen, vuilstortplaatsen, etc.": "Half of our power plants will be replaced by solar power panels on rooftops, car parks, garbage dumps, etc."

  "Wat doen we als ons aardgas in de toekomst steeds verder opraakt?":
    text: "What will we do when our natural gas reserves run out?"
    description: |-
      The Netherlands are fully self-sufficient when it comes to their natural gas needs and they are the largest natural gas exporter in the EU. Such 'easy gas' is rapidly running out, however; production in 2030 will be at only half the level they are today, and reserves will be depleted by 2050. Nowadays, revenues from natural gas are approximately 600 euros per citizen, but in the future this money will need to be spent on obtaining natural gas from abroad.
    answers:
      "Helemaal niets. De aardgasbaten van de overheid dalen weliswaar met 10 miljard per jaar en er gaat meer geld naar het buitenland om het in te kopen, maar daar is verder niets aan te doen.": "We will not do anything. Government revenues will decrease by approximately 10 billion euros a year and more money will be needed for foreign energy supplies, but nothing can be done to stop this."
      "Alle gebouwen isoleren we verplicht maximaal, zelfs de bestaande huizen. De verwarming voor woningen heb je eerder al ingevuld. De verwarming van overige gebouwen doen we ook zo efficiënt mogelijk.": "All buildings will be obliged to maximize their insulation, even existing homes. You have already chosen your household heating options in a previous question, while other buildings will be heated as efficiently as possible. This will require a combination of [heat pumps](/info/heat_pumps), [micro-CHPs](/info/micro_chp), [fuel cells](/info/fuel_cells), [solar water heaters](/info/solar_water_heater), geothermal heating, and [heating networks](/info/heat_network)."
      "Alle nieuwe huizen en andere gebouwen worden maximaal geïsoleerd, zodat daar bijna geen verwarming meer nodig is.": "All new homes and other buildings will be completely insulated, so they will no longer require any energy for heating."
      "Alle nieuw gebouwde huizen en alle gebouwen (zoals kantoren, scholen, ziekenhuizen en zwembaden) worden maximaal geïsoleerd, zodat ze bijna geen warmte meer nodig hebben.": "All new homes and all buildings (offices, schools, swimming pools, hospitals, etc.) will be completely insulated, so they no longer require any heating."

  "Wil jij in 2030 groen gas gebruiken in plaats van aardgas?":
    text: "Will your country use green gas instead of natural gas in 2030?"
    description: |-
      'Green gas' is often mentioned as a renewable alternative to natural gas; it is biogas which is cleaned and upgraded to natural gas quality, and can be fed into the gas mains. It is usually produced from manure and biomass (digestion). However, it requires vast amounts of biomass to make enough green gas to supply a whole country. The Netherlands has too little domestic biomass to do so, but does have a large port at their disposal for importing biomass.
    answers:
      "Groen gas is gewoon veel te duur. Ik zet geen groen gas in.": "Green gas is far too expensive and my country will not use it."
      "2% Groen gas. Ik gebruik alleen Nederlandse biomassa hiervoor.": "2% green gas: my country will only use domestic biomass."
      "5% Groen gas. Ik importeer ook biomassa uit het buitenland die ik vervolgens omzet in Groen gas": "5% green gas: my country will import some of the required biomass."
      "10% groen gas. Ik ga overal uit de wereld biomassa halen. Desnoods ten koste van natuur en voedsel voor mens en dier.": "10% green gas: my country will import biomass from around the world, even if this might be at the expense of food production."

mixer2050:
  "Wat denkt u dat onze economie gaat doen tussen 2011 en 2050?":
    text: "What do you think will happen to our economy between 2011 and 2050?"
    description: |-
      If we all become more prosperous, we will use more energy. We will own more appliances, larger homes, and will travel more. In recent years there has been an economic growth of 2%, with a 1% growth in energy consumption. [Growing consumption](/info/consumption) will lead to higher industrial output. Even if our fellow countrymen do not consume more, our economy may still grow because of increasing exports to a [rapidly growing global population](/info/world_population).<br/>
      If the economy shrinks, exactly the opposite is expected to happen.
    answers:
      "De economie groeit langzaam": "The economy will slowly grow"
      "De economie groeit soms een beetje en krimpt soms een beetje": "The economy will occasionally grow and shrink a little."
      "De economie krimpt langzaam": "The economy will slowly shrink."
      "De economie groeit snel": "The economy will grow quickly."

  "Hoe verandert volgens u de prijs van energie in 2050 (zonder inflatie)?":
    text: "How will the price of energy change by 2050 (excluding inflation)?"
    description: |-
      Energy prices may rise due to [increased demand](/info/demand_growth), global population growth or increased prosperity. Of course, the cost of extracting fossil fuels may also rise, for example because more natural gas comes from [shale gas formations](/info/unconventional_gas). <br/>
      Some developments may lower prices, such as increased [savings](/info/savings), finds of large reserves of natural gas, or falling costs of [renewable energy](/info/renewable).
    answers:
      "Fossiele brandstoffen blijven even duur, hernieuwbare bronnen worden iets goedkoper": "Fossil fuels remain at their current prices, but renewable energy will get a little cheaper."
      "Fossiele brandstoffen worden duurder, hierdoor worden hernieuwbare bronnen goedkoper": "Fossil fuels become more expensive, with renewable energy becoming less expensive."
      "Fossiele brandstoffen worden veel duurder. Hierdoor wordt meer in hernieuwbare energie geïnvesteerd, en wordt hernieuwbaar juist goedkoper": "Fossil fuels will become vastly more expensive, with the revenue being invested in cheaper renewables."
      "Fossiele brandstoffen en hernieuwbare bronnen worden beide een beetje goedkoper": "Both fossil fuels and renewable energy will be a bit cheaper."
      "Fossiele brandstoffen worden veel goedkoper, waardoor hernieuwbare bronnen nauwelijks goedkoper worden": "Fossil fuels will be less expensive, with little difference in price between fossil fuels and renewable sources."

  "Wat vindt u dat we moeten doen om voldoende energie beschikbaar te hebben in Nederland in 2050?":
    text: "What do you think should be done to meet energy demand in 2050?"
    description: |-
      Presently, the Netherlands is a net producer of natural gas; only half of the gas produced is used while the other half is exported with long-term contracts.
      However, conventional sources of gas [are declining](/info/declining_gas_production) and will be completely exhausted by 2050.
    answers:
      "Aardgas importeren, met name uit Rusland en het Midden Oosten": "The natural gas we need will be imported from Russia and the Middle East."
      "Dit opvangen door aardgas te importeren en een flink deel met besparingen teniet te doen": "Large amounts of natural gas will be imported, nullifying savings elsewhere."
      "De helft opwekken met energie uit 'eigen' <em key='biomass'>biomassa</em>, zon en wind en een flink deel uit energiebesparing halen": "Half of our energy needs will be met with <em key='biomass'>biomass</em>, <em key='geothermal'>geothermal</em>, solar, and wind-power."
      "Het tekort aan aardgas zoveel mogelijk uit andere, eigen energiebronnen halen zoals <em key='biomass'>biomassa</em>, <em key='geothermal'>geothermie</em>, zon en wind energie-import zo klein mogelijk te houden": "As much energy as possible will be sourced from <em key='biomass'>biomass</em>, <em key='geothermal'>geothermal</em>, solar, and wind-power, keeping imports as low as possible."

  "Wat vindt u dat we in Nederland moeten doen om de uitstoot van CO2 broeikasgas te laten dalen?":
    text: "What do you think should be done to reduce CO2 emissions?"
    description: |-
      The use of fossil fuels to generate energy results in emissions of CO2, with these emissions likely resulting in significant contributions to climate change.
      More information on such warming can be found on <a class='no_popup' target='_blank'  href='http://climate.nasa.gov/keyIndicators/'>NASA's website</a>.
    answers:
      "Niets. Ik twijfel aan het verband tussen CO2-uitstoot en de opwarming van de aarde. Bovendien: andere landen gaan toch door met de CO2 uitstoot, een actieve houding van Nederland zal weinig effect hebben": "Nothing should be done; I doubt the link between CO2 emissions and climate change. Moreover, as other countries continue to produce CO2, a change of attidude in the Netherlands would likely have little effect."
      "Maximale inzet van hernieuwbare opwek: zon, wind, waterkracht, geothermie en schone biomassa": "We would use as much renewable energy as possible: solar, wind, hydroelectric power, geothermal, and clean biomass should be used to their maxiumum potential."
      "Maximale inzet van CO2-neutrale opwek, dus hernieuwbare maar ook kernenergie": "We should focus on using CO2-neutral sources – not only renewables sources, but also nuclear fission."
      "Vervangen van kolencentrales door CO2 arme bronnen zoals aardgascentrales. De laatste stoten maar half zoveel CO2 uit": "Replace coal power plants with less-polluting sources such as natural gas plants which emit only half as much CO2."
      "Alleen <em key='carbon_capture_storage'>opvang en opslag van CO2</em> uit grote emissiebronnen (bv kolencentrales en olieraffinaderijen)": "Only use <em key='carbon_capture_storage'>capture and storage</em> of CO2 on major sources (e.g. coal power plants and refineries)."

  "Welke 'brandstoffen' zullen we in 2050 naar uw verwachting gebruiken voor het Nederlandse wegverkeer?":
    text: "What fuel would you like to see powering road vehicles in 2050?"
    description: |-
      Approximately 18% of all energy used in our country is spent on cars, buses, and trucks. At present, almost all trucks use diesel (with a few percent using [biodiesel](/info/biodiesel)).
      The number of [electric cars](/info/electric_cars) is still negligible, but if the EU plans to ban petrol and diesel vehicles in cities (by 2050) goes ahead, this situation may change.
    answers:
      "Ondanks de plannen van de EU blijven we nog steeds hoofdzakelijk op benzine en diesel rijden.": "Regardless of the EU plans, we will remain mostly using petrol and diesel."
      "Benzine en diesel met een kwart biobrandstof bijgemengd": "Petrol and diesel will still be used, but around 25% of vehicles will use biofuels."
      "De helft van de auto's rijdt nog op benzine/diesel/biobrandstof, de andere helft op elektriciteit, waarbij de elektriciteit voornamelijk opgewekt is met gasgestookte <em key='fuel_cells'>brandstofcellen</em> in de gebouwde omgeving": "Half of cars will continue to use petrol, diesel, and biofuels, with the other half on electricity. This electricity is generated using gas-fired <em key='fuel_cells'>fuel cells</em>."
      "Driekwart van de auto's rijdt op elektriciteit waarbij de elektriciteit geheel uit hernieuwbare bronnen komt, een kwart van de auto's rijdt nog op benzine/diesel/biobrandstof.": "Three quarters of vehicles will be powered with electricity from renewable sources, with the rest using petrol, diesel, and biofuel."

  "Wat verwacht u dat er in 2050 is veranderd in de energiebehoefte van huizen en gebouwen?":
    text: "How do you expect the energy needs of homes and offices to change by 2050?"
    description: |-
      Homes and office buildings currently consume 28% of energy in the Netherlands, with 52% of that used on heating and cooling. Most energy for heating comes from burning natural gas. Better insulation could eliminate the need for energy to be used on heating and cooling.
    answers:
      "De energiebehoefte blijft ongeveer gelijk. De huizen worden wel steeds iets zuiniger maar de mensen gaan ook steeds luxer leven": "Energy use will remain much as it is today. Homes may be better insulated, but this is negated by better prosperity."
      "Nieuwe gebouwen zijn zo goed ge&#239;soleerd dat ze met de helft van het aardgas toe kunnen": "New buildings will be very well-insulated, halfing the amount of natural gas consumed for heating."
      "Oude en nieuwe gebouwen zijn goed ge&#239;soleerd en kunnen met de helft minder aardgas toe": "Both old and new buildings will be well-insulated."
      "Oude en nieuwe gebouwen zijn goed ge&#239;soleerd en maken gebruik van de nieuwste verwarmingstechnieken (<em key='micro_chp'>HRe</em>, <em key='heat_pumps'>warmtepompen</em> op gas of elektriciteit, hout-CV kachels en gasgestookte <em key='fuel_cells'>brandstofcellen</em>).": "Both new and old buildings will be extremely well-insulated, with the latest heating technology – <em key='micro_chp'>Micro CHPs</em>, <em key='heat_pumps'>heat pumps</em>, and <em key='fuel_cells'>gas-fired fuel cells</em> – being used extensively."

  "Naar uw verwachting zal de industrie tot 2050:":
    text: "How will industry change by 2050?"
    description: |-
      The Netherlands is an industry-rich country; the [energy needs of the industry](/info/energy_intensity) amounts to 47% of total demand (for comparison, in England this figure is only 25%).
      If the people of the world become more prosperous, industry can be expected to grow. To learn more about how we have become richer and healthier, see Han Rosling's <a class="iframe" href="http://youtube.com/embed/jbkSRLYSojo?rel=0" class="cboxElement">200 Countries, 200 Years, 4 Minutes</a>.
    answers:
      "Groeien door een snel groeiende wereldeconomie en de behoefte aan energie stijgt navenant": "The world economy will grow rapidly, significantly increasing energy use."
      "Groeien, maar de energiebehoefte stijgt minder snel door groeiende effici&euml;ntie in energiegebruik": "The world economy will grow modestly, but energy use increases less rapidly thanks to higher efficiencies."
      "Langzaam groeien, de energiebehoefte stijgt ook maar licht": "The economy will grow slowly, as will energy use."
      "Langzaam groeien en door verregaande effici&euml;ntie daalt de energiebehoefte licht": "The economy will grow slowly, but energy efficiency will get worse."
      "Langzaam krimpen (produktie is hier te duur), energiebehoefte neemt navenant af": "The economy will shrink as production becomes more expensive. Energy use falls accordingly."

  "Waar komt de benodigde energie voor tuinbouw vandaan in 2050?":
    text: "From where will agricultural energy come in 2050?"
    description: |-
      Agriculture in the Netherlands is responsible for 7% of energy demand. At least 80% of that comes from greenhouses, with the rest being spent on crops and livestock.
      At present, almost all this energy comes from natural gas.
    answers:
      "Onveranderlijk uit fossiele energiebronnen": "Energy continues to be sourced from fossil fuels."
      "Voor een kwart uit zelf opgewekte energie uit biomassa en de rest uit fossiele energie": "A quarter of energy will be generated with biomass, and the rest with fossil fuels."
      "Voor een kwart uit zelf opgewekte energie met zonnewarmte en biomassa, een kwart met geothermische energie en de helft met fossiele energie": "A quarter of energy will come from solar and biomass, a quarter from geothermal sources, and the remaining half from fossil fuels."
      "Voor 25% uit eigen biomassa en zonnewarmte en voor 75% uit geothermie": "A quarter of energy is sourced from biomass, and the rest from geothermal."

popup:
  geothermal:
    title: "Geothermal energy: the earth's heat as an energy source"
    body: |-
      In theory, quite a lot of energy can be extracted from the Earth; at large depths the planet is extremely hot. This heat can be used for heating homes, providing energy for chemical industry, or making electricity. Whether such heat is affordable mostly depends on how deep one has to drill to extract it.

  unconventional_oil:
    title: "Unconventional oil"
    body: |-
      Most recently-discovered oil deposits have tended to be in places that are hard to reach, or of oil that requires a lot of energy to process. 'Easy' oil is hardly ever found anymore. Such difficult oil fields may lie many kilometres below sea level or in inhospitable places like the Arctic. Some kinds of difficult oil need to be extracted from tar sands or shale rock formations. Such oil is called 'unconventional oil'.<br/>
      In the future, oil companies are expected to produce more unconventional or difficult oil. Oil production is therefore also expected to become more expensive.

  renewable:
    title: "Renewable energy"
    body: |-
      Renewable energy comes from inexhaustible sources and includes wind, solar, geothermal, and tidal energy. Biomass, like wood or sugar cane, also counts so long as it has been grown by sustainable agriculture.

  declining_gas_production:
    title: "Declining natural gas production"
    body: |-
      The Dutch Energy Management Agency EBN ('Energiebeheer Nederland') decides what should be done with Dutch natural gas. EBN expects natural gas production from Dutch fields to decline to zero within the next 40 years as the fields are exhausted. These predictions take into account the long-term supply contracts that the Netherlands have with various other countries.<br/><br/>
      This concerns conventional gas; such gas can be extracted using ordinary, well-established drilling techniques. 'Unconventional' gas is extracted using techniques that have not yet been put to the test extensively in Europe. Some people have high expectations for such gas for Europe, because the United States has been quite successful in extracting it. As yet it is unclear how much unconventional gas reserves our country has, or how much extraction would cost.

  biomass:
    title: "Energy from biomass"
    body: |-
      Biomass is the technical term for 'biological material'. Biomass from plant or animal residues contains energy. In many countries, energy crops are grown at the expense of food production.

  biodiesel:
    title: "Biodiesel"
    body: |-
      Biodiesel can be produced from both animal and vegetable fats; oils from rape seeds or seed flax are especially popular in Europe. Oils from aquatic algae have caused a bit of a stir too, since they do not require the use of precious arable land. As yet, algae diesel is not a profitable option.<br/><br/>
      Diesel-powered cars can use biodiesel without any adjustments to their engines, but vegetable oils can decrease engine lifetimes.

  electric_cars:
    title: "Electric cars"
    body: |-
      Electric cars are an issue which have caused much discussion in Europe. Since their well-to-wheels energy use is less than half that of fossil-fuelled cars, this is no surprise! Of course, generating electricity from renewable sources would only increase their clean appeal. Electric cars do not emit noxious gases and they are quiet.<br/>
      Of course, they do have some disadvantages. Battery packs are expensive and do not have the storage capacity or lifetime of a fuel tank. Although technical developments are proceeding apace, electric cars have not yet proven to be as attractive as fossil-fuelled cars.<br/>
      A typical electric saloon car can now drive 150 - 250 km with a full battery. Such a car may be quite suitable for small, densely populated countries.<br/><br/>
      Although the technology to create electric cars is available, the necessary infrastructure for charging or changing batteries is not. When – or even whether – it will be available will strongly influence their chances of success.

  carbon_capture_storage:
    title: "Capture and storage of CO2"
    body: |-
      Major sources of CO2 – such as coal or gas power plants, blast furnaces, and oil refineries – offer the possibility of capturing and storing emissions. Current capture techniques are energy intensive but typically result in the capture of 90% of CO2 emissions.

  demand_growth:
    title: "Demand growth according to Royal Dutch Shell"
    body: |-
      It is to be expected that energy demand will increase threefold between 2000 and 2050 as a result of a growing world population and increased global prosperity. For more information you can read the Shell Scenarios in <a class='no_popup' target='_blank' href='http://www-static.shell.com/static/aboutshell/downloads/aboutshell/signals_signposts.pdf'>Signals and Signposts</a>.

  Savings:
    title: "Global savings in energy demand and efficiency increases"
    body: |-
      It is likely that the world population will keep trying to be more energy efficient and use less energy than it does presently. Despite these efforts, a large gap looms between expected demand and supply of energy in the coming years, as energy production fails to keep up with rapidly rising demand. For more information, read the Shell Scenarios in <a class='no_popup' target='_blank' href='http://www-static.shell.com/static/aboutshell/downloads/aboutshell/signals_signposts.pdf'>Signals and Signposts</a>.

  micro_chp:
    title: "Micro CHP"
    body: |-
      A micro CHP (Combined Heat and Power) is a gas-fired heater which also produces electricity. Households that use them become power producers, with excess power used locally, or sold back to the national grid. Using this power locally makes for more efficient use of natural gas. Micro CHPs are still rather expensive, but costs are expected to fall as more are installed.

  heat_pumps:
    title: "Heat pumps"
    body: |-
      Heat pumps can move heat from one place to another, and are driven by gas or by electricity.<br/>
      Fridges use heat pumps to pump heat out, but the same principles can be used to pump heat into your home from outside. This can be quite efficient, provided it is not too cold outside.

  fuel_cells:
    title: "Fuel cells"
    body: |-
      Fuel cells combust fuels like natural gas or hydrogen after dissolving them; they are extremely efficient and can produce both power and heat. Small fuel cells can be used to run continuously and provide hot water for showering etc. Owners of fuel cells will thereby become power producers. Fuel cell are still quite expensive, but may become cheaper in the next 10 to 20 years.

  energy_intensity:
    title: "Energy demand for industry"
    body: |-
      Industrial processes tend to become ever more energy efficient. The graph below shows how energy intensity of Dutch industry (energy used per euro of value added) has changed through the years.<br/>
      <img width='381' height='204' src='/assets/popups/energy_intensity.png' />

  world_population:
    title: "Growing world population"
    body: |-
      Population growth has slowed significantly in most wealthy countries, but in developing countries strong growth is expected to continue. The chart shows historical and expected population growth according to the UN for the near future.<br/>
      <img height='503', width='492', src='/assets/popups/world_population.png'/>

  consumption:
    title: "Consumption in households"
    body: |-
      Consumption of goods and services in households continues to rise. Here you can see how consumption has increased over the past years.<br/>
      <img width = '381', height='204', src='/assets/popups/growth_household_consumption.png'/>

  unconventional_gas:
    title: "Unconventional gas"
    body: |-
      The term 'unconventional gas' refers to natural gas that does not come from 'normal' gas fields. It is found in very tight rock formations, making it hard to extract. Rocks need to be fractured, or 'fracked', by injecting water and chemicals at high pressures. This makes such gas harder, and therefore more expensive, to extract.<br/>
      Unconventional gas deposits are much larger than 'easy' gas reserves. The United States has significantly increased domestic unconventional gas production in order to decrease their dependence on foreign energy sources.

  heat_pumps_gas:
    title: "Gas-powered heat pumps"
    body: |-
      Heat pumps can pump heat from one place to another, and are driven by gas or electricity.<br/>
      Fridges use heat pumps to pump heat out, but the same principles can be used to pump heat into your home from outside.
      Gas-powered heat pumps are more efficient than electric ones when outside temperatures are low. Their disadvantage is that they produce CO2.

  heat_pumps_el:
    title: "Electric heat pumps"
    body: |-
      Heat pumps can pump heat from one place to another, and are driven by gas or electricity.<br/>
      Fridges use heat pumps to pump heat out, but the same principles can be used to pump heat into your home from outside.
      Electric heat pumps are quite clean so long as their power is produced from renewable sources. Their disadvantage is that efficiencies tend to drop when outside temperatures are low.

  solar_water_heater:
    title: "Solar water heater"
    body: |-
      Solar water heating systems convert solar energy to heat. The principle is simple: a garden hose exposed to the sun all days will heat up. Even in winter, a day with a few hours of sunshine can produce enough hot water for showering or doing the dishes.

  heat_network:
    title: "Heating networks"
    body: |-
      Large power plants tend to produce a lot of excess heat. Instead of dumping this heat, it can instead be put to good use: in Denmark it is compulsory for power plants to supply this heat to heating networks which is then used by households and offices for heating.<br/>
      In absence of such regulation, power plants tend to be built too far away from population centres for large scale application of heating networks.

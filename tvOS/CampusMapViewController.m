//
//  CampusMapViewController.m
//  Uni Saar
//
//  Created by SE15 UniC on 19/01/16.
//  Copyright © 2016 Universität des Saarlandes. All rights reserved.
//

#import "CampusMapViewController.h"
#import "TFHpple.h"

@interface CampusMapViewController ()

@end


@implementation CampusMapViewController
@synthesize OverviewTableView;
@synthesize BuildingsTableView;
//@synthesize BuildingsHomTableView;
@synthesize Person;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    


    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    SelectedCampus = [defaults objectForKey:@"campus_selected"];
    


    
    _CurrentLocationPointer.translatesAutoresizingMaskIntoConstraints = true;
    _DestinationPointer.translatesAutoresizingMaskIntoConstraints = true;
    _Button.translatesAutoresizingMaskIntoConstraints = true;
    _LocationImage.translatesAutoresizingMaskIntoConstraints = true;
    
    _DestinationPointer.hidden = true;
    OverviewTableView.hidden = true;
    BuildingsTableView.hidden = true;
    
    //HOM
   
    _DestinationLabel.hidden = true;
    _LocationImage.image =[UIImage imageNamed:@"pin_green.png"];
    _DestinationImage.hidden = true;
    [_Button setTitle:NSLocalizedStringFromTable(@"Search Building", @"tvosLocalisation", nil) forState:(UIControlStateNormal)];
    _Button.hidden = false;
    _DestinationPointer.image = [UIImage imageNamed:@"pin_red"];
    //       Location Pointer from https: //pixabay.com/static/uploads/photo/2013/07/12/17/00/location-151669_960_720.png

    
//    _mainView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1];


//Position offset for buildings
    xOffset = 20;
    yOffset = 58;
    PinSizeX = 40;
    PinSizeY = 64;


//Buildings Homburg
    
    BuildOverviewHom = @[@"Chirurgisches Zentrum", @"Zentrum für Innere Medizin", @"Interdisziplinäres Zentrum", @"Zentrum für Infektionskrankheiten", @"Zentrum für Frauen, Kinder und Adoleszente", @"Neuro-Zentrum", @"Radiologisches Zentrum", @"Zentrum für Zahn-, Mund- und Kieferheilkunde", @"Zentrum für Pathologie und Rechtsmedizin", @"Spezielle Kompetenzen", @"Gesundheitsbereiche im staatlichen Auftrag", @"Schulzentrum und Schulen", @"Einrichtungen der Universität des Saarlandes", @"Institute der theoretischen Medizin, Biowissenschaften und der Klinischen Medizin", @"Sonstige Einrichtungen"];
    
//Chirurgisches Zentrum
    
    NSArray *a57 = @[@"Gemeinsame Notaufnahme von Chirurgie / Innere Medizin", @1118.0f, @458.0f];
    NSArray *b57 = @[@"Anästhesiologie und Intensivmedizin und Intensivstation", @1118.0f, @458.0f];
    NSArray *a56 = @[@"Simulatorzentrum", @1179, @436.0f];
    NSArray *c57 = @[@"Allgemeine Chirurgie, Abdominal- und Gefäß-Chirurgie, Kinder-Chirurgie", @1118.0f, @458.0f];
    NSArray *d57 = @[@"Unfall-, Hand- und Wiederherstellungs-Chirurgie", @1118.0f, @458.0f];
    NSArray *e57 = @[@"Thorax- und Herz-Gefäß-Chirurgie", @1118.0f, @458.0f];
    
    NSArray *a37_38 = @[@"Orthopädie und orthopädische Chirurgie", @1200.0f, @670.0f];
    NSArray *a33 = @[@"Krankengymnastik – Bäderabteilung", @1169.0f, @721.0f];
    NSArray *a90_5 = @[@"Neurochirurgie", @790.0f, @382.0f];
    NSArray *a65_66 = @[@"Experimentelle Chirurgie", @754.0f, @530.0f];
    NSArray *a1 = @[@"Klinische Hämostaseologie und Transfusions medizin", @1291.0f, @1078.0f];
    NSArray *b1 = @[@"Blutspendedienst", @1291.0f, @1078.0f];
    NSArray *c1 = @[@"Hämophilie-Zentrum für Erwachsene", @1291.0f, @1078.0f];
    NSArray *d1 = @[@"Hämostaseologische Ambulanz", @1291.0f, @1078.0f];
    NSArray *f57 = @[@"Blutbank / Immunhämatologisches Labor", @1291.0f, @1078.0f];
    
    ChirZen = @[a57, b57, a56, c57, d57, e57, a37_38, a33, a90_5, a65_66, a1, b1, c1, d1, f57];
    
   
//Zentrum für Innere Medizin
    
    NSArray *a41 = @[@"Internistische Intensivstation ICU", @1134.0f, @543.0f];
    NSArray *b41 = @[@"Innere Medizin I", @1134.0f, @543.0f];
    NSArray *a77 = @[@"Gastroenterologie, Hepatologie, Endokrinologie, Diabetologie und Ernährungsmedizin Hochschulambulanzen und Stationen", @1327.0f, @324.0f];
    NSArray *a57_3 = @[@"Endoskopie", @1137.0f, @408.0f];
    NSArray *c41a = @[@"Kardiologie, Angiologie und internistische Intensivmedizin Hochschulambulanzen", @1134.0f, @543.0f];
    NSArray *c41b = @[@"Innere Medizin III Stationen", @1134.0f, @543.0f];
    NSArray *a40_2 = @[@"Nieren- und Hochdruckkrankheiten Hochschulambulanzen", @1205.0f, @623.0f];
    NSArray *b40_2 = @[@"Innere Medizin IV Stationen", @1205.0f, @623.0f];
	NSArray *c40_2 = @[@"Bei Entgiftung", @1205.0f, @623.0f];
    NSArray *a91 = @[@"Pneumologie, Allerg ologie, Beatmungs- u. Umweltmedizin Hochschulambulanzen", @1035.0f,@197.0f];
    NSArray *b91 = @[@"Innere Medizin V Stationen", @1035.0f, @197.0f];
    
    ZenInMed = @[a41, b41, a77, a57_3, c41a, c41b, a40_2, b40_2, c40_2, a91, b91];
    

//Interdisziplinäres Zentrum
    
    NSArray *a22 = @[@"Augenheilkunde", @1330.0f, @714.0f];
    NSArray *a6 = @[@"Hals-Nasen-Ohren-Heilkunde", @1321.0f, @870.0f];
    NSArray *b6 = @[@"Pädaudiologie", @1321.0f, @870.0f];
    NSArray *a27 = @[@"Cochlea Implant Centrum (CIC)", @1525.0f, @549.0f];
    NSArray *c6 = @[@"Urologie und Kinderurologie", @1321.0f, @870.0f];
    NSArray *a6_7 = @[@"Dermatologie Hochschulambulanz", @1351.0f, @895.0f];
    NSArray *d6 = @[@"Dermatologie Privatambulanz / Station D03", @1321.0f, @870.0f];
    NSArray *a18 = @[@"Dermatologie Station", @1137.0f, @782.0f];
    
    IntZen = @[a22, a6, b6, a27, c6, a6_7, d6, a18];
  
    
//Zentrum für Infektionskrankheiten
    
    NSArray *a43 = @[@"Medizinische Mikrobakteriologie und Hygiene", @1055.0f, @611.0f];
    NSArray *a47 = @[@"Virologie", @1016.0f, @574.0f];
    
    ZenInf = @[a43, a47];
    
    
    
    //BIS HIER KOORDINATEN
    
    
//Zentrum für Frauen, Kinder und Adoleszente
    
    
    

    
    NSArray *a9 = @[@"Allgemeine Pädiatrie und Neonatologie, Pädiatrische Kardiologie, Pädiatrische Onkologie und Hämatologie", @1260.0f, @770.0f];
    NSArray *b9 = @[@"Frauenheilkunde, Geburtsmedizin und Reproduktionsmedizin", @1260.0f, @770.0f];
    NSArray *a68 = @[@"Humangenetische Beratungsstelle", @1030.0f, @440.0f];
    NSArray *a23 = @[@"Ronald McDonald Haus – Einrichtung für Familien kranker Kinder", @1334.0f, @765.0f];
    
    NSArray *c9 = @[@"Villa Kunterbunt", @798.0f, @442.0f];
    NSArray *b33 = @[@"Elterninitiative Krebskranker Kinder im Saarland e.V.", @798.0f, @442.0f];
    NSArray *c33 = @[@"Villa Regenbogen und Elterninitiative Herzkrankes Kind Homburg/Saar e.V.", @798.0f, @442.0f];
    NSArray *a69 = @[@"Palliativmedizin und Kinderschmerztherapie", @798.0f, @442.0f];
    NSArray *a90_2 = @[@"Kinder- und Jugendpsychiatrie, Psychosomatik und Psychotherapie", @798.0f, @442.0f];
    NSArray *a90_9 = @[@"Kinder- und Jugendpsychiatrie, Psychosomatik und Psychotherapie", @798.0f, @442.0f];
    NSArray *d33 = @[@"Johanniterhaus des UKS – Tagesklinik für Kinder- und Jugendpsychiatrie, Psychosomatik und Psychotherapie", @798.0f, @442.0f];
    NSArray *b68 = @[@"Ambulanz", @798.0f, @442.0f];
    NSArray *a28 = @[@"Spezialambulanzen (Kleinkinder- / Säuglings-Ambulanz, Autismus-Ambulanz)", @798.0f, @442.0f];
    
    ZenFrKiAd = @[a9, b9, a68, a23, c9, b33, c33, a69, a90_2, a90_9, d33, b68, a28];
    
    
//Neuro-Zentrum
    
    NSArray *a90 = @[@"Gemeinsame Notaufnahme des Neurozentrums", @798.0f, @442.0f];
    NSArray *a90_1 = @[@"Neurologie", @798.0f, @442.0f];
    NSArray *b90 = @[@"Deutsches Institut für Demenzprävention", @798.0f, @442.0f];
    NSArray *b90_1 = @[@"Psychiatrie und Psychotherapie", @798.0f, @442.0f];
    NSArray *a2_1 = @[@"Tagesklinik der Psychiatrie und Psychotherapie, Arbeitstherapie, Übergangsklinik", @798.0f, @442.0f];
    NSArray *c90 = @[@"Suchtentgiftung", @798.0f, @442.0f];
    NSArray *g57 = @[@"Neurochemie", @798.0f, @442.0f];
    NSArray *a95_5 = @[@"Neurochirugie und stereotaktische Neurochirugie", @798.0f, @442.0f];
    NSArray *d90 = @[@"Neuropathologie", @798.0f, @442.0f];
    
    NeuZen = @[a90, a90_1,b90, b90_1, a2_1, c90, g57, a95_5,d90];
    
    
//Radiologisches Zentrum
    
    NSArray *a50_1 = @[@"Diagnostische und Interventionelle Radiologie (Direktion)", @1188.0f, @485.0f];
    NSArray *b50_1 = @[@"Angiographie", @1188.0f, @485.0f];
    NSArray *d41 = @[@"Computertomographie (CT) + Röntgen + Durchleuchtung", @1135.0f, @544.0f];
    NSArray *c50_1 = @[@"Kernspintomographie (MRT)", @1188.0f, @485.0f];
    NSArray *d9 = @[@"Mammographie / Röntgen (Kinder)", @1260.0f, @770.0f];
    NSArray *e6 = @[@"Röntgen (Urologie / HNO)", @1321.0f, @870.0f];
    NSArray *b77 = @[@"Durchleuchtung, Studienbüro, Forschung / Labor", @1326.0f, @324.0f];
    NSArray *a65 = @[@"Forschung - Kernspintomographie (MRT)", @756.0f, @529.0f];
    NSArray *a6_5 = @[@"Strahlentherapie und Radioonkologie", @1222.0f, @908.0f];
    NSArray *a50 = @[@"Nuklearmedizin", @1184.0f, @512.0f];
    NSArray *e90 = @[@"Diagnostische und Interventionelle Neuroradiologie", @834.0f, @361.0f];
    
    RadZen = @[a50_1, b50_1, d41,c50_1, d9, e6, b77, a65, a6_5, a50, e90];
    
    
//Zentrum für Zahn-, Mund- und Kieferheilkunde
    
    NSArray *b56 = @[@"Kieferorthopädie", @1174.0f, @446.0f];
    NSArray *a71_2 = @[@"Zahnärztliche Prothetik und Werkstoffkunde", @1161.0f, @339.0f];
    NSArray *a71_1 = @[@"Mund-, Kiefer- und Gesichts-Chirurgie", @1138.0f, @398.0f];
    NSArray *a73 = @[@"Zahnerhaltung, Parodontologie und präventive Zahnheilkunde", @1182.0f, @369.0f];

    ZenZaMuKi = @[b56, a71_2, a71_1, a73];
    

//Zentrum für Pathologie und Rechtsmedizin
    
    NSArray *a80_2 = @[@"Rechtsmedizin", @1413.0f, @282.0f];
    NSArray *a26 = @[@"Pathologie", @1467.0f, @700.0f];
    
    ZenPaRe = @[a80_2, a26];
    
    
//Spezielle Kompetenzen
    
    NSArray *e1 = @[@"Ambulantes Onkologie-Zentrum (AOZ)", @1291.0f, @1078.0f];
    NSArray *a52 = @[@"Saarländische Krebszentrale – Tumorzentrum", @1297.0f, @562.0f];
    NSArray *i57 = @[@"Zentrallabor", @1106.0f, @474.0f];
    NSArray *a61_4 = @[@"Interdiziplinäres Forschungs- und Laborgebäude", @907.0f, @588.0f];
    NSArray *e9 = @[@"Christiane-Herzog-Mukoviszidose-Zentrum", @1258.0f, @771.0f];
    NSArray *f9 = @[@"Interdiszipl. Marfan-Spezial-Ambulanz", @1258.0f, @771.0f];
    NSArray *c77 = @[@"Diabetes-Zentrum", @1326.0f, @325.0f];
    NSArray *g9 = @[@"Zertifiziertes Brustzentrum", @1258.0f, @771.0f];
    
    
    SpeKom = @[e1, a52, i57, a61_4, e9, f9, c77, g9];
    
    
//Gesundheitsbereiche im staatlichen Auftrag
    
    NSArray *c68 = @[@"Rechtsmedizin, Untersuchungsstelle für Verkehrstauglichkeit", @1029.0f, @441.0f];
    NSArray *f90 = @[@"Gerichtliche Psychologie und Psychiatrie", @862.0f, @351.0f];
    NSArray *h9 = @[@"Informations- und Behandlungszentrum für Vergiftungen des Bundeslandes Saarland", @1258.0f, @771.0f];
    NSArray *i9 = @[@"Giftinformationszentrale (Kinder)", @1258.0f, @771.0f];
    NSArray *b28 = @[@"Zentrum für Kindervorsorge", @1573.0f, @473.0f];
    NSArray *b47 = @[@"Trinkwasserlabor der Virologie", @1013.0f, @576.0f];
    NSArray *b43 = @[@"Staatliche Untersuchungsstelle (SMU) der Mikrobiologie", @1052.0f, @606.0f];
    NSArray *a76 = @[@"Radioaktivitätsmessstelle der UdS", @1289.0f, @375.0f];
    
    GesStAuf = @[c68, f90, h9, i9, b28, b47, b43, a76];
 
    
//Schulzentrum und Schulen
    
    NSArray *a53 = @[@"Leitung des Schulzentrums, Referat für Fort-und Weiterbildung", @1359.0f, @542.0f];
    NSArray *b53 = @[@"Schule für Gesundheits- und Krankenpflege / Kinderkrankenpflege (staatl. anerkannt)", @1359.0f, @542.0f];
    NSArray *c53 = @[@"Schule für Schule für", @1169.0f, @721.0f];
    NSArray *d53 = @[@"Schule für Diätassistenten / Diätassistentinnen (staatl. anerkannt)", @1359.0f, @542.0f];
    NSArray *e53 = @[@"Schule für Operationstechnische Assistenten /Assistentinnen (staatl. anerkannt)", @1359.0f, @542.0f];
    NSArray *a21 = @[@"Schule für Med.-Techn. Laboratoriumsassistenten/innen (staatl. anerkannt)", @1278.0f, @734.0f];
    NSArray *b21 = @[@"Schule für Pharmazeutisch-Technische Assistenten/innen (staatl. anerkannt)", @1278.0f, @734.0f];
    NSArray *a51 = @[@"Schule für Med.-Techn. Assistenten/innen für Funktionsdiagnostik (staatl. anerkannt)", @1230.0f, @562.0f];
    NSArray *b51 = @[@"Schule für Med.-Techn. Radiologie-Assistenten/innen (staatl. anerkannt)", @1230.0f, @562.0f];
    NSArray *a37 = @[@"Schule für Physiotherapie (staatl. anerkannt)", @1205.0f, @666.0f];
    NSArray *b27 = @[@"Krankenhaus- und Hausunterricht", @1525.0f, @548.0f];
    NSArray *a84 = @[@"(Staatl. Förderschule für körperliche und motorische Entwicklung)", @1433.0f, @195.0f];

    
    Schu = @[a53, b53, c53, d53, e53, a21, b21, a51, b51, a37, b27, a84 ];
    
    
//Einrichtungen der Universität des Saarlandes
    
    NSArray *a15 = @[@"Dekanat und Medizinische Fakultät",@963.0f,@770.0f];
    NSArray *a16 = @[@"Universität des Saarlandes, Facility Management Homburg",@947.0f,@739.0f];
    NSArray *a34 = @[@"Medizinische Bibliothek",@1230.0f,@325.0f];
    NSArray *a74 = @[@"Mensa, AStA – Außenstelle, Fachschaft Medizin, Studentenwerk, Hochschulgemeinden ESG und KHG, Hochschulsportzentrums – Außenstelle",@1233.0f,@328.0f];
    NSArray *a7  = @[@"Starterzentrum III / Uni-Shop",@1402.0f,@839.0f];
    NSArray *a64 = @[@"Tierschutzbeauftragte",@805.0f,@552.0f];
    
    EinUdS = @[a15, a16, a34, a74, a7, a64];
    
    
//Institute der theoretischen Medizin, Biowissenschaften und der Klinischen Medizin
    
    NSArray *a61	 =@[@"Anatomie und Zellbiologie",@878.0f,@541.0f];
    NSArray *a48_1   =@[@"Biophysik und physikalische Grundlagen der Medizin",@891.0f,@684.0f];
    NSArray *a44	 =@[@"Medizinische Biochemie und Molekularbiologie",@992.0f,@648.0f];
    NSArray *a45	 =@[@"Experimentelle und klinische Pharmakologie und Toxikologie",@975.0f,@624.0f];
    NSArray *b48_1   =@[@"Physiologie",@891.0f,@684.0f];
    NSArray *b80_2        =@[@"Zentrum Allgemeinmedizin",@1404.0f,@281.0f];
    NSArray *a86	 =@[@"Medizinische Biometrie, Epidemiologie und Informatik (IMBEI)",@1320.0f,@264.0f];
    NSArray *b26	     =@[@"Allgemeine, Spezielle und Neuropathologie",@1468.0f,@699.0f];
    NSArray *a45_3        =@[@"José-Carreras-Zentrum für Immuntherapie",@950.0f,@650.0f];
    NSArray *a60	     =@[@"Humangenetik",@943.0f,@540.0f];
    NSArray *d68	     =@[@"Experimentelle Neurochirurgie",@1412.0f,@640.0f];
    NSArray *g90	     =@[@"Medizinische und Klinische Psychologie",@846.0f,@334.0f];
    
    
    InsThMed = @[a61, a48_1, a44, a45, b48_1, b80_2, a86, b26, a45_3, a60, d68, g90];
    
    
//Sonstige Einrichtungen
    
    NSArray *a4	 =@[@"Apotheke",@1080.0f,@871.0f];
    NSArray *a3	 =@[@"Besprechungsräume",@1051.0f,@853.0f];
    NSArray *b4    =@[@"Briefkasten",@1098.0f,@871.0f];
    NSArray *a31	 =@[@"Evangelisches Pfarramt",@1401.0f,@577.0f];
    NSArray *a11	 =@[@"Geldautomat",@1080.0f,@795.0f];
    NSArray *c51	 =@[@"Katholisches Pfarramt",@1220.0f,@554.0f];
    NSArray *a55	 =@[@"Klinikkirche",@1272.0f,@478.0f];
    NSArray *d51	 =@[@"Patientenbibliothek und Kapelle",@1220.0f,@554.0f];
    NSArray *b11	 =@[@"Telefonzentrale AVAYA",@1080.0f,@795.0f];
    NSArray *c27	 =@[@"Wohnhochhaus I",@1518.0f,@542.0f];
    NSArray *c28	 =@[@"Wohnhochhaus II",@1573.0f,@468.0f];
    
    SonstEin = @[a4, a3, b4, a31, a11, c51, a55, d51, b11, c27, c28];
    
    
//Direktion, Verwaltung, Wirtschaft, Technik
    
    NSArray *c11 = @[@"Vorstand/Ärztliche Direktion/Kaufmännische Direktion/Pflegedirektion",@1080.0f,@795.0f];
    NSArray *d11	 = 	 @[@"Dezernat I – Personal",@1080.0f,@795.0f];
    
    //Dezernat II - Finanzen
    NSArray *a17	 = 	 @[@"Dezernat II – Finanzen", @1048.0f,@760.0f];
    NSArray *a12	 = 	 @[@"Krankenhausbetrieb und Patientenmanagement", @1009.0f,@806.0f];
    
    //Dezernat III - Wirtschaft
    NSArray *a79	 = 	 @[@"Dezernat III – Wirtschaft", @1426.0f,@338.0f];
    NSArray *b79	 = 	 @[@"Zentraleinkauf – Materialwirtschaft", @1426.0f,@338.0f];
    NSArray *c79	 = 	 @[@"Versorgungszentrum – Ärztliches-, Wirtschaftliches- und Technisches Zentrallager", @1426.0f,@338.0f];
    NSArray *a79_1	 = @[@"Investitionen und Wirtschaftsbetriebe", @1473.0f,@375.0f];
    NSArray *d79	 = 	 @[@"Näherei, Wäscherei, Schutzkleidungsausgabe", @1426.0f,@338.0f];
    NSArray *a32	 =	 @[@"Personalkasino mit Bistro", @1346.0f,@606.0f];
    NSArray *b32	 =	 @[@"Küche und Lebensmittelmagazin", @1346.0f,@606.0f];
    NSArray *b31	 =	 @[@"Bäckerei, Metzgerei", @1401.0f,@577.0f];
    NSArray *e79	 = 	 @[@"Logistik – Klinikinterne Patiententransporte, Klinikumsversorgung", @1426.0f,@338.0f];
    NSArray *a78	 =	 @[@"KFZ-Werkstatt", @1357.0f,@342.0f];
    NSArray *b79_1	 = @[@"Zentrales Sterilgutmanagement", @1473.0f,@375.0f];
    
    //Dezernat IV - Technik
    
    NSArray *j57    = @[@"Dezernat IV – Technik", @798.0f, @442.0f];
    NSArray *k57    =	 @[@"Technik / Medizintechnik", @1106.0f,@471.0f];
    NSArray *d27	 =	 @[@"ZMT (Zentrum für Medizintechnik)", @1518.0f,@542.0f];
    NSArray *f79	 =	 @[@"Technik und Werkstätten", @1426.0f,@338.0f];
    NSArray *b78	 =	 @[@"Sanitär- und Installationsdienst", @1357.0f,@342.0f];
    NSArray *c78	 = @[@"FM-Dienst", @1357.0f,@342.0f];
    
    //Dezernat V
    NSArray *a10	 = @[@"Dezernat V – Recht und Verwaltung", @1158.0f,@832.0f];
    NSArray *b52	 =	 @[@"Postverteilerstelle", @1305.0f,@577.0f];
    
    //Sonstiges
    NSArray *c56	 =	 @[@"Bereitschaftsdienste", @1172.0f, @436.0f];
    NSArray *d77	 =	 @[@"Betriebsarzt", @1328.0f,@315.0f];
    NSArray *c47	 =	 @[@"Büro Neubauprojekte", @1010.0f,@560.0f];
    NSArray *a80_3	 =   @[@"DRK-Rettungswache", @1504.0f,@237.0f];
    NSArray *e33	 =	 @[@"Frauenbeauftragte", @1162.0f,@709.0f];
    NSArray *a62	 =   @[@"FlexiMedKids (Kinderbetreuung)", @817.0f,@567.0f];
    NSArray *a80_1	 =   @[@"Gärtnerei", @1473.0f,@289.0f];
    NSArray *b10	 =   @[@"Info-Zentrum", @1158.0f,@832.0f];
    NSArray *c52	 =	 @[@"Innenrevision", @1305.0f,@577.0f];
    NSArray *f11	 =   @[@"Klinik-Apotheke des UKS", @1080.0f,@795.0f];
    NSArray *e27	 =   @[@"Landesamt für Zentrale Dienste, Amt für Bau- und Liegenschaften",  @1518.0f,@542.0f];
    NSArray *b17	 =	 @[@"Medizin-Controlling",@1048.0f,@760.0f];
    NSArray *b3      =	 @[@"Patientenfürsprecher", @1057.0f,@851.0f];
    NSArray *b74	 =	 @[@"Personalrat", @1233.0f,@328.0f];
    NSArray *g11	 =	 @[@"Presse- und Öffentlichkeitsarbeit", @1080.0f,@795.0f];
    NSArray *f27	 =	 @[@"Projektsteuerungsbüro beim Vorstand (PSB)", @1518.0f,@542.0f];
    NSArray *g27	 =	 @[@"UKS Service GmbH", @1518.0f,@542.0f];
    NSArray *b86	 =	 @[@"ZIK (Zentrum für Informations- und Kommunikationstechnik)", @1320.0f, @264.0f];
    
    DiVeWiTe = @[c11, d11, a17, a12, a79, b79, c79, a79_1, d79, a32, b32, b31, e79, a78, b79_1, j57, k57, d27, f79, b78, c78, a10, b52, c56, d77, c47, a80_3, e33, a62, a80_1, b10, c52, f11, e27, b17, b3, b74, g11, f27, g27, b86];

    
//BUILDINGS Saarbrücken
    
    BuildOverviewSaar = @[@"A", @"B", @"C", @"D", @"E"];

    
    
    NSArray *A11 = @[@"A1 1", @798.0f, @405.0f];
    NSArray *A12 = @[@"A1 2", @798.0f, @442.0f];
    NSArray *A13 = @[@"A1 3", @795.0f, @480.0f];
    NSArray *A14 = @[@"A1 4", @792.0f, @520.0f];
    NSArray *A15 = @[@"A1 5", @795.0f, @550.0f];
    NSArray *A17 = @[@"A1 7", @767.0f, @622.0f];
    NSArray *A18 = @[@"A1 8", @750.0f, @530.0f];
    NSArray *A22 = @[@"A2 2", @863.0f, @427.0f];
    NSArray *A23 = @[@"A2 3", @863.0f, @519.0f];
    NSArray *A24 = @[@"A2 4", @863.0f, @613.0f];
    NSArray *A31 = @[@"A3 1", @909.0f, @447.0f];
    NSArray *A32 = @[@"A3 2", @961.0f, @450.0f];
    NSArray *A33 = @[@"A3 3", @935.0f, @404.0f];
    NSArray *A41 = @[@"A4 1", @979.0f, @622.0f];
    NSArray *A42 = @[@"A4 2", @938.0f, @601.0f];
    NSArray *A43 = @[@"A4 3", @901.0f, @612.0f];
    NSArray *A44 = @[@"A4 4", @938.0f, @575.0f];
    NSArray *A51 = @[@"A5 1", @1016.0f, @429.0f];
    NSArray *A52 = @[@"A5 2", @1016.0f, @485.0f];
    NSArray *A53 = @[@"A5 3", @1019.0f, @518.0f];
    NSArray *A54 = @[@"A5 4", @1016.0f, @608.0f];

    BuildA = @[A11, A12, A13, A14, A15, A17, A18, A22, A23, A24, A31, A32, A33, A41, A42, A43, A44, A51, A52, A53, A54];
    
    NSArray *B11 = @[@"B1 1", @773.0f, @725.1f];
    NSArray *B12 = @[@"B1 2", @746.0f, @690.0f];
    NSArray *B21 = @[@"B2 1", @863.0f, @665.0f];
    NSArray *B22 = @[@"B2 2", @918.0f, @665.0f];
    NSArray *B31 = @[@"B3 1", @985.0f, @724.0f];
    NSArray *B32 = @[@"B3 2", @953.0f, @771.0f];
    NSArray *B33 = @[@"B3 3", @972.0f, @754.0f];
    NSArray *B41 = @[@"B4 1", @874.0f, @818.0f];
    NSArray *B42 = @[@"B4 2", @817.0f, @901.0f];
    NSArray *B43 = @[@"B4 3", @817.0f, @877.0f];
    NSArray *B44 = @[@"B4 4", @870.0f, @896.0f];
    NSArray *B51 = @[@"B5 1", @784.0f, @820.0f];
    NSArray *B52 = @[@"B5 2", @731.0f, @797.0f];
    NSArray *B61 = @[@"B6 1", @706.0f, @804.0f];
    NSArray *B62 = @[@"B6 2", @706.0f, @792.0f];
    NSArray *B63 = @[@"B6 3", @693.0f, @771.0f];
    NSArray *B64 = @[@"B6 4", @693.0f, @759.0f];
    NSArray *B65 = @[@"B6 5", @680.0f, @738.0f];
    NSArray *B66 = @[@"B6 6", @680.0f, @726.0f];
    NSArray *B68 = @[@"B6 8", @622.0f, @728.0f];
    NSArray *B71 = @[@"B7 1", @659.0f, @671.0f];
    NSArray *B72 = @[@"B7 2", @659.0f, @684.0f];
    NSArray *B73 = @[@"B7 3", @659.0f, @700.0f];
    NSArray *B81 = @[@"B8 1", @850.0f, @955.0f];
    NSArray *B82 = @[@"B8 2", @821.0f, @966.0f];
    NSArray *B83 = @[@"B8 3", @785.0f, @988.0f];
    
    BuildB = @[B11, B12, B21, B22, B31, B32, B33, B41, B42, B43, B44, B51, B52, B61, B62, B63,B64, B65, B66, B68, B71, B72, B73, B81, B82, B83];
    
    NSArray *C11 = @[@"C1 1", @1055.0f, @407.0f];
    NSArray *C12 = @[@"C1 2", @1055.0f, @448.0f];
    NSArray *C13 = @[@"C1 3", @1070.0f, @485.0f];
    NSArray *C21 = @[@"C2 1", @1115.0f, @443.0f];
    NSArray *C22 = @[@"C2 2", @1157.0f, @440.0f];
    NSArray *C23 = @[@"C2 3", @1213.0f, @441.0f];
    NSArray *C31 = @[@"C3 1", @1067.0f, @535.0f];
    NSArray *C41 = @[@"C4 1", @1228.0f, @516.0f];
    NSArray *C42 = @[@"C4 2", @1151.0f, @515.0f];
    NSArray *C43 = @[@"C4 3", @1183.0f, @519.0f];
    NSArray *C44 = @[@"C4 4", @1116.0f, @530.0f];
    NSArray *C45 = @[@"C4 5", @1120.0f, @491.0f];
    NSArray *C46 = @[@"C4 6", @1205.0f, @547.0f];
    NSArray *C51 = @[@"C5 1", @1015.0f, @696.0f];
    NSArray *C52 = @[@"C5 2", @1109.0f, @690.0f];
    NSArray *C53 = @[@"C5 3", @1057.0f, @631.0f];
    NSArray *C54 = @[@"C5 4", @1134.0f, @646.0f];
    NSArray *C55 = @[@"C5 5", @1059.0f, @584.0f];
    NSArray *C62 = @[@"C6 2", @1232.0f, @565.0f];
    NSArray *C63 = @[@"C6 3", @1205.0f, @573.0f];
    NSArray *C64 = @[@"C6 4", @1189.0f, @626.0f];
    NSArray *C65 = @[@"C6 5", @1222.0f, @615.0f];
    NSArray *C71 = @[@"C7 1", @1023.0f, @782.0f];
    NSArray *C72 = @[@"C7 2", @1002.0f, @817.0f];
    NSArray *C73 = @[@"C7 3", @1012.0f, @804.0f];
    NSArray *C74 = @[@"C7 4", @1045.0f, @843.0f];
    NSArray *C75 = @[@"C7 5", @1070.0f, @774.0f];
    NSArray *C76 = @[@"C7 6", @1115.0f, @757.0f];
    NSArray *C77 = @[@"C7 7", @1090.0f, @768.0f];
    NSArray *C81 = @[@"C8 1", @1177.0f, @694.0f];
    NSArray *C82 = @[@"C8 2", @1221.0f, @692.0f];
    NSArray *C83 = @[@"C8 3", @1233.0f, @666.0f];
    NSArray *C91 = @[@"C9 1", @1318.0f, @577.0f];
    NSArray *C92 = @[@"C9 2", @1409.0f, @585.0f];
    NSArray *C93 = @[@"C9 3", @1394.0f, @669.0f];
    
    BuildC = @[C11, C12, C13,C21, C22, C23, C31, C41, C42, C43, C44, C45, C46, C51, C52, C53, C54, C55, C62, C63, C64, C65, C71, C72, C73, C74, C75, C76, C77, C81, C82, C83, C91, C92, C93];
    
    NSArray *D11 = @[@"D1 1", @679.0f, @455.0f];
    NSArray *D12 = @[@"D1 2", @778.0f, @352.0f];
    NSArray *D21 = @[@"D2 1", @875.0f, @319.0f];
    NSArray *D22 = @[@"D2 2", @937.0f, @325.0f];
    NSArray *D23 = @[@"D2 3", @982.0f, @299.0f];
    NSArray *D24 = @[@"D2 4", @904.0f, @302.0f];
    NSArray *D25 = @[@"D2 5", @940.0f, @286.0f];
    NSArray *D31 = @[@"D3 1", @1037.0f, @341.0f];
    NSArray *D32 = @[@"D3 2", @1083.0f, @309.0f];
    NSArray *D33 = @[@"D3 3", @1050.0f, @275.0f];
    NSArray *D41 = @[@"D4 1", @1178.0f, @267.0f];
    NSArray *D43 = @[@"D4 3", @1202.0f, @211.0f];
    NSArray *D44 = @[@"D4 4", @1188.0f, @217.0f];
    NSArray *D45 = @[@"D4 5", @1219.0f, @353.0f];
    NSArray *D51 = @[@"D5 1", @1234.0f, @172.0f];
    
    BuildD = @[D11, D12, D21, D22, D23, D24, D25, D31, D32, D33, D41, D43, D44, D45, D51];
    
    NSArray *E11 = @[@"E1 1", @1332.0f, @304.1f];
    NSArray *E12 = @[@"E1 2", @1331.0f, @280.0f];
    NSArray *E13 = @[@"E1 3", @1321.0f, @237.0f];
    NSArray *E14 = @[@"E1 4", @1394.0f, @230.0f];
    NSArray *E15 = @[@"E1 5", @1426.0f, @285.0f];
    NSArray *E16 = @[@"E1 6", @1259.0f, @297.0f];
    NSArray *E17 = @[@"E1 7", @1294.0f, @331.0f];
    NSArray *E21 = @[@"E2 1", @1471.0f, @349.1f];
    NSArray *E22 = @[@"E2 2", @1367.0f, @373.0f];
    NSArray *E23 = @[@"E2 3", @1414.0f, @402.0f];
    NSArray *E24 = @[@"E2 4", @1326.0f, @404.0f];
    NSArray *E25 = @[@"E2 5", @1365.0f, @443.0f];
    NSArray *E26 = @[@"E2 6", @1317.0f, @474.0f];
    NSArray *E27 = @[@"E2 7", @1315.0f, @526.0f];
    NSArray *E28 = @[@"E2 8", @1291.0f, @550.0f];
    NSArray *E29 = @[@"E2 9", @1276.0f, @557.0f];
    NSArray *E31 = @[@"E3 1", @1553.0f, @215.0f];
    NSArray *E71 = @[@"E7 1", @1708.0f, @167.0f];
    NSArray *E72 = @[@"E7 2", @1649.0f, @191.0f];
    NSArray *E81 = @[@"E8 1", @1744.0f, @226.0f];
    NSArray *E91 = @[@"E9 1", @1862.0f, @99.0f];
    
    BuildE = @[E11, E12, E13, E14, E15, E16, E17, E21, E22, E21, E22, E23, E24, E25, E26, E27, E28, E29, E31, E71, E72, E81, E91];
  

    
    // staff search inclusion

    if (Person ==0) {
        
    }
    else{

        NSArray *PersonBuilding = [self getBuildingInfo:Person];
        [self setDestination:PersonBuilding];

    }
    
//Current Location
    
    SelectedLocation = [defaults objectForKey:@"building_selected"];
    NSArray *CurrentBuilding = [self getBuildingInfo: SelectedLocation];
    
    [self setCurrentLocation:CurrentBuilding];

//Campus selection
    
    [self SelectCampus:SelectedCampus];
  
    
} 


// evaluates, which campus is selected
-(void) SelectCampus: (NSString*) Campus
{
    if ([Campus  isEqual: @"hom"]){
//        _MapImage.image = [UIImage imageNamed:@"campus_homburg.png"];
//        _Button.hidden = true;
        _CurrentLocationPointer.hidden = true;
        _LocationImage.hidden = true;
        _LocationLabel.hidden = true;

        _DestinationImage.hidden = true;
        _DestinationLabel.hidden = true;
//        _DestinationPointer.hidden = true;
//        Person = 0;
//        //        _mainView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1];
        
        
        
        _MapImage.image = [UIImage imageNamed:@"campus_homburg.png"];
        BuildOverview = BuildOverviewHom;
        Camp = true;
//        OverviewTableView.autoresizesSubviews = true;
//        OverviewTableView.sizeToFit;
     
        
    }
    else {
        _MapImage.image = [UIImage imageNamed:@"campus.png"];
        BuildOverview = BuildOverviewSaar;
        Camp = false;
    }
}


// set the pin for the building selected in the setting
-(void) setCurrentLocation: (NSArray*) Loc
{
    
    if (Loc != 0) {
        
        _CurrentLocationPointer.frame = CGRectMake(getCoordinates(Loc,1)-xOffset, getCoordinates(Loc,2)-yOffset, PinSizeX, PinSizeY);
        _CurrentLocationPointer.image = [UIImage imageNamed:@"pin_green"];
        _LocationLabel.text = [NSLocalizedStringFromTable(@"Your location", @"tvosLocalisation", nil) stringByAppendingString:[Loc objectAtIndex:0]];
    
    }
    else {
        _CurrentLocationPointer.hidden = true;
        _LocationLabel.text = NSLocalizedStringFromTable(@"No location configured", @"tvosLocalisation", nil);
    }
    
}

// get cordinates as float from an array
float getCoordinates (NSArray *TempCoord, int i)
{
    id Temp = [TempCoord objectAtIndex:i];
    float Coordinate = [Temp floatValue];
    return Coordinate;
}


//set pointer for selected destination
-(void) setDestination: (NSArray*) Dest
{
    if (Dest ==0) {
        _DestinationLabel.text = NSLocalizedStringFromTable(@"Building not found", @"tvosLocalisation", nil);
        _DestinationLabel.hidden = false;
        _DestinationImage.image = [UIImage imageNamed:@"pin_red.png"];
        _DestinationImage.hidden = false;
        _DestinationPointer.hidden = true;
    }
    else {
        
        if (Camp == true) {
            _DestinationLabel.text = [NSLocalizedStringFromTable(@"Destination", @"tvosLocalisation", nil) stringByAppendingString:[Dest objectAtIndex:0]];
            _DestinationLabel.hidden = true;
            _DestinationImage.image = [UIImage imageNamed:@"pin_red.png"];
            _DestinationImage.hidden = true;
            _DestinationPointer.frame = CGRectMake(getCoordinates(Dest,1)-xOffset, getCoordinates(Dest,2)-yOffset, PinSizeX, PinSizeY);
            _DestinationPointer.hidden = false;
        }
        else{
        _DestinationLabel.text = [NSLocalizedStringFromTable(@"Destination", @"tvosLocalisation", nil) stringByAppendingString:[Dest objectAtIndex:0]];
        _DestinationLabel.hidden = false;
        _DestinationImage.image = [UIImage imageNamed:@"pin_red.png"];
        _DestinationImage.hidden = false;
        _DestinationPointer.frame = CGRectMake(getCoordinates(Dest,1)-xOffset, getCoordinates(Dest,2)-yOffset, PinSizeX, PinSizeY);
        _DestinationPointer.hidden = false;
      }
    }
}


// searches buildings by name and returns name and coordinates in an array
- (NSArray*)getBuildingInfo: (NSString*) BuildingName
{
    NSArray *TempBuilding;

    
    
    if ([BuildingName containsString:@"A"]) {
        TempBuilding = BuildA;
    }
    else if ([BuildingName containsString:@"B"]){
        TempBuilding = BuildB;
    }
    else if ([BuildingName containsString:@"C"]){
        TempBuilding = BuildC;
    }
    else if ([BuildingName containsString:@"D"]){
        TempBuilding = BuildD;
    }
    else if ([BuildingName containsString:@"E"]){
        TempBuilding = BuildE;
    }
    else {
        TempBuilding = 0;
    }
    
    if (TempBuilding != 0) {
        
        bool isBuild = true;
        int i=0;
        NSUInteger j = TempBuilding.count;
        
    
        while (isBuild == true && i<=j) {
            
            if (i>=j) {
                return 0;
            }
            else {
            isBuild =! [[TempBuilding objectAtIndex:i ]  containsObject:BuildingName];
            
            i++;
            }
        }
            NSArray *BuildingInfo = @[[[TempBuilding objectAtIndex:i-1]objectAtIndex:0], [[TempBuilding objectAtIndex:i-1]objectAtIndex:1], [[TempBuilding objectAtIndex:i-1]objectAtIndex:2]];
            
            
            return BuildingInfo;
        }

   
    else {
        return 0;
    }

}

// shows the building list
- (IBAction)SearchButton:(id)sender
{
    OverviewTableView.hidden = false;
    BuildingsTableView.hidden = false;
    _MapImage.alpha = 0.2;
    _MapImage.opaque = NO;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == [self OverviewTableView]) {
        return [BuildOverview count];
    }
    else {
        return [Buildings count] ;
    }
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (tableView == [self OverviewTableView]) {
    
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OverviewCell"];
        cell.textLabel.text = [BuildOverview objectAtIndex:indexPath.row];
    
        return cell;
    }
    else {
       
   
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BuildingCell"];
            cell.textLabel.text = [[Buildings objectAtIndex:indexPath.row]objectAtIndex:0];
            return cell;
        
        
       
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (tableView == [self OverviewTableView]) {
        OverviewCurrentlyAt = indexPath;
        switch (indexPath.row) {
            case 0:
                if (Camp ==1) {
                    Buildings = ChirZen;
                }
                else {
                 Buildings = BuildA;
                }
                break;
            case 1:
                if (Camp ==1) {
                    Buildings = ZenInMed;
                }
                else

                Buildings = BuildB;
                break;
            case 2:
                if (Camp ==1) {
                    Buildings = IntZen;
                }
                else
                Buildings = BuildC;
                  break;
            case 3:
                if (Camp ==1) {
                    Buildings = ZenInf;
                }
                else
                Buildings = BuildD;
                 break;
            case 4:
                if (Camp ==1) {
                    Buildings = ZenFrKiAd;
                }
                else
                Buildings = BuildE;
                break;
            case 5:
                    Buildings = NeuZen;
                break;
            case 6:
                    Buildings = RadZen;
                break;
            case 7:
                    Buildings = ZenZaMuKi;
                break;
            case 8:
                    Buildings = ZenPaRe;
                break;
            case 9:
                    Buildings = SpeKom;
                break;
            case 10:
                    Buildings = GesStAuf;
                break;
            case 11:
                    Buildings = Schu;
                break;
            case 12:
                    Buildings = EinUdS;
                break;
            case 13:
                    Buildings = InsThMed;
                break;
            case 14:
                Buildings = SonstEin;
                break;
            case 15:
                Buildings = DiVeWiTe;
                break;
             
        }
        
       
        [BuildingsTableView reloadData];
        
    }
    else {
      

        
        [self setDestination:[Buildings objectAtIndex:indexPath.row]];
        OverviewTableView.hidden = true;
        BuildingsTableView.hidden = true;
       
        _MapImage.alpha = 1;
        [self setNeedsFocusUpdate];
 
        
        
    }


/*
#pragma mark - Navigation

 In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     Get the new view controller using [segue destinationViewController].
     Pass the selected object to the new view controller.
}
*/

}


@end

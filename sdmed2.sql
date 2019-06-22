--
-- PostgreSQL database dump
--

-- Dumped from database version 10.9 (Ubuntu 10.9-0ubuntu0.18.04.1)
-- Dumped by pg_dump version 10.9 (Ubuntu 10.9-0ubuntu0.18.04.1)

-- Started on 2019-06-22 20:08:51 CEST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3162 (class 0 OID 16934)
-- Dependencies: 220
-- Data for Name: CENZANO_Conceptos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."CENZANO_Conceptos" (codigo, resumen, descripcion, descripcionhtml, preciomed, preciobloq, naturaleza, fecha, ud, preciocert) FROM stdin;
E02AM010	Desbroce y limpieza de terreno a máquina	Desbroce y limpieza superficial del terreno por medios mecánicos, sin carga ni transporte al vertedero y con p.p. de medios auxiliares.	Desbroce y limpieza superficial del terreno por medios mecánicos, sin carga ni transporte al vertedero y con p.p. de medios auxiliares.	0.445	\N	7	2004-01-01	m2	0.450
E03OEP005	Tubo pvc liso multicapa encol. 110mm	Colector de saneamiento enterrado de PVC liso multicapa con un diámetro 110 mm. encolado.  Colocado en zanja, sobre una cama de arena de río de 10 cm. debidamente compactada y nivelada, relleno lateralmente y superiormente hasta 10 cm. por encima de la generatriz con la misma arena; compactando ésta hasta los riñones. Con p.p. de medios auxiliares y sin incluir la excavación ni el tapado posterior de las zanjas.	Colector de saneamiento enterrado de PVC liso multicapa con un diámetro 110 mm. encolado.  Colocado en zanja, sobre una cama de arena de río de 10 cm. debidamente compactada y nivelada, relleno lateralmente y superiormente hasta 10 cm. por encima de la generatriz con la misma arena; compactando ésta hasta los riñones. Con p.p. de medios auxiliares y sin incluir la excavación ni el tapado posterior de las zanjas.	8.205	\N	7	2004-01-01	m.	8.210
E04CM040	Horm.limpieza hm-20/p/20/i  v.man	Hormigón en masa HM-20 N/mm2., consistencia plástica, Tmáx.20 mm., para ambiente normal, elaborado en central para limpieza y nivelado de fondos de cimentación, incluso vertido por medios manuales y colocación.	Hormigón en masa HM-20 N/mm2., consistencia plástica, Tmáx.20 mm., para ambiente normal, elaborado en central para limpieza y nivelado de fondos de cimentación, incluso vertido por medios manuales y colocación.	88.377	\N	7	2004-01-01	m3	88.370
E04SA020	Soler.ha-25, 15cm.arma.#15x15x6	Solera de hormigón de 15 cm. de espesor, realizada con hormigón HA-25 N/mm2., Tmáx.20 mm., elaborado en obra, i/vertido, colocación y armado con mallazo 15x15x6, p.p. de juntas, aserrado de las mismas y fratasado. Según NTE-RSS y EHE.	Solera de hormigón de 15 cm. de espesor, realizada con hormigón HA-25 N/mm2., Tmáx.20 mm., elaborado en obra, i/vertido, colocación y armado con mallazo 15x15x6, p.p. de juntas, aserrado de las mismas y fratasado. Según NTE-RSS y EHE.	16.166	\N	7	2004-01-01	m2	16.160
E05HLA070	H.a.ha-25/p/20 e.mad.los.incl.	Hormigón armado HA-25 N/mm2., Tmáx.20 mm., consistencia plástica, elaborado en central, en losas inclinadas, i/p.p. de armadura (100 kg/m3) y encofrado de madera, vertido con pluma-grúa, vibrado y colocado. Según normas NTE-EME, EHL y EHE.	Hormigón armado HA-25 N/mm2., Tmáx.20 mm., consistencia plástica, elaborado en central, en losas inclinadas, i/p.p. de armadura (100 kg/m3) y encofrado de madera, vertido con pluma-grúa, vibrado y colocado. Según normas NTE-EME, EHL y EHE.	304.859	\N	7	2004-01-01	m3	305.230
E07TBL011	Tabique la.h/s c/cemento cámaras	Tabique de ladrillo hueco sencillo de 24x12x4 cm. en cámaras, recibido con mortero de cemento CEM II/B-P 32,5 N y arena de río 1/6, i/replanteo, aplomado y recibido de cercos, roturas, humedecido de las piezas, limpieza y medios auxiliares, s/NTE-PTL y NBE-FL-90, medido deduciendo huecos superiores a 2 m2.	Tabique de ladrillo hueco sencillo de 24x12x4 cm. en cámaras, recibido con mortero de cemento CEM II/B-P 32,5 N y arena de río 1/6, i/replanteo, aplomado y recibido de cercos, roturas, humedecido de las piezas, limpieza y medios auxiliares, s/NTE-PTL y NBE-FL-90, medido deduciendo huecos superiores a 2 m2.	11.954	\N	7	2004-01-01	m2	11.950
E07TRW070	Recibido pasamanos de madera	Colocación y recibido de pasamanos de madera sobre fábrica de 1/2 pie o tabiquería con pasta de yeso negro y puntas de acero, i/replanteo, limpieza y medios auxiliares, medido en su longitud.	Colocación y recibido de pasamanos de madera sobre fábrica de 1/2 pie o tabiquería con pasta de yeso negro y puntas de acero, i/replanteo, limpieza y medios auxiliares, medido en su longitud.	4.838	\N	7	2004-01-01	m.	4.840
E07TRC010	Recibido cercos en tabiques	Recibido y aplomado de cercos en tabiquería, con pasta de yeso negro.	Recibido y aplomado de cercos en tabiquería, con pasta de yeso negro.	6.274	\N	7	2004-01-01	m2	6.280
E07WA030	Ayuda albañilería a calefacc.	Ayuda de albañilería a instalación de calefacción por vivienda incluyendo mano de obra en carga y descarga, materiales, apertura y tapado de rozas, recibidos, limpieza, remates y medios auxiliares, (15% s/instalación de calefacción)	Ayuda de albañilería a instalación de calefacción por vivienda incluyendo mano de obra en carga y descarga, materiales, apertura y tapado de rozas, recibidos, limpieza, remates y medios auxiliares, (15% s/instalación de calefacción)	124.500	\N	7	2004-01-01	ud	124.500
E10ATV360	Aisl.térm.cam.styrodur 2500-cn-40	Aislamiento térmico de cámaras de aire con planchas rígidas de espuma de poliestireno extruído, machihembradas tipo III, Styrodur 2500-CN de 40 mm., i/p.p. de corte y colocación.	Aislamiento térmico de cámaras de aire con planchas rígidas de espuma de poliestireno extruído, machihembradas tipo III, Styrodur 2500-CN de 40 mm., i/p.p. de corte y colocación.	11.262	\N	7	2004-01-01	m2	11.270
E10INL060	Imper.lámina pvc 1,2(r/p) intemperie	Impermeabilización de cubierta constituida por: lámina sintética de PVC de 1,2 mm. intemperie, armada con poliéster (R/P), de color gris/negro, Danopol I-P.	Impermeabilización de cubierta constituida por: lámina sintética de PVC de 1,2 mm. intemperie, armada con poliéster (R/P), de color gris/negro, Danopol I-P.	11.447	\N	7	2004-01-01	m2	11.450
03	CIMENTACIONES		\N	3335.562	\N	6	2004-01-01		3336.190
07	CUBIERTAS		\N	3704.755	\N	6	2004-01-01		3705.310
E02EM030	Excavación vaciado a máquina terreno compacto	Excavación en zanjas, en terrenos compactos, por medios mecánicos, con extracción de tierras a los bordes, sin carga ni transporte al vertedero y con p.p. de medios auxiliares.	Excavación en zanjas, en terrenos compactos, por medios mecánicos, con extracción de tierras a los bordes, sin carga ni transporte al vertedero y con p.p. de medios auxiliares.	12.136	\N	7	2004-01-01	m3	12.140
09	IMPERMEABILIZACIONES		\N	831.467	\N	6	2004-01-01		831.970
E15VPM010	Puerta 0,80x2,00 40/14 std	Puerta de 1 hoja de 0,80x2,00 m. para cerramiento exterior, con bastidor de tubo de acero laminado en frío de 40x40 mm. y malla S/T galvanizada en caliente 40/14 STD, i/ herrajes de colgar y seguridad, elaborada en taller, ajuste y montaje en obra. (sin incluir recibido de albañilería).	Puerta de 1 hoja de 0,80x2,00 m. para cerramiento exterior, con bastidor de tubo de acero laminado en frío de 40x40 mm. y malla S/T galvanizada en caliente 40/14 STD, i/ herrajes de colgar y seguridad, elaborada en taller, ajuste y montaje en obra. (sin incluir recibido de albañilería).	154.190	\N	7	2004-01-01	ud	154.190
E11RRA010	Rodapié chapado sapelly 7x1,6 cm.	Rodapié de aglomerado chapado en sapelly de 7x1,6 cm., barnizado en fábrica, clavado en paramentos, s/NTE-RSR-27, medido en su longitud.	Rodapié de aglomerado chapado en sapelly de 7x1,6 cm., barnizado en fábrica, clavado en paramentos, s/NTE-RSR-27, medido en su longitud.	3.275	\N	7	2004-01-01	m.	3.270
E12PNM010	Encimera mármol nacional e=2cm	Encimera de mármol nacional de 2 cm. de espesor, con faldón y zócalo, i/anclajes, colocada, medida la superficie ejecutada (mínima=1 m2).	Encimera de mármol nacional de 2 cm. de espesor, con faldón y zócalo, i/anclajes, colocada, medida la superficie ejecutada (mínima=1 m2).	142.466	\N	7	2004-01-01	m.	142.470
E14PV030	Persiana pvc lama 50mm.reforzada	Persiana enrrollable de lamas reforzadas de PVC, de 50 mm. de anchura, equipada con todos sus accesorios (eje, polea, cinta y recogedor), montada, incluso con p.p. de medios auxiliares.(mínimo medición 1,50 m2.)	Persiana enrrollable de lamas reforzadas de PVC, de 50 mm. de anchura, equipada con todos sus accesorios (eje, polea, cinta y recogedor), montada, incluso con p.p. de medios auxiliares.(mínimo medición 1,50 m2.)	37.616	\N	7	2004-01-01	m2	37.620
E14PS050	Celosía lamas orientables reja	Persiana de lamas de PVC orientables reja, con estructura fija galvanizada y lacada con secado al horno. Incluido montaje.	Persiana de lamas de PVC orientables reja, con estructura fija galvanizada y lacada con secado al horno. Incluido montaje.	160.725	\N	7	2004-01-01	m2	160.730
E08TAE010	Falso techo escayola lisa	Falso techo de placas de escayola lisa de 100x60 cm., recibida con esparto y pasta de escayola, i/repaso de juntas, limpieza, montaje y desmontaje de andamios, s/NTE-RTC-16, medido deduciendo huecos.	Falso techo de placas de escayola lisa de 100x60 cm., recibida con esparto y pasta de escayola, i/repaso de juntas, limpieza, montaje y desmontaje de andamios, s/NTE-RTC-16, medido deduciendo huecos.	12.410	\N	7	2004-01-01	m2	12.410
E27EEL030	Pintu. temple liso color	Pintura al temple liso color en paramentos verticales y horizontales, dos manos, incluso aparejado, plastecido y lijado dos manos.	Pintura al temple liso color en paramentos verticales y horizontales, dos manos, incluso aparejado, plastecido y lijado dos manos.	2.106	\N	7	2004-01-01	m2	2.120
E17BD100	Red equipotencial baño	Red equipotencial en cuarto de baño realizada con conductor de 4 mm2, conectando a tierra todas las canalizaciones metálicas existentes y todos los elementos conductores que resulten accesibles según R.E.B.T.	Red equipotencial en cuarto de baño realizada con conductor de 4 mm2, conectando a tierra todas las canalizaciones metálicas existentes y todos los elementos conductores que resulten accesibles según R.E.B.T.	24.643	\N	7	2004-01-01	ud	24.640
E17BD050	Red toma de tierra estructura	Red de toma de tierra de estructura, realizada con cable de cobre desnudo de 35 mm2, uniéndolo mediante soldadura aluminotérmica a la armadura de cada zapata, incluyendo parte proporcional de pica, registro de comprobación y puente de prueba.	Red de toma de tierra de estructura, realizada con cable de cobre desnudo de 35 mm2, uniéndolo mediante soldadura aluminotérmica a la armadura de cada zapata, incluyendo parte proporcional de pica, registro de comprobación y puente de prueba.	4.673	\N	7	2004-01-01	m.	4.670
E17CBL060	Caja i.c.p.(2p)	Caja I.C.P. (2p) doble aislamiento, de empotrar, precintable y homologada por la compañía eléctrica.	Caja I.C.P. (2p) doble aislamiento, de empotrar, precintable y homologada por la compañía eléctrica.	6.870	\N	7	2004-01-01	ud	6.870
E17CC040	Circuito monof. potencia 25 a.	Circuito cocina realizado con tubo PVC corrugado M 25/gp5, conductores de cobre rígido de 6 mm2, aislamiento VV 750 V., en sistema monofásico (fase neutro y tierra), incluido p./p. de cajas de registro y regletas de conexión.	Circuito cocina realizado con tubo PVC corrugado M 25/gp5, conductores de cobre rígido de 6 mm2, aislamiento VV 750 V., en sistema monofásico (fase neutro y tierra), incluido p./p. de cajas de registro y regletas de conexión.	9.658	\N	7	2004-01-01	m.	9.660
E20WJP070	Bajante a.galvanizado d=100 mm.	Bajante de chapa de acero galvanizado de MetaZinco, de 100 mm. de diámetro, instalada con p.p. de conexiones, codos, abrazaderas, etc.	Bajante de chapa de acero galvanizado de MetaZinco, de 100 mm. de diámetro, instalada con p.p. de conexiones, codos, abrazaderas, etc.	10.582	\N	7	2004-01-01	m.	10.580
13	CARPINTERÍA INTERIOR		\N	6080.158	\N	6	2004-01-01		6080.190
E21ATC020	Bidé c/tapa s.media bla.	Bidé de porcelana vitrificada blanco con tapa lacada incluida, colocado mediante tacos y tornillos al solado, incluso sellado con silicona, con grifo monomando, con aireador, incluso válvula de desagüe de 32 mm., llaves de escuadra de 1/2" cromadas y latiguillos flexibles de 20 cm. y de 1/2", instalado y funcionando.	Bidé de porcelana vitrificada blanco con tapa lacada incluida, colocado mediante tacos y tornillos al solado, incluso sellado con silicona, con grifo monomando, con aireador, incluso válvula de desagüe de 32 mm., llaves de escuadra de 1/2" cromadas y latiguillos flexibles de 20 cm. y de 1/2", instalado y funcionando.	174.380	\N	7	2004-01-01	ud	174.380
14	CARPINTERÍA EXTERIOR		\N	6525.621	\N	6	2004-01-01		6526.480
16	VIDRIERÍA		\N	1060.166	\N	6	2004-01-01		1060.700
17	FALSOS TECHOS		\N	595.680	\N	6	2004-01-01		595.680
19	ELECTRICIDAD		\N	4648.432	\N	6	2004-01-01		4648.020
O01OA070	Peón ordinario		\N	13.090	\N	1	2004-01-01	h.	13.090
P01CY080	Escayola en sacos		\N	52.220	\N	3	2004-01-01		52.220
P01DW050	Agua		\N	0.710	\N	3	2004-01-01	m3	0.710
P01CY010	Yeso negro en sacos		\N	49.550	\N	3	2004-01-01		49.550
P01CY030	Yeso blanco en sacos		\N	63.470	\N	3	2004-01-01		63.470
P01CC020	Cemento cem ii/b-p 32,5 n sacos		\N	95.200	\N	3	2004-01-01		95.200
P01CC120	Cemento blanco bl 22,5 x sacos		\N	139.830	\N	3	2004-01-01		139.830
P01AA020	Arena de río 0/6 mm.		\N	15.700	\N	3	2004-01-01	m3	15.700
M03HH020	Hormigonera 200 l. gasolina		\N	1.930	\N	2	2004-01-01	h.	1.930
P01AA060	Arena de miga cribada		\N	11.090	\N	3	2004-01-01	m3	11.090
P01DH010	Hidrofugante mortero/hormigón		\N	1.710	\N	3	2004-01-01	kg	1.710
P01AA030	Arena de río 0/6 mm.		\N	10.470	\N	3	2004-01-01		10.470
P01AG020	Garbancillo 4/20 mm.		\N	11.250	\N	3	2004-01-01		11.250
M03HH030	Hormigonera 300 l. gasolina		\N	2.330	\N	2	2004-01-01	h.	2.330
M05PN010	Pala cargadora neumáticos 85 cv/1,2m3		\N	38.000	\N	2	2004-01-01	h.	38.000
M05EN050	Retroexcavad.c/martillo rompedor		\N	51.100	\N	2	2004-01-01	h.	51.100
M05EN030	Excav.hidráulica neumáticos 100 cv		\N	42.000	\N	2	2004-01-01	h.	42.000
M08RI010	Pisón vibrante 70 kg.		\N	2.200	\N	2	2004-01-01	h.	2.200
M07CB030	Camión basculante 6x4 20 t.		\N	38.500	\N	2	2004-01-01	h.	38.500
M07N060	Canon de desbroce a vertedero		\N	0.510	\N	2	2004-01-01	m3	0.510
O01OA030	Oficial primera		\N	15.140	\N	1	2004-01-01	h.	15.140
O01OA060	Peón especializado		\N	13.190	\N	1	2004-01-01	h.	13.190
P01HM020	Hormigón hm-20/p/40/i central		\N	70.020	\N	3	2004-01-01	m3	70.020
P01LT020	Ladrillo perfora. tosco 25x12x7		\N	60.100	\N	3	2004-01-01		60.100
P01MC040	Mortero cem. gris ii/b-m 32,5 1:6 m-40		\N	47.000	\N	3	2004-01-01	m3	47.000
P01MC010	Mortero cem. gris ii/b-m 32,5 m-100		\N	53.000	\N	3	2004-01-01	m3	53.000
P02CVC010	Codo m-h pvc j.elást. 45º d=160mm		\N	12.150	\N	3	2004-03-16	ud	12.150
P02EAT020	Tapa cuadrada ha e=6cm 50x50cm		\N	14.950	\N	3	2004-03-16	ud	14.950
P03AM070	Malla 15x30x5     -1,424 kg/m2		\N	0.740	\N	3	2004-01-01	m2	0.740
P02EAT030	Tapa cuadrada ha e=6cm 60x60cm		\N	19.880	\N	3	2004-03-16	ud	19.880
P02CVC400	Codo 87,5º largo pvc san.110 mm.		\N	3.570	\N	3	2004-03-16	ud	3.570
O01OB170	Oficial 1ª fontanero calefactor		\N	15.610	\N	1	2004-01-01	h.	15.610
O01OB180	Oficial 2ª fontanero calefactor		\N	14.220	\N	1	2004-01-01	h.	14.220
P02EDF010	Sum.sif./rej.circ. fund. l=200x200 dt=40		\N	4.080	\N	3	2004-01-01	ud	4.080
P01DW090	Pequeño material		\N	0.770	\N	3	2004-01-01	ud	0.770
E20CIR020	Contador dn20 mm. en arqueta 3/4"	Contador de agua de 20 mm. 3/4", colocado en arqueta de acometida, y conexionado al ramal de acometida y a la red de distribución interior, incluso instalación de dos válvulas de corte de esfera de 20 mm., grifo de purga, válvula de retención y demás material auxiliar, montado y funcionando, incluso verificación, y sin incluir la acometida, ni la red interior.	Contador de agua de 20 mm. 3/4", colocado en arqueta de acometida, y conexionado al ramal de acometida y a la red de distribución interior, incluso instalación de dos válvulas de corte de esfera de 20 mm., grifo de purga, válvula de retención y demás material auxiliar, montado y funcionando, incluso verificación, y sin incluir la acometida, ni la red interior.	205.975	\N	7	2004-01-01	ud	205.980
E22HC020	Chimenea aislada inox/inox 150 mm.	Instalación de chimenea de calefacción aislada de doble pared lisa de 150 mm. de diámetro interior, fabricada interior y exteriormente en acero inoxidable, homologada.	Instalación de chimenea de calefacción aislada de doble pared lisa de 150 mm. de diámetro interior, fabricada interior y exteriormente en acero inoxidable, homologada.	115.695	\N	7	2004-01-01	m.	115.700
E22NTC040	Tubería de cobre d=20-22 mm.	Tubería de cobre de 20-22 mm. de diámetro, Norma UNE 37.141, para red de distribución de calefacción, con p.p. de accesorios, soldadura, pequeño material y aislamiento térmico s/IT.IC, probado a 10 kg/cm2.	Tubería de cobre de 20-22 mm. de diámetro, Norma UNE 37.141, para red de distribución de calefacción, con p.p. de accesorios, soldadura, pequeño material y aislamiento térmico s/IT.IC, probado a 10 kg/cm2.	8.113	\N	7	2004-01-01	m.	8.110
E22NVE010	Válvula de esfera 3/8" pn-10	Válvula de esfera PN-10 de 3/8", instalada, i/pequeño material y accesorios.	Válvula de esfera PN-10 de 3/8", instalada, i/pequeño material y accesorios.	11.005	\N	7	2004-01-01	ud	11.010
E22NVE020	Válvula de esfera 1/2" pn-10	Válvula de esfera PN-10 de 1/2", instalada, i/pequeño material y accesorios.	Válvula de esfera PN-10 de 1/2", instalada, i/pequeño material y accesorios.	11.675	\N	7	2004-01-01	ud	11.680
A01A020	Pasta de escayola		\N	74.476	\N	3	2004-01-01	m3	74.480
A01A030	Pasta de yeso negro		\N	75.269	\N	3	2004-01-01	m3	75.280
A01A040	Pasta de yeso blanco		\N	84.597	\N	3	2004-01-01	m3	84.600
A01L020	Lechada cemento 1/2 cem ii/b-p 32,5 n		\N	67.244	\N	3	2004-01-01	m3	67.240
A01L090	Lechada cem. blanco bl 22,5 x		\N	96.734	\N	3	2004-01-01	m3	96.740
A02A040	Mortero cemento 1/2		\N	94.149	\N	3	2004-01-01	m3	94.150
A02A050	Mortero cemento 1/3 m-160		\N	80.405	\N	3	2004-01-01	m3	80.400
A02A060	Mortero cemento 1/4 m-80		\N	72.701	\N	3	2004-01-01	m3	72.690
A02A080	Mortero cemento 1/6 m-40		\N	64.276	\N	3	2004-01-01	m3	64.270
A02A090	Mortero cemento 1/8 m-20		\N	59.189	\N	3	2004-01-01	m3	59.190
A02A140	Mortero cemento 1/6 m-40 c/a.miga		\N	59.205	\N	3	2004-01-01	m3	59.200
I	ESTUDIO COSTES INDIRECTOS		\N	13046.796	\N	6	2004-01-01		13046.800
A02S020	Mortero cemento hidrófugo 1/4		\N	76.988	\N	3	2004-01-01	m3	76.980
A03H090	Horm. dosif. 330 kg /cemento tmáx.20		\N	64.611	\N	3	2004-01-01	m3	64.630
O01OA040	Oficial segunda		\N	14.240	\N	1	2004-10-28	h.	14.240
M06CM010	Compre.port.diesel m.p. 2 m3/min 7 bar		\N	1.710	\N	2	2004-01-01	h.	1.710
M06MI010	Martillo manual picador neumático 9 kg		\N	1.560	\N	2	2004-01-01	h.	1.560
P02THE150	Tub.hm j.elástica 60kn/m2 d=300mm		\N	9.850	\N	3	2004-03-16	m.	9.850
P02THM010	Tubo hm j.machihembrada d=150mm		\N	4.510	\N	3	2004-03-16	m.	4.510
P02THM020	Tubo hm j.machihembrada d=200mm		\N	5.230	\N	3	2004-03-16	m.	5.230
M05RN020	Retrocargadora neumáticos 75 cv		\N	33.000	\N	2	2004-01-01	h.	33.000
P02THM030	Tubo hm j.machihembrada d=300mm		\N	6.610	\N	3	2004-03-16	m.	6.610
P02TVO310	Tub.pvc liso multicapa encolado d=110		\N	3.570	\N	3	2004-03-16	m.	3.570
P02TVO320	Tub.pvc liso multicapa encolado d=125		\N	4.120	\N	3	2004-03-16	m.	4.120
P02CVM010	Manguito h-h pvc s/tope j.elást. d=160mm		\N	8.810	\N	3	2004-03-16	ud	8.810
P02CVW010	Lubricante tubos pvc j.elástica		\N	6.770	\N	3	2004-03-16	kg	6.770
P02TVO100	Tub.pvc liso j.elástica sn4 d=160mm		\N	6.870	\N	3	2004-03-16	m.	6.870
P02CVM020	Manguito h-h pvc s/tope j.elást. d=200mm		\N	16.290	\N	3	2004-03-16	ud	16.290
P02TVO110	Tub.PVC liso j.elástica SN4 D=200mm		\N	10.490	\N	3	2004-03-16	m.	10.490
P01HA020	Hormigón ha-25/p/40/i central		\N	72.870	\N	3	2004-01-01	m3	72.870
P02EPW020	Pates acero galvanizado 30x25		\N	4.200	\N	3	2004-03-16	ud	4.200
P02EPO010	Tapa circular ha h=60 d=625		\N	54.100	\N	3	2004-03-16	ud	54.100
O01OB030	Oficial 1ª ferralla		\N	15.160	\N	1	2004-01-01	h.	15.160
O01OB040	Ayudante ferralla		\N	14.220	\N	1	2004-01-01	h.	14.220
P03AC200	Acero corrugado b 500 s		\N	0.390	\N	3	2004-01-01	kg	0.390
P03AA020	Alambre atar 1,30 mm.		\N	0.950	\N	3	2004-01-01	kg	0.950
P03AM030	Malla 15x15x6     -2,792 kg/m2		\N	1.530	\N	3	2004-01-01	m2	1.530
M02GT120	Grúa torre automontante 20 txm.		\N	23.930	\N	2	2004-01-01	h.	23.930
P01HM010	Hormigón hm-20/p/20/i central		\N	70.020	\N	3	2004-01-01	m3	70.020
M11HV120	Aguja eléct.c/convertid.gasolina d=79mm.		\N	4.000	\N	2	2004-01-01	h.	4.000
P01HA010	Hormigón ha-25/p/20/i central		\N	72.870	\N	3	2004-01-01	m3	72.870
P01AG130	Grava 40/80 mm.		\N	16.890	\N	3	2004-01-01	m3	16.890
O01OB130	Oficial 1ª cerrajero		\N	14.770	\N	1	2004-01-01	h.	14.770
O01OB140	Ayudante cerrajero		\N	13.900	\N	1	2004-01-01	h.	13.900
P13TC010	Chapa galvanizada 1 mm.		\N	0.670	\N	3	2004-01-01	kg	0.670
P03AL005	Acero laminado a-42b		\N	1.000	\N	3	2004-01-01	kg	1.000
P25OU080	Minio electrolitico		\N	8.900	\N	3	2004-01-01		8.900
P25JM010	Esmalte metál.rugos.montosintetic ferrum		\N	9.030	\N	3	2004-01-01		9.030
O01OB010	Oficial 1ª encofrador		\N	15.160	\N	1	2004-01-01	h.	15.160
O01OB020	Ayudante encofrador		\N	14.220	\N	1	2004-01-01	h.	14.220
P03VA030	Vigue.d/t pret.18cm.5,1/5,9m(27,5kg/m)		\N	3.940	\N	3	2004-01-01	m.	3.940
P03BC070	Bovedilla cerámica 70x25x25		\N	1.010	\N	3	2004-01-01	ud	1.010
P01EM290	Madera pino encofrar 26 mm.		\N	214.200	\N	3	2004-01-01	m3	214.200
P01UC030	Puntas 20x100		\N	1.000	\N	3	2004-01-01	kg	1.000
M13CP100	Puntal telesc. normal  1,75-3,10		\N	15.280	\N	2	2004-01-01	ud	15.280
P03VS020	Semivigueta h.pret.12cm 4/5 m.(20kg./m)		\N	2.990	\N	3	2004-01-01	m.	2.990
P03BP010	Bov.poliest.curva vigue.horm.520x520x170		\N	2.440	\N	3	2004-01-01	ud	2.440
M13EM030	Tablero encofrar 22 mm. 4 p.		\N	2.030	\N	2	2004-01-01	m2	2.030
P01EM280	Madera pino encofrar 22 mm.		\N	178.500	\N	3	2004-01-01	m3	178.500
O01OB025	Oficial 1ª gruísta		\N	14.770	\N	1	2004-01-01	h.	14.770
M02GT002	Grúa pluma 30 m./0,75 t.		\N	18.840	\N	2	2004-01-01	h.	18.840
M13EF010	Encof. chapa hasta 1 m2.10 p.		\N	2.960	\N	2	2004-01-01	m2	2.960
O01OB050	Oficial 1ª ladrillero		\N	14.960	\N	1	2004-01-01	h.	14.960
O01OB060	Ayudante ladrillero		\N	14.030	\N	1	2004-01-01	h.	14.030
P01LV105	Lad.cv rojo madrid cor.palau 24x11,5x5		\N	114.200	\N	3	2004-01-01		114.200
P01LH010	Ladrillo h. sencillo 24x12x4		\N	122.400	\N	3	2004-01-01		122.400
P01LH050	Ladrillo tochana 29x14x10		\N	173.400	\N	3	2004-01-01		173.400
O01OA050	Ayudante		\N	13.750	\N	1	2004-01-01	h.	13.750
P01WA010	Ayuda de albañilería		\N	830.000	\N	3	2004-01-01	ud	830.000
P01LH020	Ladrillo h. doble 25x12x8		\N	63.100	\N	3	2004-01-01		63.100
O01OB110	Oficial yesero o escayolista		\N	14.770	\N	1	2004-01-01	h.	14.770
P04RW060	Guardavivos plástico y metal		\N	0.260	\N	3	2004-01-01	m.	0.260
O01OB120	Ayudante yesero o escayolista		\N	14.030	\N	1	2004-01-01	h.	14.030
P04TE010	Placa escayola lisa 100x60 cm		\N	1.790	\N	3	2004-01-01	m2	1.790
P04TS010	Esparto en rollos		\N	0.900	\N	3	2004-01-01	kg	0.900
P05TM020	Teja mixta rojo viejo 43x26		\N	0.550	\N	3	2004-01-01	ud	0.550
P05TM060	Teja ventilación mixta 43x26		\N	6.020	\N	3	2004-01-01	ud	6.020
P05TM072	Teja caballete cerám.50x24 rojo viejo		\N	0.700	\N	3	2004-01-01	ud	0.700
E04SE090	Hormigón ha-25/p/20/i  en solera		\N	93.452	\N	7	2004-01-01	m3	93.440
E04CM050	Horm. ha-25/p/20/i  v. manual		\N	95.403	\N	7	2004-01-01	m3	95.400
E05HLM020	Horm. p/armar ha-25/p/20 l.in.		\N	85.929	\N	7	2004-01-01	m3	85.930
E05HFE010	Encof. madera en forjados		\N	3.280	\N	7	2004-01-01	m2	3.280
E05HLE020	Encof. madera losa incl. 4 p.		\N	13.723	\N	7	2004-01-01	m2	13.730
E05HSM010	Horm. p/armar ha-25/p/20/i  pilar		\N	89.572	\N	7	2004-01-01	m3	89.570
E05HSF010	Encofrado metálico en pilares		\N	5.114	\N	7	2004-01-01	m2	5.120
E05HVM010	Horm.p/armar ha-25/p/20/i  jác.		\N	79.904	\N	7	2004-01-01	m3	79.910
E05HVE010	Encof. madera jácenas 4 post.		\N	27.668	\N	7	2004-01-01	m2	27.670
E05HVM030	Horm.p/armar ha-25/p/20/i  zun.		\N	79.904	\N	7	2004-01-01	m3	79.910
E05HVE030	Enc.zunchos con madera 4 pos.		\N	24.065	\N	7	2004-01-01	m2	24.060
P05TM080	Teja remate lateral cerám. occitania		\N	1.100	\N	3	2004-01-01	ud	1.100
P05NH010	Canecillo hor.pre.gris 90x7x10		\N	2.870	\N	3	2004-01-01	ud	2.870
P01LG090	Rasillón cerámico 50x20x4		\N	0.170	\N	3	2004-01-01	ud	0.170
P07AL080	Lámina acústica texsilen 3mm		\N	0.350	\N	3	2004-01-01	m2	0.350
P07CV010	Coqui.lana vid.d=21;1/2" e=30		\N	1.560	\N	3	2004-01-01	m.	1.560
P07CV080	Coqui.lana vid.d=34;1" e=30		\N	1.790	\N	3	2004-01-01	m.	1.790
P07CV160	Coqui.lana vid.d=60;2" e=30		\N	2.370	\N	3	2004-01-01	m.	2.370
P07TX190	P.polies.extr. roofmate-sl-a-30		\N	8.160	\N	3	2004-01-01	m2	8.160
P07TC010	Placa vidrio celular de 450x300x20 mm.		\N	11.900	\N	3	2004-01-01	m2	11.900
P07W230	Grapa para techo vidrio celular		\N	0.060	\N	3	2004-01-01	ud	0.060
P07TX520	P.pol.extr.styrodur 2500-cn-40 mm		\N	9.350	\N	3	2004-01-01	m2	9.350
P06BI036	Emulsión asfáltica emufal i		\N	1.250	\N	3	2004-01-01	kg	1.250
P06BS500	Lám. morterplas polimé. fp 3kg		\N	5.340	\N	3	2004-01-01	m2	5.340
P06BS610	Lám. morterplas  fpv 4 kg mi. gris		\N	6.870	\N	3	2004-01-01	m2	6.870
P06SL310	Lám. pvc 1,2 mm. r.p. danopol i-p		\N	7.210	\N	3	2004-01-01	m2	7.210
P06SI100	Adhesivo líquido de pvc		\N	6.820	\N	3	2004-01-01		6.820
P06BI037	Emulsión caucho asfalto emufal te		\N	1.780	\N	3	2004-01-01	kg	1.780
P06SR020	Revest.elástico impermeab.prelastic 1000		\N	4.600	\N	3	2004-01-01	kg	4.600
O01OB090	Oficial solador, alicatador		\N	14.770	\N	1	2004-01-01	h.	14.770
P08TB020	Baldosa terrazo 40x40 micrograno		\N	10.350	\N	3	2004-01-01	m2	10.350
P08EXB030	Baldosa barro 40x40 manual		\N	25.000	\N	3	2004-01-01	m2	25.000
P08EXP215	Rodapié de barro 40x10		\N	2.500	\N	3	2004-01-01	m.	2.500
P08EXP012	Huella barro decorativo 30x30x2,6 cm		\N	13.330	\N	3	2004-01-01	m.	13.330
P08EXP013	Tabica barro decorativo 30x20x2 cm.		\N	14.810	\N	3	2004-01-01	m.	14.810
P08EXP212	Rodapié barro 30x9 manual		\N	2.650	\N	3	2004-01-01	m.	2.650
P08EXP220	Rodapié cerámico 33x8		\N	2.250	\N	3	2004-01-01	m.	2.250
O01OB070	Oficial cantero		\N	14.770	\N	1	2004-01-01	h.	14.770
P08AB060	Mármol gris macael  60x30x2 cm.		\N	17.570	\N	3	2004-01-01	m2	17.570
P08AW010	Pulido y abrill. in situ mármol		\N	6.370	\N	3	2004-01-01	m2	6.370
O01OB150	Oficial 1ª carpintero		\N	15.530	\N	1	2004-01-01	h.	15.530
P08MQ010	Parque.robl. 25x5x1		\N	13.520	\N	3	2004-01-01	m2	13.520
P08MR160	Rodapié roble 7x1,6 cm.		\N	2.650	\N	3	2004-01-01	m.	2.650
P08MA010	Pegamento s/madera		\N	3.010	\N	3	2004-01-01	kg	3.010
P08MR080	Rodapié chapado sapelly 7x1,6 cm.		\N	1.640	\N	3	2004-01-01	m.	1.640
P25MW010	Barniz poliuret.monocomp.parquet-madera		\N	8.890	\N	3	2004-01-01		8.890
P09ABC101	Azulejo blanco liso 20x25 cm.		\N	5.650	\N	3	2004-01-01	m2	5.650
P09ABC180	Cenefa cerámica relieve 5x20 cm.		\N	3.280	\N	3	2004-01-01	m.	3.280
P09ABC220	Listelo cerámico 7x31,6 cm.		\N	2.910	\N	3	2004-01-01	m.	2.910
O01OB080	Ayudante cantero		\N	14.030	\N	1	2004-01-01	h.	14.030
P09EM010	Encimera mármol nacional e=2cm.		\N	105.240	\N	3	2004-01-01	m2	105.240
P09ED030	Material aux. anclaje encimera		\N	9.290	\N	3	2004-01-01	ud	9.290
P10VA010	Vierteag piedra artificial e=3cm a=25cm		\N	8.320	\N	3	2004-01-01	m.	8.320
O01OB160	Ayudante carpintero		\N	14.030	\N	1	2004-01-01	h.	14.030
P11PP010	Precerco de pino 70x35 mm.		\N	1.870	\N	3	2004-01-01	m.	1.870
P11PP030	Precerco de pino 110x45 mm.		\N	2.760	\N	3	2004-01-01	m.	2.760
P11PM090	Galce de roble macizo 110x30 mm.		\N	6.580	\N	3	2004-01-01	m.	6.580
P11TM090	Tapajunt. lm roble 90x21		\N	3.990	\N	3	2004-01-01	m.	3.990
P11ER050	Puerta entrada tpr roble/castaño		\N	210.250	\N	3	2004-01-01	ud	210.250
P11EB060	Blindaje pe 2 chap.acero 8 dec.		\N	102.640	\N	3	2004-01-01	ud	102.640
P11HB030	Bisagra segur.larga c/rodamient.		\N	45.280	\N	3	2004-01-01	ud	45.280
P11HS060	C.seguridad tabla dorada 3puntos		\N	79.640	\N	3	2004-01-01	ud	79.640
P11HT020	Tirador p.entrada latón pul.bri.		\N	3.160	\N	3	2004-01-01	ud	3.160
P11HM020	Mirilla latón super gran angular		\N	1.600	\N	3	2004-01-01	ud	1.600
P11KW060	Rinconera agl.rech.roble 3x3cm		\N	1.650	\N	3	2004-01-01	m.	1.650
P11WA010	Barn.hoja puertas blindadas		\N	46.870	\N	3	2004-01-01	ud	46.870
P11PR040	Galce de dm r.sapelly 70x30 mm.		\N	2.340	\N	3	2004-01-01	m.	2.340
P11TL040	Tapajunt. dm lr sapelly 70x10		\N	0.650	\N	3	2004-01-01	m.	0.650
P11CH020	P.paso clh sapelly/p.país		\N	52.600	\N	3	2004-01-01	ud	52.600
P11RB040	Pernio latón 80/95 mm. codillo		\N	0.520	\N	3	2004-01-01	ud	0.520
P11WP080	Tornillo ensamble zinc/pavón		\N	0.040	\N	3	2004-01-01	ud	0.040
P11RP010	Pomo latón normal con resbalón		\N	8.120	\N	3	2004-01-01	ud	8.120
P11RW030	Pasador latonado 100/250 mm.		\N	1.870	\N	3	2004-01-01	ud	1.870
P11WA020	Barn.hoja p.ciegas/vidrier.1v.		\N	30.050	\N	3	2004-01-01	ud	30.050
P11PD010	Cerco directo p.melix m. 70x50mm		\N	6.240	\N	3	2004-01-01	m.	6.240
P11TR010	Tapajunt. dm mr pino melix 70x10		\N	1.300	\N	3	2004-01-01	m.	1.300
P11TM100	Tapeta contrachap.pino 70x4 mm.		\N	0.690	\N	3	2004-01-01	m.	0.690
P11AH040	P.armario alh melamina s/cant.		\N	52.160	\N	3	2004-01-01	ud	52.160
P11AH080	P.maleter.mlh melamina s/cant.		\N	31.600	\N	3	2004-01-01	ud	31.600
P11JW100	Juego accesorios armario corredero		\N	6.800	\N	3	2004-01-01	ud	6.800
P11JW115	Carril p. corred. al. dorado		\N	2.830	\N	3	2004-01-01	m.	2.830
P11RW060	Perfil susp. doble p. corred. galv.		\N	5.040	\N	3	2004-01-01	m.	5.040
P11WH100	Cazoleta latón puerta corredera		\N	1.300	\N	3	2004-01-01	ud	1.300
E11RT010	Acuchillado y barnizado		\N	13.193	\N	7	2004-01-01	m2	13.190
E13CD010	Precerco pino 70x35 mm.p/2 hojas		\N	13.745	\N	7	2004-01-01	ud	13.750
E13CS030	Precerco pino 110x35 mm.p/1 hoja		\N	16.031	\N	7	2004-01-01	ud	16.030
P12ACD030	Barand.escalera barrotes alumin.		\N	133.560	\N	3	2004-01-01	m.	133.560
P12PW010	Premarco aluminio		\N	3.500	\N	3	2004-01-01	m.	3.500
P12ACP100	P.balconera practic.2h. >2 m2 <4 m2		\N	82.530	\N	3	2004-01-01	m2	82.530
P12ACV160	Ventanas practicables >1 m2<2 m2		\N	124.100	\N	3	2004-01-01	m2	124.100
P12PL050	Celosía pvc-150 orientable reja		\N	150.690	\N	3	2004-01-01	m2	150.690
P12PX010	Cajón compacto de pvc 140/150 mm		\N	14.610	\N	3	2004-01-01	m.	14.610
P12PX060	Persiana pvc lama 50 mm. reforz.		\N	28.490	\N	3	2004-01-01	m2	28.490
P13CC020	Precerco 50x20x2 galv.		\N	4.700	\N	3	2004-01-01	m.	4.700
P13BT060	Barandilla 90 cm. tubo vert. 20x20x1		\N	33.000	\N	3	2004-01-01	m.	33.000
P13DR020	Reja tubo ace.20x20x1,5 d.artist.		\N	74.000	\N	3	2004-01-01	m2	74.000
P13VP210	Puerta met.abat.galv. 80x200 std		\N	125.520	\N	3	2004-01-01	ud	125.520
P13TT130	Tubo rectangular 50x20x1,5 mm.		\N	1.160	\N	3	2004-01-01	m.	1.160
P13TT140	Tubo cuadrado 30x30x1,5 mm.		\N	0.920	\N	3	2004-01-01	m.	0.920
P13TC060	Chapa lisa negra de 1,5 mm.		\N	6.470	\N	3	2004-01-01	m2	6.470
O01OB250	Oficial 1ª vidriería		\N	14.230	\N	1	2004-01-01	h.	14.230
P14CI010	Vidrio impreso incol. 6/7 mm		\N	24.620	\N	3	2004-01-01	m2	24.620
P14KW060	Sellado con silicona incolora		\N	0.850	\N	3	2004-01-01	m.	0.850
P14ECA030	D. acristalamiento (4/12/4)		\N	17.750	\N	3	2004-01-01	m2	17.750
P14ECA110	D. acristalamiento (6/12/6)		\N	28.230	\N	3	2004-01-01	m2	28.230
O01OB200	Oficial 1ª electricista		\N	15.000	\N	1	2004-01-01	h.	15.000
O01OB220	Ayudante electricista		\N	14.030	\N	1	2004-01-01	h.	14.030
P15CA010	Caja protec. 80a(iii+n)+fusible		\N	42.400	\N	3	2004-01-01	ud	42.400
O01OB210	Oficial 2ª electricista		\N	14.030	\N	1	2004-01-01	h.	14.030
P15GC030	Tubo pvc corrug.forrado m 32/gp7		\N	0.350	\N	3	2004-01-01	m.	0.350
P15AE080	Cond.aisla. 0,6-1kv 3,5x10 cu		\N	2.080	\N	3	2004-01-01	m.	2.080
P15DB010	Módul.conta.monof(unifa)		\N	76.500	\N	3	2004-01-01	ud	76.500
P15EA010	Pica de t.t. 200/14,3 fe+cu		\N	12.150	\N	3	2004-01-01	ud	12.150
P15EB010	Conduc cobre desnudo 35 mm2		\N	1.000	\N	3	2004-01-01	m.	1.000
P15ED030	Sold. alumino t. cable/placa		\N	2.010	\N	3	2004-01-01	ud	2.010
P15EC010	Registro de comprobación + tapa		\N	15.450	\N	3	2004-01-01	ud	15.450
P15EC020	Puente de prueba		\N	5.250	\N	3	2004-01-01	ud	5.250
P15GA030	Cond. rígi. 750 v  4 mm2 cu		\N	0.350	\N	3	2004-01-01	m.	0.350
P15FB200	Armario puerta opaca 26 módulos		\N	48.400	\N	3	2004-01-01	ud	48.400
P15FE100	Pia legrand 2x40 a		\N	38.250	\N	3	2004-01-01	ud	38.250
P15FD020	Int.aut.di. legrand 2x40 a 30 ma		\N	35.940	\N	3	2004-01-01	ud	35.940
P15FE010	Pia legrand (i+n) 10 a		\N	10.720	\N	3	2004-01-01	ud	10.720
P15FE020	Pia legrand (i+n) 16 a		\N	10.950	\N	3	2004-01-01	ud	10.950
P15FE030	Pia legrand (i+n) 20 a		\N	11.210	\N	3	2004-01-01	ud	11.210
P15FE040	Pia legrand (i+n) 25 a		\N	11.470	\N	3	2004-01-01	ud	11.470
P15FA010	Caja para icp (2p), s< 10		\N	3.850	\N	3	2004-01-01	ud	3.850
P15GB010	Tubo pvc corrugado m 20/gp5		\N	0.110	\N	3	2004-01-01	m.	0.110
P15GA010	Cond. rígi. 750 v 1,5 mm2 cu		\N	0.130	\N	3	2004-01-01	m.	0.130
P15GB020	Tubo pvc corrugado m 25/gp5		\N	0.130	\N	3	2004-01-01	m.	0.130
P15GA020	Cond. rígi. 750 v 2,5 mm2 cu		\N	0.220	\N	3	2004-01-01	m.	0.220
P15GA040	Cond. rígi. 750 v  6 mm2 cu		\N	0.500	\N	3	2004-01-01	m.	0.500
P15AI370	Cond.aisla.l.halóg.h07v 6mm2 cu		\N	0.390	\N	3	2004-01-01	m.	0.390
P15AI340	Cond.aisla.l.halóg.h07v 1,5mm2 cu		\N	0.100	\N	3	2004-01-01	m.	0.100
P15GD020	Tubo pvc ríg. der.ind. m 40/gp5		\N	0.550	\N	3	2004-01-01	m.	0.550
P15KC040	Termostato ambiente jung-cd 500		\N	60.020	\N	3	2004-01-01	ud	60.020
P15GK050	Caja mecan. empotrar enlazable		\N	0.250	\N	3	2004-01-01	ud	0.250
P15MSB070	Base e. schuko simón serie 31		\N	6.870	\N	3	2004-01-01	ud	6.870
P15MSC010	Interruptor simón serie 75		\N	7.500	\N	3	2004-01-01	ud	7.500
P15MSC020	Conmutador simón serie 75		\N	8.220	\N	3	2004-01-01	ud	8.220
P15MSC060	Doble conmutador simón serie 75		\N	15.570	\N	3	2004-01-01	ud	15.570
P15MSC040	Pulsador simón serie 75		\N	7.990	\N	3	2004-01-01	ud	7.990
P15MW010	Zumbador		\N	12.230	\N	3	2004-01-01	ud	12.230
P16BK120	Plafón estanco oval con visera 2x9w.		\N	46.400	\N	3	2004-01-01	ud	46.400
P16CC010	Lámp.flu.compa.g23 7/9 w.		\N	1.950	\N	3	2004-01-01	ud	1.950
P16BI010	Aro lámp.halóg.dicro.50w./12v.i/transf.		\N	17.940	\N	3	2004-01-01	ud	17.940
P16CA030	Lámp. halóg.dicroica 12 v. 50 w.		\N	3.000	\N	3	2004-01-01	ud	3.000
P16BE010	Lum.emp.dif.prismático 2x18 w. af		\N	56.800	\N	3	2004-01-01	ud	56.800
P16CC080	Tubo fluorescente 18 w./830-840-827		\N	1.880	\N	3	2004-01-01	ud	1.880
P16BA030	Regleta de superficie 1x36 w. af		\N	8.590	\N	3	2004-01-01	ud	8.590
P16CC090	Tubo fluorescente 36 w./830-840-827		\N	1.880	\N	3	2004-01-01	ud	1.880
P17PB020	Tubo polietileno bd (pe32)(0,6mpa)20mm.		\N	0.360	\N	3	2004-01-01	m.	0.360
P17PP010	Codo polietileno de 20 mm. (ppfv)		\N	1.420	\N	3	2004-01-01	ud	1.420
P17PP260	Collarin toma ppfv 40-3/4"		\N	2.070	\N	3	2004-01-01	ud	2.070
P17BI020	Contador agua fría 3/4" (20 mm.)		\N	51.480	\N	3	2004-01-01	ud	51.480
P17AA030	Arq.polipr.con fondo, 40x40 cm.		\N	38.990	\N	3	2004-01-01	ud	38.990
P17AA110	Marco pp p/tapa, 40x40 cm.		\N	13.620	\N	3	2004-01-01	ud	13.620
P17AA190	Tapa rejilla pp 40x40 cm.		\N	25.520	\N	3	2004-01-01	ud	25.520
P17XE030	Válvula esfera latón roscar 3/4"		\N	3.360	\N	3	2004-01-01	ud	3.360
P17XA090	Grifo de purga d=15mm.		\N	4.760	\N	3	2004-01-01	ud	4.760
P17XR020	Válv.retención latón roscar 3/4"		\N	4.880	\N	3	2004-01-01	ud	4.880
P17W020	Verificación contador		\N	15.260	\N	3	2004-01-01	ud	15.260
P17CH010	Tubo cobre en rollo 10/12 mm.		\N	1.740	\N	3	2004-01-01	m.	1.740
P17CW010	Codo 90º hh cobre de 12 mm.		\N	0.240	\N	3	2004-01-01	ud	0.240
P15GC020	Tubo pvc corrug.forrado m 25/gp7		\N	0.220	\N	3	2004-01-01	m.	0.220
P17CH020	Tubo cobre en rollo 13/15 mm.		\N	2.100	\N	3	2004-01-01	m.	2.100
P17CW020	Codo 90º hh cobre de 15 mm.		\N	0.170	\N	3	2004-01-01	ud	0.170
P17CW100	Te hhh cobre de 15 mm.		\N	0.260	\N	3	2004-01-01	ud	0.260
P17CH030	Tubo cobre en rollo 16/18 mm.		\N	2.580	\N	3	2004-01-01	m.	2.580
P17CW030	Codo 90º hh cobre de 18 mm.		\N	0.240	\N	3	2004-01-01	ud	0.240
P17CW110	Te hhh cobre de 18 mm.		\N	0.560	\N	3	2004-01-01	ud	0.560
P17CD050	Tubo cobre rígido 20/22 mm.		\N	2.940	\N	3	2004-01-01	m.	2.940
P17CW120	Te hhh cobre de 22 mm.		\N	0.970	\N	3	2004-01-01	ud	0.970
P17CW200	Manguito cobre de 22 mm.		\N	0.230	\N	3	2004-01-01	ud	0.230
P17CD060	Tubo cobre rígido 26/28 mm.		\N	3.990	\N	3	2004-01-01	m.	3.990
P17CP030	Curva 90º hh cobre de 28 mm. presión		\N	1.990	\N	3	2004-01-01	ud	1.990
P17CW210	Manguito cobre de 28 mm.		\N	0.650	\N	3	2004-01-01	ud	0.650
P15GC040	Tubo pvc corrug.forrado m 40/gp7		\N	0.400	\N	3	2004-01-01	m.	0.400
P17XP050	Llave paso empot.mand.redon.22mm		\N	11.930	\N	3	2004-01-01	ud	11.930
P17XE020	Válvula esfera latón roscar 1/2"		\N	2.610	\N	3	2004-01-01	ud	2.610
P17XE040	Válvula esfera latón roscar 1"		\N	4.140	\N	3	2004-01-01	ud	4.140
P17VC010	Tubo pvc evac.serie b j.peg.32mm		\N	1.070	\N	3	2004-01-01	m.	1.070
P17VP010	Codo m-h pvc evacuación j.peg. 32 mm.		\N	0.990	\N	3	2004-01-01	ud	0.990
P17VP170	Manguito h-h pvc evac. j.peg. 32 mm.		\N	0.780	\N	3	2004-01-01	ud	0.780
P17VC020	Tubo pvc evac.serie b j.peg.40mm		\N	1.370	\N	3	2004-01-01	m.	1.370
P17VP020	Codo m-h pvc evacuación j.peg. 40 mm.		\N	1.000	\N	3	2004-01-01	ud	1.000
P17VP180	Manguito h-h pvc evac. j.peg. 40 mm.		\N	0.890	\N	3	2004-01-01	ud	0.890
P17SB020	Bote sifón.pvc c/t. inox.5 tomas		\N	7.620	\N	3	2004-01-01	ud	7.620
P17VC030	Tubo pvc evac.serie b j.peg.50mm		\N	1.740	\N	3	2004-01-01	m.	1.740
P17VP190	Manguito h-h pvc evac. j.peg. 50 mm.		\N	1.320	\N	3	2004-01-01	ud	1.320
P17SB030	Bote sifóni.aéreo t/inox.4 tomas		\N	11.160	\N	3	2004-01-01	ud	11.160
P17SD020	Desagüe doble c/sifón curvo 40mm		\N	5.920	\N	3	2004-01-01	ud	5.920
P17SS030	Sifón botella pvc c/t.lavado.40mm 1 1/2"		\N	3.170	\N	3	2004-01-01	ud	3.170
P17VC050	Tubo pvc evac.serie b j.peg.90mm		\N	3.230	\N	3	2004-01-01	m.	3.230
P17VP050	Codo m-h pvc evacuación j.peg. 90 mm.		\N	2.790	\N	3	2004-01-01	ud	2.790
P17JP060	Collarín bajante pvc d=90mm. c/cierre		\N	1.390	\N	3	2004-01-01	ud	1.390
P17VC060	Tubo pvc evac.serie b j.peg.110mm		\N	4.270	\N	3	2004-01-01	m.	4.270
P17VP060	Codo m-h pvc evacuación j.peg. 110mm.		\N	2.890	\N	3	2004-01-01	ud	2.890
P17JP070	Collarín bajante pvc d=110mm. c/cierre		\N	1.530	\N	3	2004-01-01	ud	1.530
P17VC070	Tubo pvc evac.serie b j.peg.125mm		\N	4.870	\N	3	2004-01-01	m.	4.870
P17VP070	Codo m-h pvc evacuación j.peg. 125mm.		\N	5.100	\N	3	2004-01-01	ud	5.100
P17JP080	Collarín bajante pvc d=125mm. c/cierre		\N	1.830	\N	3	2004-01-01	ud	1.830
P17JG020	Bajante a.galv. d=100 mm. p.p.piezas		\N	7.460	\N	3	2004-01-01	m.	7.460
P17NA080	Canalón alum.cuad. 400 mm. p.p.piezas		\N	11.190	\N	3	2004-01-01	m.	11.190
P17NC130	Soporte canalón aluminio		\N	1.650	\N	3	2004-01-01	ud	1.650
P17SW010	Conexión pvc inodoro d=90 mm c/j.labiada		\N	3.630	\N	3	2004-01-01	ud	3.630
P17SW040	Curva 90º pvc a inodoro d=110mm.		\N	9.360	\N	3	2004-01-01	ud	9.360
P18BC010	Bañera acero 170x75 a.d.col		\N	201.000	\N	3	2004-01-01	ud	201.000
P18GB195	G. mmdo. baño-duc.bla.mod. ergos		\N	111.280	\N	3	2004-01-01	ud	111.280
P17SC130	Desag.bañera c/rebos.s.hori.40mm		\N	5.880	\N	3	2004-01-01	ud	5.880
P17SV090	Válvula para baño c/cadena 40mm.		\N	2.700	\N	3	2004-01-01	ud	2.700
P18BC090	Bañera acero 140x70 col.n.europa		\N	72.450	\N	3	2004-01-01	ud	72.450
P18GB180	G. mmdo. baño-duc.cro.mod. aquanova plus		\N	63.370	\N	3	2004-01-01	ud	63.370
P18DP240	P. ducha 70x70 blanco odeón		\N	84.140	\N	3	2004-01-01	ud	84.140
P18GD320	Monomando ducha cromo mod. clip		\N	49.000	\N	3	2004-01-01	ud	49.000
P18DM200	Desagüe p/ducha crom. d60		\N	10.000	\N	3	2004-01-01	ud	10.000
P18LP070	Lav.70x56cm.c/ped.col. dama		\N	131.100	\N	3	2004-01-01	ud	131.100
P18GL080	Grif.monomando lavabo cromo s.m.		\N	53.900	\N	3	2004-01-01	ud	53.900
P17SV100	Válvula p/lavabo-bidé de 32 mm.		\N	2.650	\N	3	2004-01-01	ud	2.650
P17XT030	Llave de escuadra de 1/2" a 1/2"		\N	2.460	\N	3	2004-01-01	ud	2.460
P18GW040	Latiguillo flex.20cm.1/2"a 1/2"		\N	2.600	\N	3	2004-01-01	ud	2.600
P18LP080	Lav.70x56cm.c/ped.bla. dama		\N	94.800	\N	3	2004-01-01	ud	94.800
P18IB010	Inod.t.bajo c/tapa-mec.c.victoria		\N	158.200	\N	3	2004-01-01	ud	158.200
P18VT040	Bidé c/tapa-fij. bla. meridian		\N	112.500	\N	3	2004-01-01	ud	112.500
P18GT060	Grifo monomando bide cromo s.n.		\N	33.500	\N	3	2004-01-01	ud	33.500
P18FA220	Fregadero 80x50cm. 2 senos		\N	82.300	\N	3	2004-01-01	ud	82.300
P18GF270	G. mmdo.ver.fre.cro.mod. aquanova plus		\N	59.020	\N	3	2004-01-01	ud	59.020
P17SV060	Válvula para fregadero de 40 mm.		\N	2.040	\N	3	2004-01-01	ud	2.040
P18CE060	Conjunto accesorios porc. p/emp.		\N	97.050	\N	3	2004-01-01	ud	97.050
E20WGB020	Bote sifónico pvc d=110 empot.		\N	21.354	\N	7	2004-01-01	ud	21.350
E20WBV010	Tubería pvc serie b 32 mm.		\N	3.006	\N	7	2004-01-01	m.	3.010
E20WBV020	Tubería pvc serie b 40 mm.		\N	3.320	\N	7	2004-01-01	m.	3.320
E20WGB030	Bote sifónico pvc d=110 colg.		\N	25.565	\N	7	2004-01-01	ud	25.570
E20XEC030	Inst.agua f.c.aseo con ducha		\N	195.705	\N	7	2004-01-01	ud	195.780
E20WGI060	Desagüe doble pvc c/sif.curvo		\N	14.355	\N	7	2004-01-01	ud	14.350
E20WGI110	Desagüe pvc p/lavadora, s.bot.		\N	9.839	\N	7	2004-01-01	ud	9.840
E20WJF030	Bajante pvc serie b j.peg. 125 mm.		\N	10.572	\N	7	2004-01-01	m.	10.570
E20XEC040	Inst.agua f.c.baño completo		\N	245.961	\N	7	2004-01-01	ud	246.050
P20CF010	Caldera fundic. 18.000 kcal/h.		\N	467.000	\N	3	2004-01-01	ud	467.000
P20TC040	Tuber.cobre d=20/22 mm.i/acc.		\N	2.070	\N	3	2004-01-01	m.	2.070
P20WT090	Termómetro, manómetro y purgador		\N	19.190	\N	3	2004-01-01	ud	19.190
P20WH030	Chimenea vent d=250 mm.		\N	62.380	\N	3	2004-01-01	m.	62.380
P20WH120	Adaptador caldera d=250 mm		\N	19.250	\N	3	2004-01-01	ud	19.250
M02GE020	Grúa telescópica autoprop. 25 t.		\N	52.800	\N	2	2004-01-01	h.	52.800
P20DO030	Depósito aéreo gasóleo 1.000 l.h		\N	603.000	\N	3	2004-01-01	ud	603.000
P20DO240	Valv. red. de presión 1/2"		\N	38.200	\N	3	2004-01-01	ud	38.200
P20TC010	Tuber.cobre d=10/12 mm.i/acc.		\N	1.080	\N	3	2004-01-01	m.	1.080
P20DO210	Boca de carga 3" campsa		\N	28.780	\N	3	2004-01-01	ud	28.780
P20TC120	Tubo pvc d=32 mm.i/acc.		\N	0.880	\N	3	2004-01-01	m.	0.880
P20DO260	Cortafuegos tipo t 1 1/2		\N	10.000	\N	3	2004-01-01	ud	10.000
P20DO250	Avisador de reserva		\N	151.110	\N	3	2004-01-01	ud	151.110
P20WH410	Chimenea aislada inox-inox 150		\N	70.950	\N	3	2004-01-01	ud	70.950
P20TC100	Tubo pvc d=20 mm.i/acc.		\N	0.440	\N	3	2004-01-01	m.	0.440
P20TC020	Tuber.cobre d=13/15 mm.i/acc.		\N	1.490	\N	3	2004-01-01	m.	1.490
P20TC110	Tubo pvc d=25 mm.i/acc.		\N	0.550	\N	3	2004-01-01	m.	0.550
P20TC030	Tuber.cobre d=16/18 mm.i/acc.		\N	1.940	\N	3	2004-01-01	m.	1.940
P20TC130	Tubo pvc d=40 mm.i/acc.		\N	1.360	\N	3	2004-01-01	m.	1.360
P20TC050	Tuber.cobre d=26/28 mm.i/acc.		\N	2.920	\N	3	2004-01-01	m.	2.920
P20TC140	Tubo pvc d=50 mm.i/acc.		\N	1.930	\N	3	2004-01-01	m.	1.930
P20TV010	Válvula de esfera 3/8"		\N	3.200	\N	3	2004-01-01	ud	3.200
P20TV020	Válvula de esfera 1/2"		\N	3.870	\N	3	2004-01-01	ud	3.870
P20MA020	Elemento de aluminio 142,6kcal/h		\N	9.230	\N	3	2004-01-01	ud	9.230
P20MW061	Tapón 1 1/4"		\N	0.650	\N	3	2004-01-01	ud	0.650
P20MW010	Llave monogiro 3/8"		\N	4.370	\N	3	2004-01-01	ud	4.370
P20MW020	Purgador automático		\N	0.450	\N	3	2004-01-01	ud	0.450
P20MW030	Soporte radiador panel		\N	0.490	\N	3	2004-01-01	ud	0.490
P20MW050	Detentor 3/8" recto		\N	4.020	\N	3	2004-01-01	ud	4.020
O01OB230	Oficial 1ª pintura		\N	14.660	\N	1	2004-01-01	h.	14.660
O01OB240	Ayudante pintura		\N	13.410	\N	1	2004-01-01	h.	13.410
P25CT040	Pasta temple blanco mas color		\N	0.170	\N	3	2004-01-01	kg	0.170
P25CT020	Plaste		\N	1.340	\N	3	2004-01-01	kg	1.340
P25WW220	Pequeño material		\N	0.820	\N	3	2004-01-01	ud	0.820
P25OZ040	E.fij.muy pene.obra/mad ext/int fijamont		\N	5.750	\N	3	2004-01-01		5.750
P25OG040	Masilla ultrafina acabados plasmont		\N	1.090	\N	3	2004-01-01	kg	1.090
P25EI020	P.plást.acrílica obra b/col.tornado mate		\N	1.870	\N	3	2004-01-01		1.870
P25OU050	Imp. antiox.+cat amb. marinas impripol+c		\N	11.230	\N	3	2004-01-01		11.230
P25JA080	E.gliceroftálico 1ªcalid.col.montosint		\N	9.350	\N	3	2004-01-01		9.350
P25OU020	Imp. anticorrosiva minio blanco		\N	7.760	\N	3	2004-01-01		7.760
P25MB010	Pintura hidrófuga (barniz)		\N	5.310	\N	3	2004-01-01	kg	5.310
INDI01	Jefe de obra		\N	1983.340	\N	7	2004-01-01		1983.340
INDI02	Administrativo		\N	1298.190	\N	7	2004-01-01		1298.190
INDI03	Encargado		\N	1514.550	\N	7	2004-01-01		1514.550
INDI04	Gruísta		\N	1370.310	\N	7	2004-01-01		1370.310
INDI05	Guardián		\N	685.150	\N	7	2004-01-01		685.150
INDI10	Servicios (luz, agua, etc.)		\N	86.550	\N	7	2004-01-01		86.550
INDI11	Cerramientos y barracones		\N	230.790	\N	7	2004-01-01		230.790
INDI12	Conexiones en tierra		\N	36.060	\N	7	2004-01-01		36.060
INDI20	Grúa		\N	576.970	\N	7	2004-01-01		576.970
INDI21	Montacargas		\N	360.610	\N	7	2004-01-01		360.610
INDI31	Vallas, redes		\N	288.490	\N	7	2004-01-01		288.490
INDI33	Consumo de servicios		\N	288.490	\N	7	2004-01-01		288.490
INDI34	Botiquín		\N	50.490	\N	7	2004-01-01		50.490
INDI35	Papelería		\N	93.760	\N	7	2004-01-01		93.760
INDI36	Otros		\N	403.880	\N	7	2004-01-01		403.880
01	MOVIMIENTO DE TIERRAS		\N	4732.698	\N	6	2004-01-01		2518.670
18	PINTURAS		\N	3486.161	\N	6	2004-01-01		3499.020
05	CERRAMIENTO		\N	14120.467	\N	6	2004-01-01		14119.200
15	CERRAJERÍA		\N	4755.238	\N	6	2004-01-01		4755.530
E07TRP010	Recibido mecanismos persianas	Recibido mecanismos y accesorios de persianas enrrollables, ejes y cajas, con pasta de yeso negro, i/rozas.	Recibido mecanismos y accesorios de persianas enrrollables, ejes y cajas, con pasta de yeso negro, i/rozas.	14.890	\N	7	2004-01-01	ud	14.890
12	PAVIMENTOS		\N	12839.443	\N	6	2004-01-01		12837.700
E08PFM081	Enfos.maestre.hidrófugo 1/4 hor.	Enfoscado maestreado y fratasado con mortero hidrófugo y arena de río 1/4 en paramentos horizontales, i/regleado, sacado de aristas y rincones con maestras cada 3 m. y andamiaje, s/NTE-RPE, medido deduciendo huecos.	Enfoscado maestreado y fratasado con mortero hidrófugo y arena de río 1/4 en paramentos horizontales, i/regleado, sacado de aristas y rincones con maestras cada 3 m. y andamiaje, s/NTE-RPE, medido deduciendo huecos.	13.428	\N	7	2004-01-01	m2	13.430
20	FONTANERÍA		\N	5808.226	\N	6	2004-01-01		5808.590
11	ALICATADOS Y CHAPADOS		\N	1533.108	\N	6	2004-01-01		1533.250
O01OA090	Cuadrilla a		\N	35.435	\N	1	2004-01-01	h.	35.440
02	RED HORIZONTAL DE SANEAMIENTO		\N	1886.783	\N	6	2004-01-01		1887.290
21	CALEFACCIÓN		\N	4944.110	\N	6	2004-01-01		4945.070
E11CCC050	Solera para parquet 1/3		\N	7.228	\N	7	2004-01-01	m2	7.220
E07WF010	Forrado conducto vent. l.h.s.	Forrado de conducto de ventilación doble de 45x25 cm. de sección, con ladrillo  hueco sencillo de 24x12x4 cm., recibido con pasta de yeso negro y mortero de cemento y arena de río 1/6, p.p. de remates y encuentros con la cubierta, s/NTE-ISV, NTE-PLT y NBE-FL-90, medido en su longitud.	Forrado de conducto de ventilación doble de 45x25 cm. de sección, con ladrillo  hueco sencillo de 24x12x4 cm., recibido con pasta de yeso negro y mortero de cemento y arena de río 1/6, p.p. de remates y encuentros con la cubierta, s/NTE-ISV, NTE-PLT y NBE-FL-90, medido en su longitud.	19.638	\N	7	2004-01-01	m.	19.630
E12PCC040	Conducto chimenea l.h.s. 25x25cm	Conducto de salida de humos o ventilación de 25x25 cm. realizado con ladrillo hueco sencillo de 24x12x4 cm., recibido con pasta de yeso negro, enlucido interior y limpieza, s/NTE-ISV, NTE-PTL, NBE-FL-90 y NTE-RPG, medido en su longitud.	Conducto de salida de humos o ventilación de 25x25 cm. realizado con ladrillo hueco sencillo de 24x12x4 cm., recibido con pasta de yeso negro, enlucido interior y limpieza, s/NTE-ISV, NTE-PTL, NBE-FL-90 y NTE-RPG, medido en su longitud.	15.787	\N	7	2004-01-01	m.	15.780
E02PM030	Excavación pozos a máquina terreno compacto	Excavación en pozos en terrenos compactos, por medios mecánicos, con extracción de tierras a los bordes, sin carga ni transporte al vertedero, y con p.p. de medios auxiliares.	Excavación en pozos en terrenos compactos, por medios mecánicos, con extracción de tierras a los bordes, sin carga ni transporte al vertedero, y con p.p. de medios auxiliares.	12.622	\N	7	2004-01-01	m3	12.620
08	AISLAMIENTOS		\N	5772.037	\N	6	2004-01-01		5775.960
E02TT040	Transporte vertedero dist. <20km carga mecánica	Transporte de tierras al vertedero, a una distancia menor de 20 km., considerando ida y vuelta, con camión bañera basculante cargado a máquina, y con p.p. de medios auxiliares, considerando también la carga.	Transporte de tierras al vertedero, a una distancia menor de 20 km., considerando ida y vuelta, con camión bañera basculante cargado a máquina, y con p.p. de medios auxiliares, considerando también la carga.	9.505	\N	7	2004-01-01	m3	9.510
E02CM060	Excavación cielo abierto, roca dura, martillo romp	Excavación a cielo abierto, en terrenos de roca dura, con martillo rompedor, con extracción de tierras fuera de la excavación, en vaciados, sin carga ni transporte al vertedero y con p.p. de medios auxiliares.	Excavación a cielo abierto, en terrenos de roca dura, con martillo rompedor, con extracción de tierras fuera de la excavación, en vaciados, sin carga ni transporte al vertedero y con p.p. de medios auxiliares.	24.303	\N	7	2004-01-01	m3	24.310
E20VE020	Llave de paso 22mm. 3/4" p/empotrar		\N	15.052	\N	7	2004-01-01	ud	15.050
E03ALA010	Arqueta ladri.pie/bajante 38x38x50cm	Arqueta a pie de bajante registrable, de 38x38x50 cm. de medidas interiores, construida con fábrica de ladrillo macizo tosco de 1/2 pie de espesor, recibido con mortero de cemento, colocado sobre solera de hormigón en masa HM-20/P/40/I, enfoscada y bruñida por el interior con mortero de cemento, con codo de PVC de 45º, para evitar el golpe de bajada en la solera, y con tapa de hormigón armado prefabricada, terminada y con p.p. de medios auxiliares, sin incluir la excavación, ni el relleno perimetral posterior.	Arqueta a pie de bajante registrable, de 38x38x50 cm. de medidas interiores, construida con fábrica de ladrillo macizo tosco de 1/2 pie de espesor, recibido con mortero de cemento, colocado sobre solera de hormigón en masa HM-20/P/40/I, enfoscada y bruñida por el interior con mortero de cemento, con codo de PVC de 45º, para evitar el golpe de bajada en la solera, y con tapa de hormigón armado prefabricada, terminada y con p.p. de medios auxiliares, sin incluir la excavación, ni el relleno perimetral posterior.	69.046	\N	7	2004-01-01	ud	69.040
E11EXP220	Rodapié cerámico 8x33 cm.	Rodapié cerámico de 33x8 cm., recibido con mortero de cemento CEM II/B-P 32,5 N y arena de río 1/6 (M-40), i/rejuntado con lechada de cemento CEM II/B-P 32,5 N 1/2 y limpieza s/NTE-RSR, medido en su longitud.	Rodapié cerámico de 33x8 cm., recibido con mortero de cemento CEM II/B-P 32,5 N y arena de río 1/6 (M-40), i/rejuntado con lechada de cemento CEM II/B-P 32,5 N 1/2 y limpieza s/NTE-RSR, medido en su longitud.	5.280	\N	7	2004-01-01	m.	5.280
10	REVESTIMIENTOS		\N	10535.296	\N	6	2004-01-01		10529.500
E04AB020	Acero corrugado b 500 s		\N	0.817	\N	7	2004-01-01	kg	0.820
04	ESTRUCTURAS		\N	28626.983	\N	6	2004-01-01		28641.800
E20XEC050	Inst.agua f.c.cocina completa		\N	222.922	\N	7	2004-01-01	ud	222.980
E04AM060	Malla 15x15 cm. d=6 mm.		\N	2.148	\N	7	2004-01-01	m2	2.140
E04CA010	H.arm. ha-25/p/20/i  v.manual		\N	128.083	\N	7	2004-01-01	m3	128.200
06	PARTICIONES INTERIORES		\N	9170.071	\N	6	2004-01-01		9170.050
E03ALR020	Arqueta ladri.registro 38x38x50 cm.	Arqueta de registro de 38x38x50 cm. de medidas interiores, construida con fábrica de ladrillo perforado tosco de 1/2 pie de espesor, recibido con mortero de cemento (M-40), colocado sobre solera de hormigón en masa HM-20/P/40/I ligeramente armada con mallazo, enfoscada y bruñida por el interior con mortero de cemento (M-100), y con tapa de hormigón armado prefabricada, terminada y con p.p. de medios auxiliares, sin incluir la excavación, ni el relleno perimetral posterior.	Arqueta de registro de 38x38x50 cm. de medidas interiores, construida con fábrica de ladrillo perforado tosco de 1/2 pie de espesor, recibido con mortero de cemento (M-40), colocado sobre solera de hormigón en masa HM-20/P/40/I ligeramente armada con mallazo, enfoscada y bruñida por el interior con mortero de cemento (M-100), y con tapa de hormigón armado prefabricada, terminada y con p.p. de medios auxiliares, sin incluir la excavación, ni el relleno perimetral posterior.	55.041	\N	7	2004-01-01	ud	55.040
E03ALR040	Arqueta ladri.registro 51x51x65 cm.	Arqueta de registro de 51x51x65 cm. de medidas interiores, construida con fábrica de ladrillo perforado tosco de 1/2 pie de espesor, recibido con mortero de cemento (M-40), colocado sobre solera de hormigón en masa HM-20/P/40/I ligeramente armada con mallazo, enfoscada y bruñida por el interior con mortero de cemento (M-100), y con tapa de hormigón armado prefabricada, terminada y con p.p. de medios auxiliares, sin incluir la excavación, ni el relleno perimetral posterior.	Arqueta de registro de 51x51x65 cm. de medidas interiores, construida con fábrica de ladrillo perforado tosco de 1/2 pie de espesor, recibido con mortero de cemento (M-40), colocado sobre solera de hormigón en masa HM-20/P/40/I ligeramente armada con mallazo, enfoscada y bruñida por el interior con mortero de cemento (M-100), y con tapa de hormigón armado prefabricada, terminada y con p.p. de medios auxiliares, sin incluir la excavación, ni el relleno perimetral posterior.	68.489	\N	7	2004-01-01	ud	68.500
E03ALS020	Arqueta ladri.sifónica 51x51x65 cm.	Arqueta sifónica registrable de 51x51x65 cm. de medidas interiores, construida con fábrica de ladrillo perforado tosco de 1/2 pie de espesor, recibido con mortero de cemento (M-40), colocado sobre solera de hormigón en masa HM-20/P/40/I, enfoscada y bruñida por el interior con mortero de cemento (M-100), con sifón formado por un codo de 87,5º de PVC largo, y con tapa de hormigón armado prefabricada, terminada y con p.p. de medios auxiliares, sin incluir la excavación, ni el relleno perimetral posterior.	Arqueta sifónica registrable de 51x51x65 cm. de medidas interiores, construida con fábrica de ladrillo perforado tosco de 1/2 pie de espesor, recibido con mortero de cemento (M-40), colocado sobre solera de hormigón en masa HM-20/P/40/I, enfoscada y bruñida por el interior con mortero de cemento (M-100), con sifón formado por un codo de 87,5º de PVC largo, y con tapa de hormigón armado prefabricada, terminada y con p.p. de medios auxiliares, sin incluir la excavación, ni el relleno perimetral posterior.	73.811	\N	7	2004-01-01	ud	73.820
E03ZLR010	Pozo ladri.registro d=80cm. h=1,00m.	Pozo de registro de 80 cm. de diámetro interior y de 100 cm. de profundidad libre, construido con fábrica de ladrillo macizo tosco de 1 pie de espesor, recibido con mortero de cemento, colocado sobre solera de hormigón HA-25/P/40/I, ligeramente armada con mallazo; enfoscado y bruñido por el interior, con mortero de cemento, incluso con p.p. de recibido de pates, formación de canal en el fondo del pozo y formación de brocal asimétrico en la coronación, para recibir el cerco y la tapa de hormigón armado, terminado con p.p. de medios auxiliares, sin incluir la excavación ni el relleno perimetral posterior.	Pozo de registro de 80 cm. de diámetro interior y de 100 cm. de profundidad libre, construido con fábrica de ladrillo macizo tosco de 1 pie de espesor, recibido con mortero de cemento, colocado sobre solera de hormigón HA-25/P/40/I, ligeramente armada con mallazo; enfoscado y bruñido por el interior, con mortero de cemento, incluso con p.p. de recibido de pates, formación de canal en el fondo del pozo y formación de brocal asimétrico en la coronación, para recibir el cerco y la tapa de hormigón armado, terminado con p.p. de medios auxiliares, sin incluir la excavación ni el relleno perimetral posterior.	191.328	\N	7	2004-01-01	ud	191.350
E03OEH010	Tubo hm machihembrado d=150 mm	Colector de saneamiento enterrado de hormigón en masa centrifugado de sección circular y diámetro 150 mm., con unión por junta machihembrada. Colocado en zanja, sobre una cama de arena de río de 10 cm. debidamente compactada y nivelada, con corchetes de ladrillo perforado tosco en las uniones recibidos con mortero de cemento 1/6 (M-40) y relleno lateral y superior hasta 10 cm. por encima de la generatriz con la misma arena; compactando ésta hasta los riñones. Con p.p. de medios auxiliares y sin incluir la excavación ni el tapado posterior de las zanjas.	Colector de saneamiento enterrado de hormigón en masa centrifugado de sección circular y diámetro 150 mm., con unión por junta machihembrada. Colocado en zanja, sobre una cama de arena de río de 10 cm. debidamente compactada y nivelada, con corchetes de ladrillo perforado tosco en las uniones recibidos con mortero de cemento 1/6 (M-40) y relleno lateral y superior hasta 10 cm. por encima de la generatriz con la misma arena; compactando ésta hasta los riñones. Con p.p. de medios auxiliares y sin incluir la excavación ni el tapado posterior de las zanjas.	19.819	\N	7	2004-01-01	m.	19.820
E03OEH020	Tubo hm machihembrado d=200 mm	Colector de saneamiento enterrado de hormigón en masa centrifugado de sección circular y diámetro 200  mm., con unión por junta machihembrada. Colocado en zanja, sobre una cama de arena de río de 10 cm. debidamente compactada y nivelada, con corchetes de ladrillo perforado tosco en las uniones recibidos con mortero de cemento 1/6 (M-40) y relleno lateral y superior hasta 10 cm. por encima de la generatriz con la misma arena; compactando ésta hasta los riñones. Con p.p. de medios auxiliares y sin incluir la excavación ni el tapado posterior de las zanjas.	Colector de saneamiento enterrado de hormigón en masa centrifugado de sección circular y diámetro 200  mm., con unión por junta machihembrada. Colocado en zanja, sobre una cama de arena de río de 10 cm. debidamente compactada y nivelada, con corchetes de ladrillo perforado tosco en las uniones recibidos con mortero de cemento 1/6 (M-40) y relleno lateral y superior hasta 10 cm. por encima de la generatriz con la misma arena; compactando ésta hasta los riñones. Con p.p. de medios auxiliares y sin incluir la excavación ni el tapado posterior de las zanjas.	20.806	\N	7	2004-01-01	m.	20.810
E05HVA075	Ha-25/p/20/i  e.mad.zunchos pl.	Hormigón armado HA-25 N/mm2., Tmáx.20 mm., consistencia plástica elaborado central, en zunchos planos, i/p.p. de armadura (75 kg/m3.) y encofrado de madera vista, vertido con pluma-grúa, vibrado y colocado. Según normas NTE-EME y EHE.	Hormigón armado HA-25 N/mm2., Tmáx.20 mm., consistencia plástica elaborado central, en zunchos planos, i/p.p. de armadura (75 kg/m3.) y encofrado de madera vista, vertido con pluma-grúa, vibrado y colocado. Según normas NTE-EME y EHE.	466.057	\N	7	2004-01-01	m3	466.220
E03OEH030	Tubo hm machihembrado d=300 mm	Colector de saneamiento enterrado de hormigón en masa centrifugado de sección circular y diámetro 300 mm., con unión por junta machihembrada. Colocado en zanja, sobre una cama de arena de río de 10 cm. debidamente compactada y nivelada, con corchetes de ladrillo perforado tosco en las uniones recibidos con mortero de cemento 1/6 (M-40) y relleno lateral y superior hasta 10 cm. por encima de la generatriz con la misma arena; compactando ésta hasta los riñones. Con p.p. de medios auxiliares y sin incluir la excavación ni el tapado posterior de las zanjas.	Colector de saneamiento enterrado de hormigón en masa centrifugado de sección circular y diámetro 300 mm., con unión por junta machihembrada. Colocado en zanja, sobre una cama de arena de río de 10 cm. debidamente compactada y nivelada, con corchetes de ladrillo perforado tosco en las uniones recibidos con mortero de cemento 1/6 (M-40) y relleno lateral y superior hasta 10 cm. por encima de la generatriz con la misma arena; compactando ésta hasta los riñones. Con p.p. de medios auxiliares y sin incluir la excavación ni el tapado posterior de las zanjas.	28.920	\N	7	2004-01-01	m.	28.930
E03OEP008	Tubo pvc liso multicapa encol. 125mm	Colector de saneamiento enterrado de PVC liso multicapa con un diámetro 125 mm. encolado.  Colocado en zanja, sobre una cama de arena de río de 10 cm. debidamente compactada y nivelada, relleno lateralmente y superiormente hasta 10 cm. por encima de la generatriz con la misma arena; compactando ésta hasta los riñones. Con p.p. de medios auxiliares y sin incluir la excavación ni el tapado posterior de las zanjas.	Colector de saneamiento enterrado de PVC liso multicapa con un diámetro 125 mm. encolado.  Colocado en zanja, sobre una cama de arena de río de 10 cm. debidamente compactada y nivelada, relleno lateralmente y superiormente hasta 10 cm. por encima de la generatriz con la misma arena; compactando ésta hasta los riñones. Con p.p. de medios auxiliares y sin incluir la excavación ni el tapado posterior de las zanjas.	8.912	\N	7	2004-01-01	m.	8.920
E03OEP130	Tubo pvc comp. j.elás.sn4 c.teja  160mm	Colector de saneamiento enterrado de PVC de pared compacta de color teja y rigidez 4 kN/m2; con un diámetro 160 mm. y de unión por junta elástica. Colocado en zanja, sobre una cama de arena de río de 10 cm. debidamente compactada y nivelada, relleno lateralmente y superiormente hasta 10 cm. por encima de la generatriz con la misma arena; compactando ésta hasta los riñones. Con p.p. de medios auxiliares y sin incluir la excavación ni el tapado posterior de las zanjas.	Colector de saneamiento enterrado de PVC de pared compacta de color teja y rigidez 4 kN/m2; con un diámetro 160 mm. y de unión por junta elástica. Colocado en zanja, sobre una cama de arena de río de 10 cm. debidamente compactada y nivelada, relleno lateralmente y superiormente hasta 10 cm. por encima de la generatriz con la misma arena; compactando ésta hasta los riñones. Con p.p. de medios auxiliares y sin incluir la excavación ni el tapado posterior de las zanjas.	14.775	\N	7	2004-01-01	m.	14.770
E03OEP140	Tubo pvc comp. j.elás.sn4 c.teja  200mm	Colector de saneamiento enterrado de PVC de pared compacta de color teja y rigidez 4 kN/m2; con un diámetro 200 mm. y de unión por junta elástica. Colocado en zanja, sobre una cama de arena de río de 10 cm. debidamente compactada y nivelada, relleno lateralmente y superiormente hasta 10 cm. por encima de la generatriz con la misma arena; compactando ésta hasta los riñones. Con p.p. de medios auxiliares y sin incluir la excavación ni el tapado posterior de las zanjas.	Colector de saneamiento enterrado de PVC de pared compacta de color teja y rigidez 4 kN/m2; con un diámetro 200 mm. y de unión por junta elástica. Colocado en zanja, sobre una cama de arena de río de 10 cm. debidamente compactada y nivelada, relleno lateralmente y superiormente hasta 10 cm. por encima de la generatriz con la misma arena; compactando ésta hasta los riñones. Con p.p. de medios auxiliares y sin incluir la excavación ni el tapado posterior de las zanjas.	21.282	\N	7	2004-01-01	m.	21.290
E03M010	Acometida red gral.saneamiento	Acometida domiciliaria de saneamiento a la red general municipal, hasta una distancia máxima de 8 m., formada por: rotura del pavimento con compresor, excavación manual de zanjas de saneamiento en terrenos de consistencia dura, colocación de tubería de hormigón en masa de enchufe de campana, con junta de goma de 30 cm. de diámetro interior, tapado posterior de la acometida y reposición del pavimento con hormigón en masa HM-20/P/40/I, sin incluir formación del pozo en el punto de acometida y con p.p. de medios auxiliares.	Acometida domiciliaria de saneamiento a la red general municipal, hasta una distancia máxima de 8 m., formada por: rotura del pavimento con compresor, excavación manual de zanjas de saneamiento en terrenos de consistencia dura, colocación de tubería de hormigón en masa de enchufe de campana, con junta de goma de 30 cm. de diámetro interior, tapado posterior de la acometida y reposición del pavimento con hormigón en masa HM-20/P/40/I, sin incluir formación del pozo en el punto de acometida y con p.p. de medios auxiliares.	495.833	\N	7	2004-01-01	ud	496.090
E04CA060	H.arm. ha-25/p/20/i  v. grúa	Hormigón armado HA-25 N/mm2., Tmáx.20 mm., para ambiente normal, elaborado en central en relleno de zapatas y zanjas de cimentación, incluso armadura (40 kg./m3.), vertido con grúa, vibrado y colocado.  Según normas NTE-CSZ y EHE.	Hormigón armado HA-25 N/mm2., Tmáx.20 mm., para ambiente normal, elaborado en central en relleno de zapatas y zanjas de cimentación, incluso armadura (40 kg./m3.), vertido con grúa, vibrado y colocado.  Según normas NTE-CSZ y EHE.	132.869	\N	7	2004-01-01	m3	132.990
E04SE020	Encachado piedra 40/80 e=20cm	Encachado de piedra caliza 40/80 de 20 cm. de espesor en sub-base de solera, i/extendido y compactado con pisón.	Encachado de piedra caliza 40/80 de 20 cm. de espesor en sub-base de solera, i/extendido y compactado con pisón.	6.334	\N	7	2004-01-01	m2	6.340
E05HSA010	Ha-25/p/20/i  e.metál. pilares	Hormigón armado HA-25 N/mm2., Tmáx.20 mm., consistencia plástica elaborado en central, en pilares de 30x30 cm., i/p.p. de armadura (80 kg/m3.) y encofrado metálico, vertido con pluma-grúa, vibrado y colocado. Según normas NTE-EHS y EHE.	Hormigón armado HA-25 N/mm2., Tmáx.20 mm., consistencia plástica elaborado en central, en pilares de 30x30 cm., i/p.p. de armadura (80 kg/m3.) y encofrado metálico, vertido con pluma-grúa, vibrado y colocado. Según normas NTE-EHS y EHE.	223.102	\N	7	2004-01-01	m3	223.420
E05HVA030	Ha-25/p/20/i  e.mad.jác.cuelg.	Hormigón armado HA-25 N/mm2., Tmáx.20 mm., consistencia plástica, elaborado en central, en jácenas de cuelgue, i/p.p. de armadura (150 kg/m3.) y encofrado de madera, vertido con pluma-grúa, vibrado y colocado. Según normas NTE-EME y EHE.	Hormigón armado HA-25 N/mm2., Tmáx.20 mm., consistencia plástica, elaborado en central, en jácenas de cuelgue, i/p.p. de armadura (150 kg/m3.) y encofrado de madera, vertido con pluma-grúa, vibrado y colocado. Según normas NTE-EME y EHE.	538.620	\N	7	2004-01-01	m3	539.100
E07TRC030	Recibido cercos en muros ext.	Recibido y aplomado de cercos en muros exteriores, con mortero de cemento CEM II/B-P 32,5 N y arena de río 1/4.	Recibido y aplomado de cercos en muros exteriores, con mortero de cemento CEM II/B-P 32,5 N y arena de río 1/4.	12.059	\N	7	2004-01-01	m2	12.060
E05HFA060	Forj.dob.vig.aut. 25+5, b-70	Forjado 25+5 cm. formado por doble vigueta autorresistente de hormigón pretensado, separadas 70 cm. entre ejes, bovedilla cerámica de 70x25x25 cm. y capa de compresión de 5 cm., de hormigón HA-25/P/20/I, de central, i/armadura (2,50 kg/m2), terminado.  (Carga total 600 kg/m2). Según normas NTE, EHE y EFHE.	Forjado 25+5 cm. formado por doble vigueta autorresistente de hormigón pretensado, separadas 70 cm. entre ejes, bovedilla cerámica de 70x25x25 cm. y capa de compresión de 5 cm., de hormigón HA-25/P/20/I, de central, i/armadura (2,50 kg/m2), terminado.  (Carga total 600 kg/m2). Según normas NTE, EHE y EFHE.	41.913	\N	7	2004-01-01	m2	41.920
E05HFS160	Forj.semiv.17+5, b.poliest.-60	Forjado 17+5 cm. formado por semiviguetas de hormigón pretensado separadas 60 cm., bovedilla moldeada de poliestireno de 52x52x17 cm. y capa de compresión de 5 cm., de hormigón HA-25/P/20/I, elaborado en central, i/armadura (1,80 kg/m2), terminado.  (Carga total 600 kg/m2).  Según normas NTE, EFHE y EHE.	Forjado 17+5 cm. formado por semiviguetas de hormigón pretensado separadas 60 cm., bovedilla moldeada de poliestireno de 52x52x17 cm. y capa de compresión de 5 cm., de hormigón HA-25/P/20/I, elaborado en central, i/armadura (1,80 kg/m2), terminado.  (Carga total 600 kg/m2).  Según normas NTE, EFHE y EHE.	26.927	\N	7	2004-01-01	m2	26.920
E05AW020	Chapa dintel hueco 250x4 gal.	Dintel de hueco, formado por chapa galvanizada de 25 cm. de ancho y 4 mm. de espesor, reforzada con dos angulares de 30x30x3,pintados con pintura de minio de plomo, soldadas a la chapa y sujeta al forjado superior mediante tirantes de acero, y en los laterales, colocada y montada. Según normas NTE y norma NBE-MV.	Dintel de hueco, formado por chapa galvanizada de 25 cm. de ancho y 4 mm. de espesor, reforzada con dos angulares de 30x30x3,pintados con pintura de minio de plomo, soldadas a la chapa y sujeta al forjado superior mediante tirantes de acero, y en los laterales, colocada y montada. Según normas NTE y norma NBE-MV.	18.086	\N	7	2004-01-01	m.	18.090
E05AW040	Angular de 60 mm. remate	Angular de 60 mm. con acero laminado A-42b en caliente, en remate y/o arranque de fábrica de ladrillo, i/p.p. de sujeción, nivelación, aplomado, pintura de minio electrolítico y pintura de esmalte (dos manos), empalmes por soldadura, cortes y taladros, colocado. Según normas NTE y NBE-MV.	Angular de 60 mm. con acero laminado A-42b en caliente, en remate y/o arranque de fábrica de ladrillo, i/p.p. de sujeción, nivelación, aplomado, pintura de minio electrolítico y pintura de esmalte (dos manos), empalmes por soldadura, cortes y taladros, colocado. Según normas NTE y NBE-MV.	19.216	\N	7	2004-01-01	m.	19.230
E07LSB040	Fáb.ladr. c/v-5,2 1p. r.madrid c.palau	Fábrica de ladrillo cara vista rojo Madrid corcho de Palau de 24x11,5x5,2 cm. de 1 pie de espesor, recibido con mortero de cemento CEM II/B-P 32,5 N y arena de río 1/6, i/replanteo, nivelación y aplomado, p.p. de enjarjes, mermas y roturas, humedecido de las piezas, rejuntado, limpieza y medios auxiliares, s/NTE-FFL y NBE-FL-90, medida deduciendo huecos superiores a 1 m2.	Fábrica de ladrillo cara vista rojo Madrid corcho de Palau de 24x11,5x5,2 cm. de 1 pie de espesor, recibido con mortero de cemento CEM II/B-P 32,5 N y arena de río 1/6, i/replanteo, nivelación y aplomado, p.p. de enjarjes, mermas y roturas, humedecido de las piezas, rejuntado, limpieza y medios auxiliares, s/NTE-FFL y NBE-FL-90, medida deduciendo huecos superiores a 1 m2.	55.866	\N	7	2004-01-01	m2	55.860
E07TBL010	Tabique lad.h/s c/cemento divis.	Tabique de ladrillo hueco sencillo de 24x12x4 cm. en divisiones, recibido con mortero de cemento CEM II/B-P 32,5 N y arena de río 1/6, i/replanteo, aplomado y recibido de cercos, roturas, humedecido de las piezas, limpieza y medios auxiliares, s/NTE-PTL y NBE-FL-90, medido deduciendo huecos superiores a 2 m2.	Tabique de ladrillo hueco sencillo de 24x12x4 cm. en divisiones, recibido con mortero de cemento CEM II/B-P 32,5 N y arena de río 1/6, i/replanteo, aplomado y recibido de cercos, roturas, humedecido de las piezas, limpieza y medios auxiliares, s/NTE-PTL y NBE-FL-90, medido deduciendo huecos superiores a 2 m2.	13.039	\N	7	2004-01-01	m2	13.030
E07TBL190	Tabicón h/d tochana 29x14x10	Tabique de ladrillo hueco doble tochana de 29x14x10 cm., recibido con mortero de cemento CEM II/B-P 32,5 N y arena de río 1/6 en distribución, i/p.p. de replanteo, aplomado y recibido de cercos, roturas, humedecido de las piezas, limpieza y medios auxiliares, s/NTE-PTL y NBE-FL-90, medido deduciendo huecos superiores a 2 m2.	Tabique de ladrillo hueco doble tochana de 29x14x10 cm., recibido con mortero de cemento CEM II/B-P 32,5 N y arena de río 1/6 en distribución, i/p.p. de replanteo, aplomado y recibido de cercos, roturas, humedecido de las piezas, limpieza y medios auxiliares, s/NTE-PTL y NBE-FL-90, medido deduciendo huecos superiores a 2 m2.	14.817	\N	7	2004-01-01	m2	14.820
E07LP013	Fáb.ladr perf.rev.7cm.1/2p.inter	Fábrica de ladrillo perforado de 25x12x7 cm. de 1/2 pie de espesor en interior, recibido con mortero de cemento CEM II/B-P 32,5 N y arena de río 1/6, para revestir, i/replanteo, nivelación y aplomado, p.p. de enjarjes, mermas, roturas, humedecido de las piezas, rejuntado, limpieza y medios auxiliares, s/NTE-FFL y NBE-FL-90, medida deduciendo huecos superiores a 1 m2.	Fábrica de ladrillo perforado de 25x12x7 cm. de 1/2 pie de espesor en interior, recibido con mortero de cemento CEM II/B-P 32,5 N y arena de río 1/6, para revestir, i/replanteo, nivelación y aplomado, p.p. de enjarjes, mermas, roturas, humedecido de las piezas, rejuntado, limpieza y medios auxiliares, s/NTE-FFL y NBE-FL-90, medida deduciendo huecos superiores a 1 m2.	13.623	\N	7	2004-01-01	m2	13.630
E07WP010	Formación peldaño ladril.h/d	Formación de peldaños de escalera con ladrillo hueco doble de 25x12x8 cm. recibido con mortero de cemento CEM II/B-P 32,5 N y arena de río 1/6, i/replanteo y limpieza, medido en su longitud.	Formación de peldaños de escalera con ladrillo hueco doble de 25x12x8 cm. recibido con mortero de cemento CEM II/B-P 32,5 N y arena de río 1/6, i/replanteo y limpieza, medido en su longitud.	13.340	\N	7	2004-01-01	m.	13.350
E07TRE010	Recibido barandilla metálica	Recibido de barandilla metálica, en balcones o escaleras, con mortero de cemento CEM II/B-P 32,5 N y arena de río 1/4, i/apertura y tapado de huecos para garras, medido en su longitud.	Recibido de barandilla metálica, en balcones o escaleras, con mortero de cemento CEM II/B-P 32,5 N y arena de río 1/4, i/apertura y tapado de huecos para garras, medido en su longitud.	10.402	\N	7	2004-01-01	m.	10.400
E12PVA010	Vierteag.piedra artificial e=3cm a=25cm	Vierteaguas de piedra artificial con goterón, formado por piezas de 25 cm. de ancho y 3 cm. de espesor, pulido en fábrica, recibido con mortero de cemento CEM II/B-P 32,5 N y arena de río 1/6 (M-40), i/rejuntado con lechada de cemento blanco BL-V 22,5 y limpieza, medido en su longitud.	Vierteaguas de piedra artificial con goterón, formado por piezas de 25 cm. de ancho y 3 cm. de espesor, pulido en fábrica, recibido con mortero de cemento CEM II/B-P 32,5 N y arena de río 1/6 (M-40), i/rejuntado con lechada de cemento blanco BL-V 22,5 y limpieza, medido en su longitud.	18.522	\N	7	2004-01-01	m.	18.520
E07TRP020	Recibido capialzado persianas	Recibido de bastidor de madera en capialzado, para registro de persianas enrrollables, con pasta de yeso negro, i/rozas, medido en su longitud.	Recibido de bastidor de madera en capialzado, para registro de persianas enrrollables, con pasta de yeso negro, i/rozas, medido en su longitud.	16.473	\N	7	2004-01-01	m.	16.480
E07TRE020	Recibido reja en fábrica	Colocación de reja metálica con garras empotradas en el muro, con mortero de cemento CEM II/B-P 32,5 N y arena de río 1/4, i/apertura y tapado de huecos para garras, medida la superficie ejecutada.	Colocación de reja metálica con garras empotradas en el muro, con mortero de cemento CEM II/B-P 32,5 N y arena de río 1/4, i/apertura y tapado de huecos para garras, medida la superficie ejecutada.	23.694	\N	7	2004-01-01	m2	23.690
E07TRW020	Recibido bañera> 1m.	Recibido de bañera mayor de 1 m. de longitud con ladrillo hueco sencillo y mortero de cemento CEM II/B-P 32,5 N y arena de río 1/4, i/tabicado de faldón con ladrillo hueco sencillo, sellado de juntas, limpieza y medios auxiliares.	Recibido de bañera mayor de 1 m. de longitud con ladrillo hueco sencillo y mortero de cemento CEM II/B-P 32,5 N y arena de río 1/4, i/tabicado de faldón con ladrillo hueco sencillo, sellado de juntas, limpieza y medios auxiliares.	76.479	\N	7	2004-01-01	ud	76.480
E07WA020	Ayuda albañilería a fontaner.	Ayuda de albañilería a instalación de fontanería por vivienda incluyendo mano de obra en carga y descarga, materiales, apertura y tapado de rozas, recibidos, limpieza, remates y medios auxiliares, (8% s/instalación de fontanería)	Ayuda de albañilería a instalación de fontanería por vivienda incluyendo mano de obra en carga y descarga, materiales, apertura y tapado de rozas, recibidos, limpieza, remates y medios auxiliares, (8% s/instalación de fontanería)	66.400	\N	7	2004-01-01	ud	66.400
E07WA010	Ayuda albañilería a electric.	Ayuda de albañilería a instalación de electricidad por vivienda incluyendo mano de obra en carga y descarga, materiales, apertura y tapado de rozas, recibidos, limpieza, remates y medios auxiliares, (25% s/instalación de electricidad)	Ayuda de albañilería a instalación de electricidad por vivienda incluyendo mano de obra en carga y descarga, materiales, apertura y tapado de rozas, recibidos, limpieza, remates y medios auxiliares, (25% s/instalación de electricidad)	207.500	\N	7	2004-01-01	ud	207.500
E09ICX030	Teja cerámica mixta rojo viejo	Cubrición de teja cerámica mixta rojo viejo de 43x26 cm., colocadas en hiladas paralelas al alero, con solapes y recibidas con mortero de cemento CEM II/B-P 32,5 N y arena de río 1/8 (M-20), i/p.p. de piezas especiales, cumbreras, limas, tejas de ventilación y remates, medios auxiliares y elementos de seguridad, s/NTE-QTT-12, medida en verdadera magnitud.	Cubrición de teja cerámica mixta rojo viejo de 43x26 cm., colocadas en hiladas paralelas al alero, con solapes y recibidas con mortero de cemento CEM II/B-P 32,5 N y arena de río 1/8 (M-20), i/p.p. de piezas especiales, cumbreras, limas, tejas de ventilación y remates, medios auxiliares y elementos de seguridad, s/NTE-QTT-12, medida en verdadera magnitud.	19.037	\N	7	2004-01-01	m2	19.040
E09IWA030	Alero cane.hor.prefa. y rasillón	Alero formado por canecillo de hormigón prefabricado de 90x7x10 cm. en color gris, separados 50 cm. y rasillón de 50x20x4 cm., capa de compresión de 3 cm. de hormigón de 330 kg. de cemento/m3. de dosificación, enfoscado entre canecillos con mortero de cemento CEM II/B-P 32,5 N y arena de río 1/2 y emboquillado, i/medios auxiliares y elementos de seguridad, medido en su longitud.	Alero formado por canecillo de hormigón prefabricado de 90x7x10 cm. en color gris, separados 50 cm. y rasillón de 50x20x4 cm., capa de compresión de 3 cm. de hormigón de 330 kg. de cemento/m3. de dosificación, enfoscado entre canecillos con mortero de cemento CEM II/B-P 32,5 N y arena de río 1/2 y emboquillado, i/medios auxiliares y elementos de seguridad, medido en su longitud.	29.906	\N	7	2004-01-01	m.	29.910
E10ATP180	Ais.térm.cub.p.roofmate sl-a-30	Aislamiento térmico en azoteas mediante placas rígidas de poliestireno extruído tipo  Roofmate SL-A-30, de 30 mm., directamente sobre la membrana impermeabilizante, i/p.p. de corte y colocación.	Aislamiento térmico en azoteas mediante placas rígidas de poliestireno extruído tipo  Roofmate SL-A-30, de 30 mm., directamente sobre la membrana impermeabilizante, i/p.p. de corte y colocación.	10.013	\N	7	2004-01-01	m2	10.020
E10AAR009	Aisl.acúst.forjado texsilen 3 mm	Aislamiento acústico de forjado de piso, contra ruido de impacto, realizado con lámina de polietileno expandido de celda cerrada de 3 mm de espesor, tipo Texilen, colocada bajo pavimento, medida la superficie ejecutada.	Aislamiento acústico de forjado de piso, contra ruido de impacto, realizado con lámina de polietileno expandido de celda cerrada de 3 mm de espesor, tipo Texilen, colocada bajo pavimento, medida la superficie ejecutada.	3.274	\N	7	2004-01-01	m2	3.280
E10ATT070	Ais.term.techo vidrio celular 20	Aislamiento térmico de techos-cubiertas por su parte inferior realizado con placas de vidrio celular de 20 mm. de espesor o similar, colocado en posición horizontal o inclinada con 7 grapas por m2 y pasta de yeso negro, i/p.p. de corte, colocación, medios auxiliares y costes indirectos.	Aislamiento térmico de techos-cubiertas por su parte inferior realizado con placas de vidrio celular de 20 mm. de espesor o similar, colocado en posición horizontal o inclinada con 7 grapas por m2 y pasta de yeso negro, i/p.p. de corte, colocación, medios auxiliares y costes indirectos.	16.124	\N	7	2004-01-01	m2	16.130
E10AKV010	Coq.l.vid. d=21;1/2" e=30 mm.	Aislamiento térmico para tuberías en instalaciones de fontanería, calefacción e industria, para una gama de temperaturas de uso entre -30 y 250ºC, con coquilla Isover de lana de vidrio moldeada de alta densidad con formación cilíndrica y estructura concéntrica de 1200 mm. de longitud, 21 mm. de diámetro interior y 30 mm. de espesor, con apertura longitudinal para facilitar su instalación, posterior forrado con venda de escayola, reacción al fuego M0, i/p.p. de corte para formación de codos, colocación y medios auxiliares.	Aislamiento térmico para tuberías en instalaciones de fontanería, calefacción e industria, para una gama de temperaturas de uso entre -30 y 250ºC, con coquilla Isover de lana de vidrio moldeada de alta densidad con formación cilíndrica y estructura concéntrica de 1200 mm. de longitud, 21 mm. de diámetro interior y 30 mm. de espesor, con apertura longitudinal para facilitar su instalación, posterior forrado con venda de escayola, reacción al fuego M0, i/p.p. de corte para formación de codos, colocación y medios auxiliares.	3.775	\N	7	2004-01-01	m.	3.770
E10AKV060	Coq.l.vid. d=34;1" e=30mm.	Aislamiento térmico para tuberías en instalaciones de fontanería, calefacción e industria, para una gama de temperaturas de uso entre -30 y 250ºC, con coquilla Isover de lana de vidrio moldeada de alta densidad con formación cilíndrica y estructura concéntrica de 1200 mm. de longitud, 34 mm. de diámetro interior y 30 mm. de espesor, con apertura longitudinal para facilitar su instalación, posterior forrado con venda de escayola, reacción al fuego M0, i/p.p. de corte para formación de codos, colocación y medios auxiliares.	Aislamiento térmico para tuberías en instalaciones de fontanería, calefacción e industria, para una gama de temperaturas de uso entre -30 y 250ºC, con coquilla Isover de lana de vidrio moldeada de alta densidad con formación cilíndrica y estructura concéntrica de 1200 mm. de longitud, 34 mm. de diámetro interior y 30 mm. de espesor, con apertura longitudinal para facilitar su instalación, posterior forrado con venda de escayola, reacción al fuego M0, i/p.p. de corte para formación de codos, colocación y medios auxiliares.	4.704	\N	7	2004-01-01	m.	4.700
E10AKV120	Coq.l.vid. d=60;2"  e=30mm.	Aislamiento térmico para tuberías en instalaciones de fontanería, calefacción e industria, para una gama de temperaturas de uso entre -30 y 250ºC, con coquilla Isover de lana de vidrio moldeada de alta densidad con formación cilíndrica y estructura concéntrica de 1200 mm. de longitud, 60 mm. de diámetro interior y 30 mm. de espesor, con apertura longitudinal para facilitar su instalación, posterior forrado con venda de escayola, reacción al fuego M0, i/p.p. de corte para formación de codos, colocación y medios auxiliares.	Aislamiento térmico para tuberías en instalaciones de fontanería, calefacción e industria, para una gama de temperaturas de uso entre -30 y 250ºC, con coquilla Isover de lana de vidrio moldeada de alta densidad con formación cilíndrica y estructura concéntrica de 1200 mm. de longitud, 60 mm. de diámetro interior y 30 mm. de espesor, con apertura longitudinal para facilitar su instalación, posterior forrado con venda de escayola, reacción al fuego M0, i/p.p. de corte para formación de codos, colocación y medios auxiliares.	5.863	\N	7	2004-01-01	m.	5.860
E10INR090	Imp.muros betún/caucho	Impermeabilización por el exterior de muros de hormigón y estructuras a proteger posteriormente con un revestimiento impermeable monocomponente, consistente en una emulsión de betún/caucho exenta de disolventes, tipo: Emufal TE, extendida en dos capas de 1 a 1,5 kg/m2. cada una con brocha, llana dentada o "air-less", previo saneo, limpieza y humectación del soporte.	Impermeabilización por el exterior de muros de hormigón y estructuras a proteger posteriormente con un revestimiento impermeable monocomponente, consistente en una emulsión de betún/caucho exenta de disolventes, tipo: Emufal TE, extendida en dos capas de 1 a 1,5 kg/m2. cada una con brocha, llana dentada o "air-less", previo saneo, limpieza y humectación del soporte.	9.072	\N	7	2004-01-01	m2	9.070
E10INX010	Imp.encuentro c/prelastic 1000 copsa	Impermeabilización de encuentro de teja con paramento o chimenea, con un desarrollo 0,40 m. mediante revestimiento elástico Prelastic 1000 de COPSA, a base de copolímeros del éster del ácido acrílico en dos manos, aplicado a brocha, con un rendimiento de 1 kg/m.	Impermeabilización de encuentro de teja con paramento o chimenea, con un desarrollo 0,40 m. mediante revestimiento elástico Prelastic 1000 de COPSA, a base de copolímeros del éster del ácido acrílico en dos manos, aplicado a brocha, con un rendimiento de 1 kg/m.	6.319	\N	7	2004-01-01	m.	6.320
E10IAW049	Imp.perímetro lám.asf.autopro.	Impermeabilización de perímetros de cubierta, con un desarrollo de 50 cm., constituida por: imprimación asfáltica, Emufal I; banda de refuerzo en ángulos, con lámina Morterplas polimérica FP 3 kg, (tipo LBM-30-FP), totalmente adherida al soporte con soplete; lámina asfáltica Morterplas FPV 4 kg mineral gris, (tipo LBM-40/G-FP),  totalmente adherida a la anterior con soplete.	Impermeabilización de perímetros de cubierta, con un desarrollo de 50 cm., constituida por: imprimación asfáltica, Emufal I; banda de refuerzo en ángulos, con lámina Morterplas polimérica FP 3 kg, (tipo LBM-30-FP), totalmente adherida al soporte con soplete; lámina asfáltica Morterplas FPV 4 kg mineral gris, (tipo LBM-40/G-FP),  totalmente adherida a la anterior con soplete.	9.759	\N	7	2004-01-01	m.	9.770
E08PFA020	Enfoscado 1/6 cámaras	Enfoscado a buena vista sin maestrear, aplicado con llana,  con mortero de cemento CEM II/B-P 32,5 N y arena de río 1/6 (M-40) en interior de cámaras de aire de 20 mm. de espesor, i/p.p. de andamiaje, s/NTE-RPE-5, medido deduciendo huecos.	Enfoscado a buena vista sin maestrear, aplicado con llana,  con mortero de cemento CEM II/B-P 32,5 N y arena de río 1/6 (M-40) en interior de cámaras de aire de 20 mm. de espesor, i/p.p. de andamiaje, s/NTE-RPE-5, medido deduciendo huecos.	5.468	\N	7	2004-01-01	m2	5.480
E08PEM010	Guarnecido maestreado y enlucido	Guarnecido maestreado con yeso negro y enlucido con yeso blanco en paramentos verticales y horizontales de 15 mm. de espesor, con maestras cada 1,50 m. incluso formación de rincones, guarniciones de huecos, remates con pavimento, p.p. de guardavivos de plástico y metal y colocación de andamios, s/NTE-RPG, medido deduciendo huecos superiores a 2 m2.	Guarnecido maestreado con yeso negro y enlucido con yeso blanco en paramentos verticales y horizontales de 15 mm. de espesor, con maestras cada 1,50 m. incluso formación de rincones, guarniciones de huecos, remates con pavimento, p.p. de guardavivos de plástico y metal y colocación de andamios, s/NTE-RPG, medido deduciendo huecos superiores a 2 m2.	10.729	\N	7	2004-01-01	m2	10.720
E12AC101	Alic.azulejo blanco liso 20x25 cm	Alicatado con azulejo blanco liso de 20x25 cm., (BIII s/n EN 159), recibido con mortero de cemento CEM II/A-P 32,5 R y arena de miga 1/6, i/p.p. de cortes, ingletes, piezas especiales, rejuntado con lechada de cemento blanco BL-V 22,5 y limpieza, s/NTE-RPA-3, medido deduciendo huecos superiores a 1 m2.	Alicatado con azulejo blanco liso de 20x25 cm., (BIII s/n EN 159), recibido con mortero de cemento CEM II/A-P 32,5 R y arena de miga 1/6, i/p.p. de cortes, ingletes, piezas especiales, rejuntado con lechada de cemento blanco BL-V 22,5 y limpieza, s/NTE-RPA-3, medido deduciendo huecos superiores a 1 m2.	15.571	\N	7	2004-01-01	m2	15.570
E12AC180	Cenefa cerámi.relieve 5x20 cm	Alicatado con cenefa cerámica relieve en piezas de 5x20 cm., recibida con mortero de cemento CEM II/A-P 32,5 R y arena de miga 1/6, i/p.p. de cortes, ingletes, piezas especiales, rejuntado con lechada de cemento blanco BL-V 22,5 y limpieza, s/NTE-RPA-3, medido en su longitud.	Alicatado con cenefa cerámica relieve en piezas de 5x20 cm., recibida con mortero de cemento CEM II/A-P 32,5 R y arena de miga 1/6, i/p.p. de cortes, ingletes, piezas especiales, rejuntado con lechada de cemento blanco BL-V 22,5 y limpieza, s/NTE-RPA-3, medido en su longitud.	5.946	\N	7	2004-01-01	m.	5.950
E12AC220	Listelo cerámico 7x31,6 cm.	Listelo cerámico de 7x31,6 cm., recibido con mortero de cemento CEM II/A-P 32,5 R y arena de miga 1/6, i/p.p. de cortes, ingletes, piezas especiales, rejuntado con lechada de cemento blanco BL-V 22,5 y limpieza, s/NTE-RPA-3, medido en su longitud.	Listelo cerámico de 7x31,6 cm., recibido con mortero de cemento CEM II/A-P 32,5 R y arena de miga 1/6, i/p.p. de cortes, ingletes, piezas especiales, rejuntado con lechada de cemento blanco BL-V 22,5 y limpieza, s/NTE-RPA-3, medido en su longitud.	5.617	\N	7	2004-01-01	m.	5.630
E11EXB030	Solado baldosa barro 40x40 cm. c/rod	Solado de baldosa de barro cocido de 40x40 cm. manual,  (AIII, s/n EN-188) recibida con mortero de cemento CEM II/B-P 32,5 N y arena de río 1/6 (M-40), i/cama de 2 cm. de arena de río, p.p. de rodapié del mismo material de 28x8 cm.., rejuntado con lechada de cemento CEM II/B-P 32,5 N 1/2 y limpieza, s/NTE-RSR-2, medida la superficie realmente ejecutada.	Solado de baldosa de barro cocido de 40x40 cm. manual,  (AIII, s/n EN-188) recibida con mortero de cemento CEM II/B-P 32,5 N y arena de río 1/6 (M-40), i/cama de 2 cm. de arena de río, p.p. de rodapié del mismo material de 28x8 cm.., rejuntado con lechada de cemento CEM II/B-P 32,5 N 1/2 y limpieza, s/NTE-RSR-2, medida la superficie realmente ejecutada.	43.817	\N	7	2004-01-01	m2	43.830
E11EXP012	Peldaño barro decorativo 20x30	Forrado de peldaño formado por huella en piezas de barro cocido  decorativo de 30x30 cm. y tabica de 30x20 cm., recibido con mortero de cemento CEM II/B-P 32,5 N y arena de río 1/6 (M-40), i/rejuntado con lechada de cemento CEM II/B-P 32,5 N 1/2 y limpieza, s/NTE-RSR-20, medido en su longitud.	Forrado de peldaño formado por huella en piezas de barro cocido  decorativo de 30x30 cm. y tabica de 30x20 cm., recibido con mortero de cemento CEM II/B-P 32,5 N y arena de río 1/6 (M-40), i/rejuntado con lechada de cemento CEM II/B-P 32,5 N 1/2 y limpieza, s/NTE-RSR-20, medido en su longitud.	41.736	\N	7	2004-01-01	m.	41.730
E11EXP212	Rodapié barro 9x30 cm. manual	Rodapié de barro de 30x9 cm. manual, recibido con mortero de cemento CEM II/B-P 32,5 N y arena de río 1/6 (M-40), i/rejuntado con lechada de cemento CEM II/B-P 32,5 N 1/2 y limpieza s/NTE-RSR, medido en su longitud.	Rodapié de barro de 30x9 cm. manual, recibido con mortero de cemento CEM II/B-P 32,5 N y arena de río 1/6 (M-40), i/rejuntado con lechada de cemento CEM II/B-P 32,5 N 1/2 y limpieza s/NTE-RSR, medido en su longitud.	5.700	\N	7	2004-01-01	m.	5.700
E11RAM050	Parq.roble 25x5x1 esp.i/sole	Parquet de roble de 25x5x1 cm. en espiga,  categoria natural (s/n UNE 56809-2:1986), colocado con pegamento, i/solera de mortero de cemento CEM II/B-P 32,5 N y arena de río 1/2 de 5 cm. de espesor, acuchillado, lijado y tres manos de barniz de poliuretano de dos componentes P-6/8, s/NTE-RSR-12, RSR-27 y NTE-RSS, i/p.p. de recortes y rodapié del mismo material, medida la superficie ejecutada.	Parquet de roble de 25x5x1 cm. en espiga,  categoria natural (s/n UNE 56809-2:1986), colocado con pegamento, i/solera de mortero de cemento CEM II/B-P 32,5 N y arena de río 1/2 de 5 cm. de espesor, acuchillado, lijado y tres manos de barniz de poliuretano de dos componentes P-6/8, s/NTE-RSR-12, RSR-27 y NTE-RSS, i/p.p. de recortes y rodapié del mismo material, medida la superficie ejecutada.	53.855	\N	7	2004-01-01	m2	53.850
E11MB060	Solado mármol gris macael 60x30x2 cm.	Solado de mármol gris macael de  60x30x2 cm., s/n UNE 22180, recibido con mortero de cemento CEM II/B-P 32,5 N y arena de miga 1/6, cama de arena de 2 cm. de espesor, i/rejuntado con lechada de cemento blanco BL 22,5 X y limpieza, s/NTE-RSR-1, medida la superficie ejecutada.	Solado de mármol gris macael de  60x30x2 cm., s/n UNE 22180, recibido con mortero de cemento CEM II/B-P 32,5 N y arena de miga 1/6, cama de arena de 2 cm. de espesor, i/rejuntado con lechada de cemento blanco BL 22,5 X y limpieza, s/NTE-RSR-1, medida la superficie ejecutada.	36.854	\N	7	2004-01-01	m2	36.850
E11CTB020	Sol.terrazo micrograno 40x40 c/claro	Solado de terrazo 40x40 cm. micrograno, colores claros, pulido en fábrica, para uso normal s/n UNE 127020, recibido con mortero de cemento CEM II/B-P 32,5 N y arena de miga 1/6, i/cama de arena de 2 cm. de espesor, rejuntado con lechada de cemento blanco BL 22,5 X y limpieza, s/NTE-RSR-6 y NTE-RSR-26, medido en superficie realmente ejecutada.	Solado de terrazo 40x40 cm. micrograno, colores claros, pulido en fábrica, para uso normal s/n UNE 127020, recibido con mortero de cemento CEM II/B-P 32,5 N y arena de miga 1/6, i/cama de arena de 2 cm. de espesor, rejuntado con lechada de cemento blanco BL 22,5 X y limpieza, s/NTE-RSR-6 y NTE-RSR-26, medido en superficie realmente ejecutada.	21.256	\N	7	2004-01-01	m2	21.260
E13EEB050	P.e. blindada roble c/embocad.	Puerta de entrada blindada normalizada, serie alta, con tablero plafonado raíz blindado (TPRBL) de roble, barnizada, incluso precerco de pino 110x35 mm., galce o cerco visto macizo de roble 110x30 mm., embocadura exterior con rinconera de aglomerado rechapada de roble, tapajuntas lisos macizos de roble 90x15 mm. en ambas caras, bisagras de seguridad largas con rodamientos, cerradura de seguridad por tabla,3 puntos, tirador de latón pulido brillante y mirilla de latón gran angular, con plafón de latón pulido brillante, montada, incluso con p.p. de medios auxiliares.	Puerta de entrada blindada normalizada, serie alta, con tablero plafonado raíz blindado (TPRBL) de roble, barnizada, incluso precerco de pino 110x35 mm., galce o cerco visto macizo de roble 110x30 mm., embocadura exterior con rinconera de aglomerado rechapada de roble, tapajuntas lisos macizos de roble 90x15 mm. en ambas caras, bisagras de seguridad largas con rodamientos, cerradura de seguridad por tabla,3 puntos, tirador de latón pulido brillante y mirilla de latón gran angular, con plafón de latón pulido brillante, montada, incluso con p.p. de medios auxiliares.	807.322	\N	7	2004-01-01	ud	807.330
E13EPL080	P.p. lisa hueca 2/h sapelly	Puerta de paso ciega de 2 hojas normalizadas, serie económica, lisa hueca (CLH) de sapelly barnizadas, incluso precerco de pino de 70x35 mm., galce o cerco visto de DM rechapado de sapelly de 70x30 mm., tapajuntas lisos de DM rechapados de sapelly 70x10 mm. en ambas caras, y herrajes de colgar y de cierre latonados, montada, incluso p.p. de medios auxiliares.	Puerta de paso ciega de 2 hojas normalizadas, serie económica, lisa hueca (CLH) de sapelly barnizadas, incluso precerco de pino de 70x35 mm., galce o cerco visto de DM rechapado de sapelly de 70x30 mm., tapajuntas lisos de DM rechapados de sapelly 70x10 mm. en ambas caras, y herrajes de colgar y de cierre latonados, montada, incluso p.p. de medios auxiliares.	258.689	\N	7	2004-01-01	ud	258.690
E13MCL010	Fte.arm.corr.melam. cerc/dto.	Frente de armario empotrado corredero, serie económica, con hojas y maleteros lisos huecos (A/MLH) de melamina en color, con doble cerco directo de pino macizo 70x50 mm., tapajuntas exteriores moldeados de DM rechapados de pino 70x10, tapetas interiores contrachapadas de pino 70x4 mm., herrajes de colgar y deslizamiento, y tiradores de cazoleta, montado y con p.p. de medios auxiliares.	Frente de armario empotrado corredero, serie económica, con hojas y maleteros lisos huecos (A/MLH) de melamina en color, con doble cerco directo de pino macizo 70x50 mm., tapajuntas exteriores moldeados de DM rechapados de pino 70x10, tapetas interiores contrachapadas de pino 70x4 mm., herrajes de colgar y deslizamiento, y tiradores de cazoleta, montado y con p.p. de medios auxiliares.	165.289	\N	7	2004-01-01	m2	165.290
E14PV010	Cajón compacto pvc 140/150 mm	Cajón capialzado mini de PVC, realizado con paneles machihembrados de PVC, reforzados en los bordes con perfiles de PVC, compuesto por costados, fondillo, techo y tapa registrable, de 140/150 mm., montado, incluso con p.p. de medios auxiliares.	Cajón capialzado mini de PVC, realizado con paneles machihembrados de PVC, reforzados en los bordes con perfiles de PVC, compuesto por costados, fondillo, techo y tapa registrable, de 140/150 mm., montado, incluso con p.p. de medios auxiliares.	21.126	\N	7	2004-01-01	m.	21.130
E14ACP070	P.balcon.al.lc.practi. 2 hojas	Carpintería de aluminio lacado color de 60 micras, en puertas balconeras practicables de 2 hojas para acristalar, mayores de 2 m2. y menores de 4 m2. de superficie total, compuesta por cerco, hojas con zócalo inferior ciego de 30 cm., y herrajes de colgar y de seguridad, instalada sobre precerco de aluminio, sellado de juntas y limpieza, incluso con p.p. de medios auxiliares. s/NTE-FCL-16.	Carpintería de aluminio lacado color de 60 micras, en puertas balconeras practicables de 2 hojas para acristalar, mayores de 2 m2. y menores de 4 m2. de superficie total, compuesta por cerco, hojas con zócalo inferior ciego de 30 cm., y herrajes de colgar y de seguridad, instalada sobre precerco de aluminio, sellado de juntas y limpieza, incluso con p.p. de medios auxiliares. s/NTE-FCL-16.	102.177	\N	7	2004-01-01	m2	102.180
E14ACV050	Vent.al.lc. practicables 2 hojas	Carpintería de aluminio lacado color de 60 micras, en ventanas practicables de 2 hojas , mayores de 1 m2 y menores de 2 m2 de superficie total, compuesta por cerco, hojas y herrajes de colgar y de seguridad, instalada sobre precerco de aluminio, sellado de juntas y limpieza, incluso con p.p. de medios auxiliares. s/ NTE-FCL-3.	Carpintería de aluminio lacado color de 60 micras, en ventanas practicables de 2 hojas , mayores de 1 m2 y menores de 2 m2 de superficie total, compuesta por cerco, hojas y herrajes de colgar y de seguridad, instalada sobre precerco de aluminio, sellado de juntas y limpieza, incluso con p.p. de medios auxiliares. s/ NTE-FCL-3.	143.313	\N	7	2004-01-01	m2	143.310
E15CCH020	Precerco tubo acero	Precerco para posterior fijación en obra de carpintería pre-esmaltada, carpintería de PVC, Carpintería de aluminio, etc., formado con tubo hueco de acero laminado en frío Perfrisa o similar de 50x50x2 mm. galvanizado doble agrafado, i/corte, preparación y soldadura de perfiles en taller, ajuste y montaje en obra, con garras de sujeción para recibir en fábricas (sin incluir recibido de albañilería).	Precerco para posterior fijación en obra de carpintería pre-esmaltada, carpintería de PVC, Carpintería de aluminio, etc., formado con tubo hueco de acero laminado en frío Perfrisa o similar de 50x50x2 mm. galvanizado doble agrafado, i/corte, preparación y soldadura de perfiles en taller, ajuste y montaje en obra, con garras de sujeción para recibir en fábricas (sin incluir recibido de albañilería).	26.280	\N	7	2004-01-01	m2	26.280
E15WC020	Caperuza met. chimenea 60x60	Caperuza metálica para remate de chimenea de medidas exteriores 60x60 cm. elaborada en taller, formada por seis recercados con tubo hueco de acero laminado en frío de 50x20x1,5 mm., patillas de sujeción y recibido de tubo de 30x30x1,5 mm. en esquinas, con chapa metálica negra de 1,5 mm. de espesor soldada a parte superior i/pintura tipo ferro recibido de albañilería y montaje en obra.	Caperuza metálica para remate de chimenea de medidas exteriores 60x60 cm. elaborada en taller, formada por seis recercados con tubo hueco de acero laminado en frío de 50x20x1,5 mm., patillas de sujeción y recibido de tubo de 30x30x1,5 mm. en esquinas, con chapa metálica negra de 1,5 mm. de espesor soldada a parte superior i/pintura tipo ferro recibido de albañilería y montaje en obra.	94.619	\N	7	2004-01-01	ud	94.610
E14ACD020	Barand.escal.barrotes alumin.lc.	Barandilla de escalera de perfiles de aluminio lacado color de 60 micras, de 90 cm. de altura total, compuesta por tubos verticales cada 10 cm. entre ejes, pasamanos inferior y superior, montantes, topes y accesorios, instalada y anclada a obra cada 70 cm., incluso con p.p. de medios auxiliares y pequeño material para su recibido, terminada.	Barandilla de escalera de perfiles de aluminio lacado color de 60 micras, de 90 cm. de altura total, compuesta por tubos verticales cada 10 cm. entre ejes, pasamanos inferior y superior, montantes, topes y accesorios, instalada y anclada a obra cada 70 cm., incluso con p.p. de medios auxiliares y pequeño material para su recibido, terminada.	149.409	\N	7	2004-01-01	m.	149.410
E15DBA060	Barandilla tubo 90cm.tubo vert.20x20x1	Barandilla de 90 cm. de altura, construida con tubos huecos de acero laminado en frío, con pasamanos superior de 100x40x2 mm., inferior de 80x40x2 mm. dispuestos horizontalmente y montantes verticales de tubo de 20x20x1 mm. colocados cada 12 cm., soldados entre sí, i/patillas de anclaje cada metro, elaborada en taller y montaje en obra (sin incluir recibido de albañilería). Tipo Tazasa-1 o similar.	Barandilla de 90 cm. de altura, construida con tubos huecos de acero laminado en frío, con pasamanos superior de 100x40x2 mm., inferior de 80x40x2 mm. dispuestos horizontalmente y montantes verticales de tubo de 20x20x1 mm. colocados cada 12 cm., soldados entre sí, i/patillas de anclaje cada metro, elaborada en taller y montaje en obra (sin incluir recibido de albañilería). Tipo Tazasa-1 o similar.	41.601	\N	7	2004-01-01	m.	41.600
E15DRA020	Reja tubo acero 20x20x1,5 mm.d.artistico	Reja metálica realizada con tubos de acero laminado en frío de 20x20x1,5 mm., colocados verticalmente cada 12 cm. sobre dos tubos horizontales de 30x30x1,5 mm. separados 1 metro como máximo con adornos intermedios de redondo de 8 mm. y garras para recibido a obra, elaborada en taller y montaje en obra. (sin incluir recibido de albañilería).	Reja metálica realizada con tubos de acero laminado en frío de 20x20x1,5 mm., colocados verticalmente cada 12 cm. sobre dos tubos horizontales de 30x30x1,5 mm. separados 1 metro como máximo con adornos intermedios de redondo de 8 mm. y garras para recibido a obra, elaborada en taller y montaje en obra. (sin incluir recibido de albañilería).	82.601	\N	7	2004-01-01	m2	82.600
E16ECA030	D. acristalamiento 4/12/4	Doble acristalamiento tipo Isolar Glas, conjunto formado por dos lunas float incoloras de 4 mm y cámara de aire deshidratado de 12 o 16 mm con perfil separador de aluminio y doble sellado perimetral , fijación sobre carpintería con acuñado mediante calzos de apoyo perimetrales y laterales y sellado en frío con silicona Wacker Elastosil 400, incluso cortes de vidrio y colocación de junquillos, según NTE-FVP-8	Doble acristalamiento tipo Isolar Glas, conjunto formado por dos lunas float incoloras de 4 mm y cámara de aire deshidratado de 12 o 16 mm con perfil separador de aluminio y doble sellado perimetral , fijación sobre carpintería con acuñado mediante calzos de apoyo perimetrales y laterales y sellado en frío con silicona Wacker Elastosil 400, incluso cortes de vidrio y colocación de junquillos, según NTE-FVP-8	27.808	\N	7	2004-01-01	m2	27.820
E16ECA110	D. acristalamiento 6/12/6	Doble acristalamiento tipo Isolar Glas, conjunto formado por dos lunas float incoloras de 6 mm y cámara de aire deshidratado de 12 o 16 mm con perfil separador de aluminio y doble sellado perimetral, fijación sobre carpintería con acuñado mediante calzos de apoyo perimetrales y laterales y sellado en frío con silicona Wacker Elastosil 400, incluso cortes de vidrio y colocación de junquillos, según NTE-FVP-8	Doble acristalamiento tipo Isolar Glas, conjunto formado por dos lunas float incoloras de 6 mm y cámara de aire deshidratado de 12 o 16 mm con perfil separador de aluminio y doble sellado perimetral, fijación sobre carpintería con acuñado mediante calzos de apoyo perimetrales y laterales y sellado en frío con silicona Wacker Elastosil 400, incluso cortes de vidrio y colocación de junquillos, según NTE-FVP-8	38.350	\N	7	2004-01-01	m2	38.360
E16AMA010	Vidrio impreso incol. 6/7 mm	Acristalamiento con vidrio translúcido e incoloro impreso de 6/7 mm de espesor, fijación sobre carpintería con acuñado mediante calzos de apoyo perimetrales y laterales y sellado en frío con silicona incolora tipo Wacker Elastosil 400, incluso cortes de vidrio y colocación de junquillos, según NTE-FVP.	Acristalamiento con vidrio translúcido e incoloro impreso de 6/7 mm de espesor, fijación sobre carpintería con acuñado mediante calzos de apoyo perimetrales y laterales y sellado en frío con silicona incolora tipo Wacker Elastosil 400, incluso cortes de vidrio y colocación de junquillos, según NTE-FVP.	34.009	\N	7	2004-01-01	m2	34.020
E27MB030	Barni.madera int.brillant.2 man.	Barnizado de carpintería de madera interior o exterior con dos manos de barniz sintético brillante.	Barnizado de carpintería de madera interior o exterior con dos manos de barniz sintético brillante.	8.386	\N	7	2004-01-01	m2	8.390
E27HS030	Pintura tipo ferro	Pintura tipo ferro sobre soporte metálico dos manos y una mano de minio electrolítico, i/raspados de óxidos y limpieza manual.	Pintura tipo ferro sobre soporte metálico dos manos y una mano de minio electrolítico, i/raspados de óxidos y limpieza manual.	14.168	\N	7	2004-01-01	m2	14.160
E27EPA020	Pint.plás.lisa mate estánd. obra b/color	Pintura plástica lisa mate lavable standard obra nueva en blanco o pigmentada, sobre paramentos horizontales y verticales, dos manos, incluso mano de imprimación y plastecido.	Pintura plástica lisa mate lavable standard obra nueva en blanco o pigmentada, sobre paramentos horizontales y verticales, dos manos, incluso mano de imprimación y plastecido.	5.684	\N	7	2004-01-01	m2	5.690
E27HET020	P.esmalte s/tubo des.10 a 20 cm.	Pintura al esmalte sobre tubos, i/limpieza y capa antioxidante con un desarrollo entre 10 y 20 cm., s/normas DIN.	Pintura al esmalte sobre tubos, i/limpieza y capa antioxidante con un desarrollo entre 10 y 20 cm., s/normas DIN.	1.740	\N	7	2004-01-01	m.	1.740
E17MSC010	P.luz sencillo simón 75	Punto de luz sencillo realizado con tubo PVC corrugado de M 20/gp5 y conductor rígido de 1,5 mm2 de Cu., y aislamiento VV 750 V., incluyendo caja de registro, caja de mecanismo universal con tornillos, interruptor unipolar Simón serie 75, instalado.	Punto de luz sencillo realizado con tubo PVC corrugado de M 20/gp5 y conductor rígido de 1,5 mm2 de Cu., y aislamiento VV 750 V., incluyendo caja de registro, caja de mecanismo universal con tornillos, interruptor unipolar Simón serie 75, instalado.	23.092	\N	7	2004-01-01	ud	23.090
E17MSC020	P.luz conm. simón 75	Punto conmutado sencillo realizado con tubo PVC corrugado de M 20/gp5 y conductor rígido de 1,5 mm2 de Cu, y aislamiento VV 750 V., incluyendo caja de registro, cajas de mecanismo universal con tornillos, conmutadores Simón serie 75, instalado.	Punto conmutado sencillo realizado con tubo PVC corrugado de M 20/gp5 y conductor rígido de 1,5 mm2 de Cu, y aislamiento VV 750 V., incluyendo caja de registro, cajas de mecanismo universal con tornillos, conmutadores Simón serie 75, instalado.	38.475	\N	7	2004-01-01	ud	38.480
E17MSC050	P.doble conm. simón 75	Punto doble conmutador realizado con tubo PVC corrugado de D=20/gp 5, conductor rígido de 1,5 mm2 de Cu., y aislamiento VV 750 V., incluyendo caja de registro, cajas de mecanismo universal con tornillos, dobles conmutadores Simón serie 75, instalado.	Punto doble conmutador realizado con tubo PVC corrugado de D=20/gp 5, conductor rígido de 1,5 mm2 de Cu., y aislamiento VV 750 V., incluyendo caja de registro, cajas de mecanismo universal con tornillos, dobles conmutadores Simón serie 75, instalado.	65.481	\N	7	2004-01-01	ud	65.480
E17MSC060	P.pulsa.timbre simón 75	Punto pulsador timbre realizado con tubo PVC corrugado de M 20/gp5 y conductor rígido de 1,5 mm2 de Cu., y aislamiento VV 750 V., incluyendo caja de registro, cajas de mecanismo universal con tornillos, pulsador con marco Simón serie 75 y zumbador, instalado.	Punto pulsador timbre realizado con tubo PVC corrugado de M 20/gp5 y conductor rígido de 1,5 mm2 de Cu., y aislamiento VV 750 V., incluyendo caja de registro, cajas de mecanismo universal con tornillos, pulsador con marco Simón serie 75 y zumbador, instalado.	35.072	\N	7	2004-01-01	ud	35.070
E17MSB090	B.ench.schuko simón 31	Base de enchufe con toma de tierra lateral realizada con tubo PVC corrugado de M 20/gp5 y conductor rígido de 2,5 mm2 de Cu., y aislamiento VV 750 V., en sistema monofásico con toma de tierra (fase, neutro y tierra), incluyendo caja de registro, caja de mecanismo universal con tornillos, base de enchufe sistema schuko 10-16 A. (II+t.) Simón serie 31, instalada.	Base de enchufe con toma de tierra lateral realizada con tubo PVC corrugado de M 20/gp5 y conductor rígido de 2,5 mm2 de Cu., y aislamiento VV 750 V., en sistema monofásico con toma de tierra (fase, neutro y tierra), incluyendo caja de registro, caja de mecanismo universal con tornillos, base de enchufe sistema schuko 10-16 A. (II+t.) Simón serie 31, instalada.	25.574	\N	7	2004-01-01	ud	25.570
E18IRA030	Regleta de superficie 1x36 w.af	Regleta de superficie de 1x36 W. con protección IP20 clase I, cuerpo de chapa de acero de 0,7 mm., pintado con pintura epoxi poliéster y secado al horno, sistema de anclaje formado por chapa galvanizada sujeta con tornillos incorporados, equipo eléctrico formado por reactancia, condensador, portalámparas, cebador, lampara fluorescente nueva generación y bornes de conexión. Instalado, incluyendo replanteo, accesorios de anclaje y conexionado.	Regleta de superficie de 1x36 W. con protección IP20 clase I, cuerpo de chapa de acero de 0,7 mm., pintado con pintura epoxi poliéster y secado al horno, sistema de anclaje formado por chapa galvanizada sujeta con tornillos incorporados, equipo eléctrico formado por reactancia, condensador, portalámparas, cebador, lampara fluorescente nueva generación y bornes de conexión. Instalado, incluyendo replanteo, accesorios de anclaje y conexionado.	19.949	\N	7	2004-01-01	ud	19.950
E18IMA010	Lum.empot.dif.prismático 2x18 w.af	Luminaria de empotrar, de 2x18 W. con difusor en metacrilato prismático transparente,  con protección IP20 clase I, cuerpo de chapa de acero galvanizado esmaltada en blanco, equipo eléctrico formado por reactancias, condensadores, portalámparas, cebadores, lámparas fluorescentes nueva generación y bornes de conexión. Instalada, incluyendo replanteo, accesorios de anclaje y conexionado.	Luminaria de empotrar, de 2x18 W. con difusor en metacrilato prismático transparente,  con protección IP20 clase I, cuerpo de chapa de acero galvanizado esmaltada en blanco, equipo eléctrico formado por reactancias, condensadores, portalámparas, cebadores, lámparas fluorescentes nueva generación y bornes de conexión. Instalada, incluyendo replanteo, accesorios de anclaje y conexionado.	72.942	\N	7	2004-01-01	ud	72.940
E18IDE010	Aro empotr.halógena dicro.50w/12v	Aro para empotrar con lámpara halógena dicroica de 50 W./12 V. y transformador, con protección IP20 clase III. En cuerpo de aleación de aluminio (Zamac) en color blanco, dorado, cromado, negro o gris. Instalado incluyendo replanteo y conexionado.	Aro para empotrar con lámpara halógena dicroica de 50 W./12 V. y transformador, con protección IP20 clase III. En cuerpo de aleación de aluminio (Zamac) en color blanco, dorado, cromado, negro o gris. Instalado incluyendo replanteo y conexionado.	26.210	\N	7	2004-01-01	ud	26.210
E18IDA120	Plafón estanco oval con visera 2x9 w.	Plafón con visera para montaje en pared de aluminio lacado y vidrio templado esmerilado y estirado en la parte interior, rejilla metálica y junta de estanqueidad, con 2 lámparas fluorescentes compactas de 9 W. G23. Grado de protección IP54 clase I. Con lámparas y equipos eléctricos. Instalado, incluyendo replanteo, accesorios de anclaje y conexionado.	Plafón con visera para montaje en pared de aluminio lacado y vidrio templado esmerilado y estirado en la parte interior, rejilla metálica y junta de estanqueidad, con 2 lámparas fluorescentes compactas de 9 W. G23. Grado de protección IP54 clase I. Con lámparas y equipos eléctricos. Instalado, incluyendo replanteo, accesorios de anclaje y conexionado.	55.570	\N	7	2004-01-01	ud	55.570
E17BCM010	Módulo un contador monofásico	Módulo para un contador monofásico, montaje en el exterior, de vivienda unifamiliar, homologado por la compañía suministradora, instalado, incluyendo cableado y elementos de protección. (Contador de la compañía).	Módulo para un contador monofásico, montaje en el exterior, de vivienda unifamiliar, homologado por la compañía suministradora, instalado, incluyendo cableado y elementos de protección. (Contador de la compañía).	81.020	\N	7	2004-01-01	ud	81.020
E17CBL020	Cuadro protec.electrific. elevada 9 c.	Cuadro protección electrificación elevada, formado por caja, de doble aislamiento de empotrar, con puerta de 26 elementos, perfil omega, embarrado de protección, interruptor de control de potencia, interruptor general magnetotérmico de corte omnipolar 40 A, interruptor diferencial 2x40 A 30 mA y PIAS (I+N) de 10, 16, 20 y 25 A., con circuitos adicionales para calefacción, aire acondicionado, secadora y gestión de usuarios.  Instalado, incluyendo cableado y conexionado.	Cuadro protección electrificación elevada, formado por caja, de doble aislamiento de empotrar, con puerta de 26 elementos, perfil omega, embarrado de protección, interruptor de control de potencia, interruptor general magnetotérmico de corte omnipolar 40 A, interruptor diferencial 2x40 A 30 mA y PIAS (I+N) de 10, 16, 20 y 25 A., con circuitos adicionales para calefacción, aire acondicionado, secadora y gestión de usuarios.  Instalado, incluyendo cableado y conexionado.	295.740	\N	7	2004-01-01	ud	295.740
E17CC010	Circuito monof. potencia 10 a.	Circuito iluminación realizado con tubo PVC corrugado M 20/gp5, conductores de cobre rígido de 1,5 mm2, aislamiento VV 750 V., en sistema monofásico (fase y neutro), incluido p./p. de cajas de registro y regletas de conexión.	Circuito iluminación realizado con tubo PVC corrugado M 20/gp5, conductores de cobre rígido de 1,5 mm2, aislamiento VV 750 V., en sistema monofásico (fase y neutro), incluido p./p. de cajas de registro y regletas de conexión.	5.495	\N	7	2004-01-01	m.	5.490
E17CC020	Circuito monof. potencia 15 a.	Circuito para tomas de uso general, realizado con tubo PVC corrugado M 25/gp5, conductores de cobre rígido de 2,5 mm2, aislamiento VV 750 V., en sistema monofásico (fase neutro y tierra), incluido p./p. de cajas de registro y regletas de conexión.	Circuito para tomas de uso general, realizado con tubo PVC corrugado M 25/gp5, conductores de cobre rígido de 2,5 mm2, aislamiento VV 750 V., en sistema monofásico (fase neutro y tierra), incluido p./p. de cajas de registro y regletas de conexión.	5.915	\N	7	2004-01-01	m.	5.910
E17CC030	Circuito monof. potencia 20 a.	Circuito lavadora, lavavajillas o termo eléctrico, realizado con tubo PVC corrugado M 25/gp5, conductores de cobre rígido de 4 mm2, aislamiento VV 750 V., en sistema monofásico (fase neutro y tierra), incluido p./p. de cajas de registro y regletas de conexión.	Circuito lavadora, lavavajillas o termo eléctrico, realizado con tubo PVC corrugado M 25/gp5, conductores de cobre rígido de 4 mm2, aislamiento VV 750 V., en sistema monofásico (fase neutro y tierra), incluido p./p. de cajas de registro y regletas de conexión.	7.756	\N	7	2004-01-01	m.	7.760
E17BAP010	Caja general protección 80a.	Caja general protección 80 A. incluido bases cortacircuitos y fusibles calibrados de 80 A. para protección de la línea repartidora, situada en fachada o interior nicho mural.	Caja general protección 80 A. incluido bases cortacircuitos y fusibles calibrados de 80 A. para protección de la línea repartidora, situada en fachada o interior nicho mural.	57.685	\N	7	2004-01-01	ud	57.690
E17BB005	Lín.repartidora emp. 3,5x10 mm2	Línea repartidora, formada por cable de cobre de 3,5x10 mm2, con aislamiento de 0,6 /1 kV, en montaje empotrado bajo tubo de PVC corrugado forrado, grado de protección 7, M-32. Instalación, incluyendo conexionado.	Línea repartidora, formada por cable de cobre de 3,5x10 mm2, con aislamiento de 0,6 /1 kV, en montaje empotrado bajo tubo de PVC corrugado forrado, grado de protección 7, M-32. Instalación, incluyendo conexionado.	9.006	\N	7	2004-01-01	m.	9.010
E17CI010	Derivación individual 3x6 mm2	Derivación individual 3x6 mm2. (línea que enlaza el contador o contadores de cada abonado con su dispositivo privado de mando y protección), bajo tubo de PVC rígido D=29, M 40/gp5, conductores de cobre de 6 mm2. y aislamiento tipo VV 750 V. libre de alógenos en sistema monofásico, más conductor de protección y conductor de conmutación para doble tarifa de Cu 1,5 mm2 y color rojo. Instalada en canaladura a lo largo del hueco de escalera, incluyendo elementos de fijación y conexionado.	Derivación individual 3x6 mm2. (línea que enlaza el contador o contadores de cada abonado con su dispositivo privado de mando y protección), bajo tubo de PVC rígido D=29, M 40/gp5, conductores de cobre de 6 mm2. y aislamiento tipo VV 750 V. libre de alógenos en sistema monofásico, más conductor de protección y conductor de conmutación para doble tarifa de Cu 1,5 mm2 y color rojo. Instalada en canaladura a lo largo del hueco de escalera, incluyendo elementos de fijación y conexionado.	9.848	\N	7	2004-01-01	m.	9.850
E17BD020	Toma de tierra indep. con pica	Toma de tierra independiente con pica de acero cobrizado de D= 14,3 mm. y 2 m. de longitud, cable de cobre de 35 mm2, unido mediante soldadura aluminotérmica, incluyendo registro de comprobación y puente de prueba.	Toma de tierra independiente con pica de acero cobrizado de D= 14,3 mm. y 2 m. de longitud, cable de cobre de 35 mm2, unido mediante soldadura aluminotérmica, incluyendo registro de comprobación y puente de prueba.	84.660	\N	7	2004-01-01	ud	84.660
E03EUF020	Sum.sif.fund.c/rej.fund.200x200 40mm	Sumidero sifónico de fundición de 200x200 mm. con rejilla circular de fundición y con salida vertical u horizontal de 40 mm.; para recogida de aguas pluviales o de locales húmedos, instalado y conexionado a la red general de desagüe, incluso con p.p. de pequeño material de agarre y medios auxiliares, y sin incluir arqueta de apoyo.	Sumidero sifónico de fundición de 200x200 mm. con rejilla circular de fundición y con salida vertical u horizontal de 40 mm.; para recogida de aguas pluviales o de locales húmedos, instalado y conexionado a la red general de desagüe, incluso con p.p. de pequeño material de agarre y medios auxiliares, y sin incluir arqueta de apoyo.	11.893	\N	7	2004-01-01	ud	11.890
E20WNA050	Canalón aluminio cuad.des. 400mm.	Canalón visto de chapa de aluminio lacado de 0,68 mm. de espesor, de sección cuadrada, con un desarrollo de 400 mm.,  fijado al alero mediante soportes lacados colocados cada 50 cm. y totalmente equipado, incluso con p.p. de piezas especiales y remates finales de aluminio prelacado, soldaduras  y piezas de conexión a bajantes, completamente instalado.	Canalón visto de chapa de aluminio lacado de 0,68 mm. de espesor, de sección cuadrada, con un desarrollo de 400 mm.,  fijado al alero mediante soportes lacados colocados cada 50 cm. y totalmente equipado, incluso con p.p. de piezas especiales y remates finales de aluminio prelacado, soldaduras  y piezas de conexión a bajantes, completamente instalado.	22.751	\N	7	2004-01-01	m.	22.750
E21ABC010	Bañ.acero 170x75 col.g.mmdo.	Bañera de chapa de acero esmaltado, de 170x75 cm., en color, con fondo antideslizante insonorizado y asas doradas, con grifería mezcladora exterior monomando, con inversor baño-ducha, ducha teléfono, flexible de 170 cm. y soporte articulado en color mod. Ergos de RamonSoler, incluso desagüe con rebosadero, de salida horizontal, de 40 mm., instalada y funcionando.	Bañera de chapa de acero esmaltado, de 170x75 cm., en color, con fondo antideslizante insonorizado y asas doradas, con grifería mezcladora exterior monomando, con inversor baño-ducha, ducha teléfono, flexible de 170 cm. y soporte articulado en color mod. Ergos de RamonSoler, incluso desagüe con rebosadero, de salida horizontal, de 40 mm., instalada y funcionando.	336.470	\N	7	2004-01-01	ud	336.470
E21ABC060	Bañ.acero 140x70 col.n.europa	Bañera de chapa de acero esmaltado, de 140x70 cm., en color con fondo antideslizante, mod. Nueva Europa de Metalibérica, con grifería mezcladora exterior monomando mod. Aquanova plus de RamonSoler, con inversor baño-ducha, ducha teléfono, flexible de 170 cm. y soporte articulado, incluso desagüe con rebosadero, de salida horizontal, de 40 mm., instalada y funcionando.	Bañera de chapa de acero esmaltado, de 140x70 cm., en color con fondo antideslizante, mod. Nueva Europa de Metalibérica, con grifería mezcladora exterior monomando mod. Aquanova plus de RamonSoler, con inversor baño-ducha, ducha teléfono, flexible de 170 cm. y soporte articulado, incluso desagüe con rebosadero, de salida horizontal, de 40 mm., instalada y funcionando.	160.010	\N	7	2004-01-01	ud	160.010
E21ADP020	P.ducha porc.70x70 bla.	Plato de ducha de porcelana, de 70x70 cm.mod. Odeon de Jacob Delafon, en blanco, con grifería mezcladora exterior monomando, con ducha teléfono, flexible de 150 cm. y soporte articulado, incluso válvula de desagüe sifónica, con salida horizontal de 60 mm., instalado y funcionando.	Plato de ducha de porcelana, de 70x70 cm.mod. Odeon de Jacob Delafon, en blanco, con grifería mezcladora exterior monomando, con ducha teléfono, flexible de 150 cm. y soporte articulado, incluso válvula de desagüe sifónica, con salida horizontal de 60 mm., instalado y funcionando.	155.628	\N	7	2004-01-01	ud	155.630
E21ALA060	Lav.70x56 c/ped. s.media bla.	Lavabo de porcelana vitrificada en blanco de 70x56 cm. colocado con pedestal y con anclajes a la pared, con grifería monomando, con rompechorros y enlaces de alimentación flexibles, incluso válvula de desagüe de 32 mm., llaves de escuadra de 1/2" cromadas, y latiguillos flexibles de 20 cm. y de 1/2", instalado y funcionando.	Lavabo de porcelana vitrificada en blanco de 70x56 cm. colocado con pedestal y con anclajes a la pared, con grifería monomando, con rompechorros y enlaces de alimentación flexibles, incluso válvula de desagüe de 32 mm., llaves de escuadra de 1/2" cromadas, y latiguillos flexibles de 20 cm. y de 1/2", instalado y funcionando.	178.641	\N	7	2004-01-01	ud	178.640
E21ALA050	Lav.70x56 c/ped. s.media col.	Lavabo de porcelana vitrificada en color de 70x56 cm. colocado con pedestal y con anclajes a la pared, con grifería monomando, con rompechorros y enlaces de alimentación flexibles, incluso válvula de desagüe de 32 mm., llaves de escuadra de 1/2" cromadas, y latiguillos flexibles de 20 cm. y de 1/2", instalado y funcionando.	Lavabo de porcelana vitrificada en color de 70x56 cm. colocado con pedestal y con anclajes a la pared, con grifería monomando, con rompechorros y enlaces de alimentación flexibles, incluso válvula de desagüe de 32 mm., llaves de escuadra de 1/2" cromadas, y latiguillos flexibles de 20 cm. y de 1/2", instalado y funcionando.	214.941	\N	7	2004-01-01	ud	214.940
E21ANB010	Inod.t.bajo compl. s.normal col.	Inodoro de porcelana vitrificada en color, de tanque bajo serie normal, colocado mediante tacos y tornillos al solado, incluso sellado con silicona y compuesto por: taza, tanque bajo con tapa y mecanismos y asiento con tapa lacados, con bisagras de acero, instalado, incluso con llave de escuadra de 1/2" cromada y latiguillo flexible de 20 cm. y de 1/2", funcionando.	Inodoro de porcelana vitrificada en color, de tanque bajo serie normal, colocado mediante tacos y tornillos al solado, incluso sellado con silicona y compuesto por: taza, tanque bajo con tapa y mecanismos y asiento con tapa lacados, con bisagras de acero, instalado, incluso con llave de escuadra de 1/2" cromada y latiguillo flexible de 20 cm. y de 1/2", funcionando.	183.553	\N	7	2004-01-01	ud	183.550
E21FA090	Freg.rec.80x50 2 senos g.mmdo.	Fregadero de acero inoxidable, de 80x50 cm., de 2 senos, para colocar sobre bancada o mueble soporte (sin incluir), con grifería mezcladora monomando mod. Monotech plus de RamonSoler, con caño giratorio y aireador, incluso válvulas de desagüe de 40 mm., llaves de escuadra de 1/2" cromadas, y latiguillos flexibles de 20 cm. y de 1/2", instalado y funcionando.	Fregadero de acero inoxidable, de 80x50 cm., de 2 senos, para colocar sobre bancada o mueble soporte (sin incluir), con grifería mezcladora monomando mod. Monotech plus de RamonSoler, con caño giratorio y aireador, incluso válvulas de desagüe de 40 mm., llaves de escuadra de 1/2" cromadas, y latiguillos flexibles de 20 cm. y de 1/2", instalado y funcionando.	174.252	\N	7	2004-01-01	ud	174.250
E21MA020	Conj.accesorios porc. p/empotr.	Suministro y colocación de conjunto de accesorios de baño, en porcelana blanca, colocados empotrados como el alicatado, compuesto por: 1 toallero, 1 jabonera-esponjera, 1 portarrollos, 1 percha y 1 repisa; montados y limpios.	Suministro y colocación de conjunto de accesorios de baño, en porcelana blanca, colocados empotrados como el alicatado, compuesto por: 1 toallero, 1 jabonera-esponjera, 1 portarrollos, 1 percha y 1 repisa; montados y limpios.	119.760	\N	7	2004-01-01	ud	119.760
E20VF020	Llave de esfera latón 1/2" 15mm	Suministro y colocación de llave de corte por esfera, de  1/2" (15 mm.) de diámetro, de latón cromado PN-25, colocada mediante unión roscada, totalmente equipada, instalada y funcionando.	Suministro y colocación de llave de corte por esfera, de  1/2" (15 mm.) de diámetro, de latón cromado PN-25, colocada mediante unión roscada, totalmente equipada, instalada y funcionando.	5.732	\N	7	2004-01-01	ud	5.730
E20VF030	Llave de esfera latón 3/4" 20mm	Suministro y colocación de llave de corte por esfera, de 3/4" (20 mm.) de diámetro, de latón cromado PN-25, colocada mediante unión roscada, totalmente equipada, instalada y funcionando.	Suministro y colocación de llave de corte por esfera, de 3/4" (20 mm.) de diámetro, de latón cromado PN-25, colocada mediante unión roscada, totalmente equipada, instalada y funcionando.	6.482	\N	7	2004-01-01	ud	6.480
E20VF040	Llave de esfera latón 1" 25mm	Suministro y colocación de llave de corte por esfera, de 1" (25 mm.) de diámetro, de latón cromado PN-25, colocada mediante unión roscada, totalmente equipada, instalada y funcionando.	Suministro y colocación de llave de corte por esfera, de 1" (25 mm.) de diámetro, de latón cromado PN-25, colocada mediante unión roscada, totalmente equipada, instalada y funcionando.	7.262	\N	7	2004-01-01	ud	7.260
E20WJF010	Bajante pvc serie b j.peg. 90 mm.	Bajante de PVC serie B junta pegada, de 90 mm. de diámetro, con sistema de unión por enchufe con junta pegada (EN1453), colocada con abrazaderas metálicas, instalada, incluso con p.p. de piezas especiales de PVC, funcionando.	Bajante de PVC serie B junta pegada, de 90 mm. de diámetro, con sistema de unión por enchufe con junta pegada (EN1453), colocada con abrazaderas metálicas, instalada, incluso con p.p. de piezas especiales de PVC, funcionando.	7.799	\N	7	2004-01-01	m.	7.800
E20WJF020	Bajante pvc serie b j.peg. 110 mm.	Bajante de PVC serie B junta pegada, de 110 mm. de diámetro, con sistema de unión por enchufe con junta pegada (EN1453), colocada con abrazaderas metálicas, instalada, incluso con p.p. de piezas especiales de PVC, funcionando.	Bajante de PVC serie B junta pegada, de 110 mm. de diámetro, con sistema de unión por enchufe con junta pegada (EN1453), colocada con abrazaderas metálicas, instalada, incluso con p.p. de piezas especiales de PVC, funcionando.	9.009	\N	7	2004-01-01	m.	9.010
E20XVC040	Inst.viv.c/cocina+2 baños+aseo	Instalación de fontanería completa, para vivienda compuesta de cocina, dos baños completos y aseo con ducha, con tuberías de cobre para las redes de agua, y con tuberías de PVC serie B, para las redes de desagüe, terminada, sin aparatos sanitarios, y con p.p. de redes interiores de ascendentes y bajantes.	Instalación de fontanería completa, para vivienda compuesta de cocina, dos baños completos y aseo con ducha, con tuberías de cobre para las redes de agua, y con tuberías de PVC serie B, para las redes de desagüe, terminada, sin aparatos sanitarios, y con p.p. de redes interiores de ascendentes y bajantes.	910.549	\N	7	2004-01-01	ud	910.860
E20TC020	Tubería de cobre de 13/15 mm.	Tubería de cobre recocido, de 13/15 mm. de diámetro nominal, en instalaciones interiores de viviendas y locales comerciales, para agua fría y caliente, con p.p. de piezas especiales de cobre, instalada y funcionando, según normativa vigente, en ramales de longitud inferior a 3 metros, incluso con protección de tubo corrugado de PVC.	Tubería de cobre recocido, de 13/15 mm. de diámetro nominal, en instalaciones interiores de viviendas y locales comerciales, para agua fría y caliente, con p.p. de piezas especiales de cobre, instalada y funcionando, según normativa vigente, en ramales de longitud inferior a 3 metros, incluso con protección de tubo corrugado de PVC.	5.293	\N	7	2004-01-01	m.	5.300
E20TC010	Tubería de cobre de 10/12 mm.	Tubería de cobre recocido, de 10/12 mm. de diámetro nominal, en instalaciones interiores de viviendas y locales comerciales, para agua fría y caliente, con p.p. de piezas especiales de cobre, instalada y funcionando, según normativa vigente, en ramales de longitud inferior a 3 metros, incluso con protección de tubo corrugado de PVC.	Tubería de cobre recocido, de 10/12 mm. de diámetro nominal, en instalaciones interiores de viviendas y locales comerciales, para agua fría y caliente, con p.p. de piezas especiales de cobre, instalada y funcionando, según normativa vigente, en ramales de longitud inferior a 3 metros, incluso con protección de tubo corrugado de PVC.	4.962	\N	7	2004-01-01	m.	4.960
E20TC030	Tubería de cobre de 16/18 mm.	Tubería de cobre recocido, de 16/18 mm. de diámetro nominal, en instalaciones interiores de viviendas y locales comerciales, para agua fría y caliente, con p.p. de piezas especiales de cobre, instalada y funcionando, según normativa vigente, en ramales de longitud inferior a 3 metros, incluso con protección de tubo corrugado de PVC.	Tubería de cobre recocido, de 16/18 mm. de diámetro nominal, en instalaciones interiores de viviendas y locales comerciales, para agua fría y caliente, con p.p. de piezas especiales de cobre, instalada y funcionando, según normativa vigente, en ramales de longitud inferior a 3 metros, incluso con protección de tubo corrugado de PVC.	6.028	\N	7	2004-01-01	m.	6.030
E20TC040	Tubería de cobre de 20/22 mm.	Tubería de cobre rígido, de 20/22 mm. de diámetro nominal, en instalaciones interiores de viviendas y locales comerciales, para agua fría y caliente, con p.p. de piezas especiales de cobre, instalada y funcionando, según normativa vigente, en ramales de longitud superior a 3 metros, incluso con protección de tubo corrugado de PVC.	Tubería de cobre rígido, de 20/22 mm. de diámetro nominal, en instalaciones interiores de viviendas y locales comerciales, para agua fría y caliente, con p.p. de piezas especiales de cobre, instalada y funcionando, según normativa vigente, en ramales de longitud superior a 3 metros, incluso con protección de tubo corrugado de PVC.	5.946	\N	7	2004-01-01	m.	5.940
E20TC050	Tubería de cobre de 26/28 mm.	Tubería de cobre rígido, de 26/28 mm. de diámetro nominal, en instalaciones interiores de viviendas y locales comerciales, para agua fría y caliente, con p.p. de piezas especiales de cobre, instalada y funcionando, según normativa vigente, en ramales de longitud superior a 3 metros, incluso con protección de tubo corrugado de PVC.	Tubería de cobre rígido, de 26/28 mm. de diámetro nominal, en instalaciones interiores de viviendas y locales comerciales, para agua fría y caliente, con p.p. de piezas especiales de cobre, instalada y funcionando, según normativa vigente, en ramales de longitud superior a 3 metros, incluso con protección de tubo corrugado de PVC.	7.394	\N	7	2004-01-01	m.	7.400
E20AL020	Acometida dn20 mm.polietil.3/4"	Acometida a la red general municipal de agua potable hasta una longitud máxima de 8 m., realizada con tubo de polietileno de 20 mm. de diámetro nominal, de alta densidad y para 0,6 MPa de presión máxima con collarín de toma de polipropileno de 40-3/4" reforzado con fibra de vidrio, p.p. de piezas especiales de polietileno y tapón roscado, terminada y funcionando, y sin incluir la rotura del pavimento.	Acometida a la red general municipal de agua potable hasta una longitud máxima de 8 m., realizada con tubo de polietileno de 20 mm. de diámetro nominal, de alta densidad y para 0,6 MPa de presión máxima con collarín de toma de polipropileno de 40-3/4" reforzado con fibra de vidrio, p.p. de piezas especiales de polietileno y tapón roscado, terminada y funcionando, y sin incluir la rotura del pavimento.	42.902	\N	7	2004-01-01	ud	42.910
E22CF010	Caldera fundic. 18.000 kcal/h	Caldera fundición de 18.000 kcal/h para calefacción de gasóleo, instalada, i/quemador, equipo de control formado por termómetro, termostatos de regulación y seguridad con rearme manual, red de tuberías de cobre aisladas, hasta cuarto de calderas.	Caldera fundición de 18.000 kcal/h para calefacción de gasóleo, instalada, i/quemador, equipo de control formado por termómetro, termostatos de regulación y seguridad con rearme manual, red de tuberías de cobre aisladas, hasta cuarto de calderas.	1005.100	\N	7	2004-01-01	ud	1005.140
E22DG030	Depósito gasóleo hor. 1.000 l.	Depósito de gasóleo C de 1.000 l. de chapa de acero, completo, para ir aéreo protegido contra corrosión mediante tratamiento de chorro de arena SA-2 1/2, imprimación de 300 micras de resina de poliuretano, i/ capas epoxi, i/homologación M.I.E., sin incluir obra civil, i/canalización hasta quemador con tubería de cobre electrolítico protegido con funda de tubo PVC de 18 mm., boca de carga de 3" tipo CAMPSA, tubería de ventilación, válvulas y accesorios, sin equipo de presión.	Depósito de gasóleo C de 1.000 l. de chapa de acero, completo, para ir aéreo protegido contra corrosión mediante tratamiento de chorro de arena SA-2 1/2, imprimación de 300 micras de resina de poliuretano, i/ capas epoxi, i/homologación M.I.E., sin incluir obra civil, i/canalización hasta quemador con tubería de cobre electrolítico protegido con funda de tubo PVC de 18 mm., boca de carga de 3" tipo CAMPSA, tubería de ventilación, válvulas y accesorios, sin equipo de presión.	1153.615	\N	7	2004-01-01	ud	1153.620
E22SEL020	Elem.alumi.iny.h=60 142 kcal/h	Elemento de aluminio inyectado acoplables entre sí de dimensiones h=57 cm., a=8 cm., g=10 cm., potencia 142 kcal/h., probado a 9 bar de presión, acabado en doble capa, una de imprimación y la segunda de polvo epoxi color blanco-marfil, equipado de p.p. llave monogiro de 3/8", tapones, detentores y purgador, así como p.p. de accesorios de montaje: reducciones, juntas, soportes y pintura para retoques.	Elemento de aluminio inyectado acoplables entre sí de dimensiones h=57 cm., a=8 cm., g=10 cm., potencia 142 kcal/h., probado a 9 bar de presión, acabado en doble capa, una de imprimación y la segunda de polvo epoxi color blanco-marfil, equipado de p.p. llave monogiro de 3/8", tapones, detentores y purgador, así como p.p. de accesorios de montaje: reducciones, juntas, soportes y pintura para retoques.	13.472	\N	7	2004-01-01	ud	13.480
E22NTC010	Tubería de cobre d=10-12 mm.	Tubería de cobre de 10-12 mm. de diámetro, Norma UNE 37.141, para red de distribución de calefacción, con p.p. de accesorios, soldadura, pequeño material y aislamiento térmico s/IT.IC, probado a 10 kg/cm2.	Tubería de cobre de 10-12 mm. de diámetro, Norma UNE 37.141, para red de distribución de calefacción, con p.p. de accesorios, soldadura, pequeño material y aislamiento térmico s/IT.IC, probado a 10 kg/cm2.	5.423	\N	7	2004-01-01	m.	5.420
E22NTC020	Tubería de cobre d=13-15 mm.	Tubería de cobre de 13-15 mm. de diámetro, Norma UNE 37.141, para red de distribución de calefacción, con p.p. de accesorios, soldadura, pequeño material y aislamiento térmico s/IT.IC, probado a 10 kg/cm2.	Tubería de cobre de 13-15 mm. de diámetro, Norma UNE 37.141, para red de distribución de calefacción, con p.p. de accesorios, soldadura, pequeño material y aislamiento térmico s/IT.IC, probado a 10 kg/cm2.	5.943	\N	7	2004-01-01	m.	5.940
E22NTC030	Tubería de cobre d=16-18 mm.	Tubería de cobre de 16-18 mm. de diámetro, Norma UNE 37.141, para red de distribución de calefacción, con p.p. de accesorios, soldadura, pequeño material y aislamiento térmico s/IT.IC, probado a 10 kg/cm2.	Tubería de cobre de 16-18 mm. de diámetro, Norma UNE 37.141, para red de distribución de calefacción, con p.p. de accesorios, soldadura, pequeño material y aislamiento térmico s/IT.IC, probado a 10 kg/cm2.	6.723	\N	7	2004-01-01	m.	6.720
E22NTC050	Tubería de cobre d=26-28 mm.	Tubería de cobre de 26-28 mm. de diámetro, Norma UNE 37.141, para red de distribución de calefacción, con p.p. de accesorios, soldadura, pequeño material y aislamiento térmico s/IT.IC, probado a 10 kg/cm2.	Tubería de cobre de 26-28 mm. de diámetro, Norma UNE 37.141, para red de distribución de calefacción, con p.p. de accesorios, soldadura, pequeño material y aislamiento térmico s/IT.IC, probado a 10 kg/cm2.	9.533	\N	7	2004-01-01	m.	9.530
E17DGC020	Termostato ambiente jung-cd 500	Termostato de ambiente electrónico para instalaciones de calefacción y refrigeración, programado para conmutador exterior centralizado invierno/verano, campo de regulación 5-30ºC, realizado en tubo de PVC corrugado de M 20/gp5 y conductor de cobre unipolar aislados para una tensión nominal de 750 V. y sección 1,5 mm2., incluido mecanismo electrónico termostato ambiente Jung-CD 500, caja registro, totalmente instalado.	Termostato de ambiente electrónico para instalaciones de calefacción y refrigeración, programado para conmutador exterior centralizado invierno/verano, campo de regulación 5-30ºC, realizado en tubo de PVC corrugado de M 20/gp5 y conductor de cobre unipolar aislados para una tensión nominal de 750 V. y sección 1,5 mm2., incluido mecanismo electrónico termostato ambiente Jung-CD 500, caja registro, totalmente instalado.	74.171	\N	7	2004-01-01	ud	74.170
E02ES020	Exc.zanja saneam. t.duro a mano	Excavación en zanjas de saneamiento, en terrenos de consistencia dura, por medios manuales, con extracción de tierras a los bordes, y con posterior relleno y apisonado de las tierras procedentes de la excavación y con p.p. de medios auxiliares.	Excavación en zanjas de saneamiento, en terrenos de consistencia dura, por medios manuales, con extracción de tierras a los bordes, y con posterior relleno y apisonado de las tierras procedentes de la excavación y con p.p. de medios auxiliares.	46.266	\N	7	2004-01-01	m3	46.270
CENZANO	Vivienda unifamiliar en Pozuelo	MEMORIA GEOMETRICA\r\n\r\nTIPO DE OBRA\r\n\r\nViviendas unifamiliares \r\n\r\n\r\nGEOMETRIA\r\n\r\nPlantas sobre rasante: 2 \r\nPlantas totales del edificio: 2 \r\nSuperficie total sobre rasante 240 m2\r\ncon una altura total s/r de 6 m\r\nEl número total de viviendas es de 1 unidades\r\ncon una superficie media de 240 m2 construidos\r\n\r\nPlanta baja\r\n120 m2 construidos\r\n3 m de altura de suelo a techo\r\n\r\nPlanta 1 ª\r\n120 m2 construidos\r\n3 m de altura de suelo a techo\r\n\r\nMEMORIA DE CALIDADES\r\n\r\nCIMENTACION\r\nCimentación realizada con Zapatas y pozos \r\n\r\nESTRUCTURA\r\nPilares de hormigón armado\r\nVigas de hormigón armado\r\nForjado de Vig. Autorresistentes \r\nEstructura de cubierta de Forjado viguetas inclinado \r\nEscaleras interiores de Losa hormigón inclinada \r\n\r\nCUBIERTA\r\nCubierta inclinada de Teja cerámica \r\ncon aislamiento de Poliestireno extruido \r\n\r\nCERRAMIENTO Y TABIQUERIA\r\nCerramiento de Ladrillo perforado 1 pie visto\r\nAislamiento de trasdosado con Poliestireno extruido \r\nTabiquería interior de Tabique-Tabicón \r\n\r\nREVESTIMIENTOS\r\nRev. vertical de Guarnecido maestreado y enlucido en zonas comunes\r\nRev. vertical de Guarnecido maestreado y enlucido en zonas privadas\r\nRev. vertical de Azulejos en cuartos húmedos\r\n\r\nSuelo de Cerámico en zonas comunes\r\nSuelo de Parquet madera en zonas privadas\r\nSuelo de Mármol en cuartos húmedos\r\nSuelo de Terrazo en zonas de terraza\r\n\r\nTecho de Guarnecido maestreado y enlucido en zonas comunes\r\nTecho de Guarnecido maestreado y enlucido en zonas privadas\r\nTecho de F.T.Escayola en cuartos húmedos\r\nTecho de Enfoscado maestreado en exteriores\r\n\r\nPINTURAS\r\nPlástica lisa en zonas comunes\r\nTemple liso en zonas privadas\r\nPlástica lisa en cuartos húmedos\r\nPlástica lisa en exteriores\r\n\r\nCARPINTERIA\r\nCarpintería interior de Roble lisa \r\nCarpintería exterior de Aluminio lacado abatible \r\nProtecciones mediante Persiana PVC \r\nBarandillas interiores de Aluminio \r\nBarandillas exteriores de Acero \r\n\r\nFONTANERIA Y SANEAMIENTO\r\nSaneamiento de PVC enterrado\r\nSaneamiento de hormigón centrifugado enterrado\r\nAbastecimiento de agua con Tuberías de cobre \r\n\r\nCLIMATIZACION\r\nProducción por Centralizada (Calf. y ACS) de gasóleo \r\nEmisores mediante Elementos Aluminio \r\n\r\nELECTRICIDAD\r\nGrado electrificación: Elec.Media\r\n	MEMORIA GEOMETRICA\r\n\r\nTIPO DE OBRA\r\n\r\nViviendas unifamiliares \r\n\r\n\r\nGEOMETRIA\r\n\r\nPlantas sobre rasante: 2 \r\nPlantas totales del edificio: 2 \r\nSuperficie total sobre rasante 240 m2\r\ncon una altura total s/r de 6 m\r\nEl número total de viviendas es de 1 unidades\r\ncon una superficie media de 240 m2 construidos\r\n\r\nPlanta baja\r\n120 m2 construidos\r\n3 m de altura de suelo a techo\r\n\r\nPlanta 1 ª\r\n120 m2 construidos\r\n3 m de altura de suelo a techo\r\n\r\nMEMORIA DE CALIDADES\r\n\r\nCIMENTACION\r\nCimentación realizada con Zapatas y pozos \r\n\r\nESTRUCTURA\r\nPilares de hormigón armado\r\nVigas de hormigón armado\r\nForjado de Vig. Autorresistentes \r\nEstructura de cubierta de Forjado viguetas inclinado \r\nEscaleras interiores de Losa hormigón inclinada \r\n\r\nCUBIERTA\r\nCubierta inclinada de Teja cerámica \r\ncon aislamiento de Poliestireno extruido \r\n\r\nCERRAMIENTO Y TABIQUERIA\r\nCerramiento de Ladrillo perforado 1 pie visto\r\nAislamiento de trasdosado con Poliestireno extruido \r\nTabiquería interior de Tabique-Tabicón \r\n\r\nREVESTIMIENTOS\r\nRev. vertical de Guarnecido maestreado y enlucido en zonas comunes\r\nRev. vertical de Guarnecido maestreado y enlucido en zonas privadas\r\nRev. vertical de Azulejos en cuartos húmedos\r\n\r\nSuelo de Cerámico en zonas comunes\r\nSuelo de Parquet madera en zonas privadas\r\nSuelo de Mármol en cuartos húmedos\r\nSuelo de Terrazo en zonas de terraza\r\n\r\nTecho de Guarnecido maestreado y enlucido en zonas comunes\r\nTecho de Guarnecido maestreado y enlucido en zonas privadas\r\nTecho de F.T.Escayola en cuartos húmedos\r\nTecho de Enfoscado maestreado en exteriores\r\n\r\nPINTURAS\r\nPlástica lisa en zonas comunes\r\nTemple liso en zonas privadas\r\nPlástica lisa en cuartos húmedos\r\nPlástica lisa en exteriores\r\n\r\nCARPINTERIA\r\nCarpintería interior de Roble lisa \r\nCarpintería exterior de Aluminio lacado abatible \r\nProtecciones mediante Persiana PVC \r\nBarandillas interiores de Aluminio \r\nBarandillas exteriores de Acero \r\n\r\nFONTANERIA Y SANEAMIENTO\r\nSaneamiento de PVC enterrado\r\nSaneamiento de hormigón centrifugado enterrado\r\nAbastecimiento de agua con Tuberías de cobre \r\n\r\nCLIMATIZACION\r\nProducción por Centralizada (Calf. y ACS) de gasóleo \r\nEmisores mediante Elementos Aluminio \r\n\r\nELECTRICIDAD\r\nGrado electrificación: Elec.Media\r\n	134992.462	\N	6	2019-06-22	\N	\N
\.


--
-- TOC entry 3165 (class 0 OID 16953)
-- Dependencies: 223
-- Data for Name: CENZANO_Mediciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."CENZANO_Mediciones" (id, num_certif, tipo, comentario, ud, longitud, anchura, altura, formula, codpadre, codhijo, posicion) FROM stdin;
1	0	0	Zona norte	1	3.000	3.500	0.000	\N	01	E02AM010	0
4	0	3		1	0.000	0.000	0.000	\N	01	E02AM010	3
5	0	0	Zona ajardinada	1	2.000	7.000	0.000	\N	01	E02AM010	4
6	0	3		1	17.000	9.000	0.500	\N	01	E02EM030	0
7	0	3		1	12.000	12.000	0.700	\N	01	E02EM030	1
8	0	3		1	8.000	4.000	0.600	\N	01	E02EM030	2
9	0	3		1	0.000	0.000	0.000	\N	01	E02EM030	3
10	0	3		1	9.000	3.000	0.500	\N	01	E02EM030	4
11	0	1	Subtotal explanación	0	0.000	0.000	0.000	\N	01	E02EM030	5
12	0	0	Zapata 1 zona sur	1	2.000	0.340	0.900	\N	01	E02EM030	6
13	0	0	Zapata 2 zona sur	1	3.000	0.340	0.900	\N	01	E02EM030	7
14	0	0	Zapata 3 zona sur	1	2.500	0.340	0.900	\N	01	E02EM030	8
15	0	0	Zapata 4 zona sur	1	3.500	0.340	0.900	\N	01	E02EM030	9
16	0	0	Zapata 5 zona norte	1	2.000	0.550	0.900	\N	01	E02EM030	10
17	0	0	Zapata 6 zona norte	1	3.000	0.550	0.900	\N	01	E02EM030	11
18	0	0	Zapata 7 zona norte	1	3.500	0.550	0.900	\N	01	E02EM030	12
19	0	1	Subtotal zapatas	0	0.000	0.000	0.000	\N	01	E02EM030	13
20	0	2	Subtotal acumulado	0	0.000	0.000	0.000	\N	01	E02EM030	14
21	0	0	Zócalo norte	1	12.000	0.650	0.900	\N	01	E02EM030	15
22	0	0	Zócalo sur	1	5.000	0.550	0.900	\N	01	E02EM030	16
23	0	0	Zócalo oeste	1	5.000	0.550	0.900	\N	01	E02EM030	17
24	0	1	Subtotal zócalos	0	0.000	0.000	0.000	\N	01	E02EM030	18
25	0	0	Ampliación de jardín	1	6.000	3.000	0.300	\N	01	E02EM030	19
26	0	0	Valla de jardín	1	3.000	0.700	0.400	\N	01	E02EM030	20
27	0	0	Ampliación de jardín	1	2.000	3.000	0.250	\N	01	E02EM030	21
28	0	0	Ampliación de jardín	1	4.000	3.000	0.880	\N	01	E02EM030	22
29	0	0	Pozos / arquetas	1	1.500	1.500	1.100	\N	01	E02PM030	0
30	0	0	Pozos / arquetas	1	1.000	1.000	2.000	\N	01	E02PM030	1
31	0	0	Pozos / arquetas	1	0.700	0.700	5.000	\N	01	E02PM030	2
32	0	0	Explanación	120	0.000	0.000	0.000	\N	01	E02TT040	0
33	0	0	Zanjas	13	0.000	0.000	0.000	\N	01	E02TT040	1
34	0	0	Pozos	10	0.000	0.000	0.000	\N	01	E02TT040	2
35	0	0	Ampliación	25	0.000	0.000	0.000	\N	01	E02TT040	3
36	0	0	Saneamientos	3	0.000	0.000	0.000	\N	02	E03ALA010	0
37	0	0	Saneamientos	1	0.000	0.000	0.000	\N	02	E03ALR020	0
38	0	0	Saneamientos	1	0.000	0.000	0.000	\N	02	E03ALR040	0
39	0	0	Saneamientos	1	0.000	0.000	0.000	\N	02	E03ALS020	0
40	0	0	Saneamientos	1	0.000	0.000	0.000	\N	02	E03ZLR010	0
41	0	0	Saneamientos	1	9.000	0.000	0.000	\N	02	E03OEH010	0
42	0	0	Saneamientos	1	1.930	0.000	0.000	\N	02	E03OEH020	0
43	0	0	Saneamientos	1	0.640	0.000	0.000	\N	02	E03OEH030	0
44	0	0	Saneamientos	1	12.900	0.000	0.000	\N	02	E03OEP005	0
45	0	0	Saneamientos	1	23.200	0.000	0.000	\N	02	E03OEP008	0
46	0	0	Saneamientos	1	12.900	0.000	0.000	\N	02	E03OEP130	0
47	0	0	Saneamientos	1	2.580	0.000	0.000	\N	02	E03OEP140	0
48	0	0	Saneamientos	1	0.000	0.000	0.000	\N	02	E03M010	0
49	0	0	Colectores a red general	1	2.280	0.700	0.640	\N	E03M010	E02ES020	0
50	0	0	Colectores a red general	1	2.000	0.700	0.640	\N	E03M010	E02ES020	1
51	0	0	Colectores a red general	1	3.000	0.700	0.640	\N	E03M010	E02ES020	2
52	0	0	Colectores a red general	1	2.000	0.700	0.640	\N	E03M010	E02ES020	3
53	0	0	Colectores a vivienda	1	2.770	0.800	0.450	\N	E03M010	E02ES020	4
54	0	0	Colectores a vivienda	1	1.000	0.800	0.450	\N	E03M010	E02ES020	5
55	0	0	Resto de colectores	1	3.000	0.600	0.560	\N	E03M010	E02ES020	6
56	0	0	Resto de colectores	1	2.000	0.600	0.560	\N	E03M010	E02ES020	7
57	0	0	Garaje	1	7.150	0.100	1.000	\N	03	E04CM040	0
58	0	0	Garaje	1	5.200	0.100	1.000	\N	03	E04CM040	1
59	0	0	Zocalos	1	10.000	0.180	0.730	\N	03	E04CA060	0
60	0	0	Zocalos	1	10.000	0.180	0.600	\N	03	E04CA060	1
61	0	0	Zapatas	4	1.500	1.000	0.450	\N	03	E04CA060	2
62	0	0	Zapatas	2	1.000	1.000	0.450	\N	03	E04CA060	3
63	0	0	Solar	1	12.000	10.000	0.000	\N	03	E04SA020	0
64	0	0	Rampa	1	6.000	3.000	0.000	\N	03	E04SA020	1
65	0	0	a deducir	-1	8.000	3.750	0.000	\N	03	E04SA020	2
66	0	0	Solar	1	12.000	10.000	0.000	\N	03	E04SE020	0
67	0	0	Rampa	1	6.000	3.000	0.000	\N	03	E04SE020	1
68	0	0	a deducir	-1	8.000	3.750	0.000	\N	03	E04SE020	2
69	0	0	Pilares	2	0.300	0.300	3.250	\N	04	E05HSA010	0
70	0	0	Pilares	2	0.350	0.350	3.250	\N	04	E05HSA010	1
71	0	0	Pilares	4	0.450	0.450	5.000	\N	04	E05HSA010	2
72	0	0	Jácenas	6	15.000	0.300	0.300	\N	04	E05HVA030	0
73	0	0	Jácenas	8	12.000	0.300	0.300	\N	04	E05HVA030	1
74	0	0	Zunchos	2	15.000	0.300	0.300	\N	04	E05HVA075	0
75	0	0	Zunchos	2	12.000	0.300	0.300	\N	04	E05HVA075	1
76	0	0	Zunchos	2	13.000	0.300	0.300	\N	04	E05HVA075	2
77	0	0	1ª Planta	1	12.000	10.000	0.000	\N	04	E05HFA060	0
78	0	0	2ª Planta	1	12.000	10.000	0.000	\N	04	E05HFA060	1
79	0	0	Cubierta	1	10.000	9.000	0.010	\N	04	E05HLA070	0
80	0	0	Cubierta	1	12.300	10.100	0.000	\N	04	E05HFS160	0
81	0	0	Ventanas	1	28.700	0.000	0.000	\N	04	E05AW020	0
3	0	0	Vía de acceso	1	3.000	3.500	0.000	\N	01	E02AM010	2
82	0	0	Zona - A	2	10.000	0.000	0.000	\N	04	E05AW040	0
83	0	0	Zona - B	2	12.000	0.000	0.000	\N	04	E05AW040	1
84	0	0	Planta baja	1	10.000	0.000	2.700	\N	05	E07LSB040	0
85	0	0		1	8.000	0.000	2.700	\N	05	E07LSB040	1
86	0	0		1	9.000	0.000	2.700	\N	05	E07LSB040	2
87	0	0		1	7.000	0.000	2.700	\N	05	E07LSB040	3
88	0	0		1	8.000	0.000	2.700	\N	05	E07LSB040	4
89	0	0		1	10.000	0.000	2.700	\N	05	E07LSB040	5
90	0	0		1	8.000	0.000	2.700	\N	05	E07LSB040	6
91	0	0	A deducir	-7	1.200	0.000	1.200	\N	05	E07LSB040	7
92	0	0	Planta 1ª	1	10.000	0.000	2.700	\N	05	E07LSB040	8
93	0	0		1	9.000	0.000	2.700	\N	05	E07LSB040	9
94	0	0		1	8.000	0.000	2.700	\N	05	E07LSB040	10
95	0	0		1	7.000	0.000	2.700	\N	05	E07LSB040	11
96	0	0		1	1.730	0.000	2.700	\N	05	E07LSB040	12
97	0	0		1	1.730	0.000	2.700	\N	05	E07LSB040	13
98	0	0		1	3.170	0.000	2.700	\N	05	E07LSB040	14
99	0	0		1	0.450	0.000	2.700	\N	05	E07LSB040	15
100	0	0	A deducir	-7	1.200	0.000	1.200	\N	05	E07LSB040	16
101	0	0	Vestíbulo	1	3.150	0.000	2.700	\N	06	E07TBL010	0
102	0	0	Vestíbulo	1	3.000	0.000	2.700	\N	06	E07TBL010	1
103	0	0	Cocina	1	3.000	0.000	2.700	\N	06	E07TBL010	2
104	0	0	Cocina	1	3.000	0.000	2.700	\N	06	E07TBL010	3
105	0	0	Sala de estar	1	3.000	0.000	2.700	\N	06	E07TBL010	4
106	0	0	Sala de estar	1	3.000	0.000	2.700	\N	06	E07TBL010	5
107	0	0	Sala de estar	1	4.000	0.000	2.700	\N	06	E07TBL010	6
108	0	0	Comedor	1	4.000	0.000	2.700	\N	06	E07TBL010	7
109	0	0	Comedor	1	3.000	0.000	2.700	\N	06	E07TBL010	8
110	0	0	Dormitorio 1	1	3.500	0.000	2.700	\N	06	E07TBL010	9
111	0	0	Dormitorio 1	1	2.600	0.000	2.700	\N	06	E07TBL010	10
112	0	0	Dormitorio 2	1	3.000	0.000	2.700	\N	06	E07TBL010	11
113	0	0	Dormitorio 2	1	4.000	0.000	2.700	\N	06	E07TBL010	12
114	0	0	Dormitorio 3	1	3.000	0.000	2.700	\N	06	E07TBL010	13
115	0	0	Dormitorio 3	1	4.000	0.000	2.700	\N	06	E07TBL010	14
116	0	0	Aseo 1	1	3.000	0.000	2.700	\N	06	E07TBL010	15
117	0	0	Aseo 1	1	2.000	0.000	2.700	\N	06	E07TBL010	16
118	0	0	Aseo 2	1	3.000	0.000	2.700	\N	06	E07TBL010	17
119	0	0	Dormitorio 1	1	3.350	0.000	2.700	\N	06	E07TBL190	0
120	0	0	Dormitorio 1	1	2.550	0.000	2.700	\N	06	E07TBL190	1
121	0	0	Dormitorio 1	1	2.450	0.000	2.700	\N	06	E07TBL190	2
122	0	0	Dormitorio 2	1	2.850	0.000	2.700	\N	06	E07TBL190	3
123	0	0	Dormitorio 2	1	1.850	0.000	2.700	\N	06	E07TBL190	4
124	0	0	Dormitorio 2	1	3.100	0.000	2.700	\N	06	E07TBL190	5
125	0	0	Dormitorio 3	1	2.250	0.000	2.700	\N	06	E07TBL190	6
126	0	0	Dormitorio 3	1	2.050	0.000	2.700	\N	06	E07TBL190	7
127	0	0	Dormitorio 3	1	3.850	0.000	2.700	\N	06	E07TBL190	8
128	0	0	Planta baja	1	6.000	0.000	2.700	\N	06	E07LP013	0
129	0	0	Planta baja	1	5.000	0.000	2.700	\N	06	E07LP013	1
130	0	0	Planta baja	1	4.300	0.000	2.700	\N	06	E07LP013	2
131	0	0	Planta 1ª	1	5.000	0.000	2.700	\N	06	E07LP013	3
132	0	0	Planta 1ª	1	4.000	0.000	2.700	\N	06	E07LP013	4
133	0	0	Planta 1ª	1	2.000	0.000	2.700	\N	06	E07LP013	5
134	0	0	Vestíbulo	1	3.150	0.000	2.700	\N	06	E07TBL011	0
135	0	0	Vestíbulo	1	3.000	0.000	2.700	\N	06	E07TBL011	1
136	0	0	Cocina	1	3.000	0.000	2.700	\N	06	E07TBL011	2
137	0	0	Cocina	1	1.750	0.000	2.700	\N	06	E07TBL011	3
138	0	0	Cocina	1	3.000	0.000	2.700	\N	06	E07TBL011	4
139	0	0	Sala de estar	1	3.000	0.000	2.700	\N	06	E07TBL011	5
140	0	0	Sala de estar	1	2.600	0.000	2.700	\N	06	E07TBL011	6
141	0	0	Sala de estar	1	4.000	0.000	2.700	\N	06	E07TBL011	7
142	0	0	Comedor	1	3.000	0.000	2.700	\N	06	E07TBL011	8
143	0	0	Comedor	1	3.000	0.000	2.700	\N	06	E07TBL011	9
144	0	0	Comedor	1	3.000	0.000	2.700	\N	06	E07TBL011	10
145	0	0	Dormitorio 1	1	3.500	0.000	2.700	\N	06	E07TBL011	11
146	0	0	Dormitorio 1	1	2.700	0.000	2.700	\N	06	E07TBL011	12
147	0	0	Dormitorio 1	1	2.600	0.000	2.700	\N	06	E07TBL011	13
148	0	0	Dormitorio 2	1	3.000	0.000	2.700	\N	06	E07TBL011	14
149	0	0	Dormitorio 2	1	2.000	0.000	2.700	\N	06	E07TBL011	15
150	0	0	Dormitorio 2	1	3.250	0.000	2.700	\N	06	E07TBL011	16
151	0	0	Dormitorio 3	1	2.400	0.000	2.700	\N	06	E07TBL011	17
152	0	0	Dormitorio 3	1	2.200	0.000	2.700	\N	06	E07TBL011	18
153	0	0	Dormitorio 3	1	4.000	0.000	2.700	\N	06	E07TBL011	19
154	0	0	Aseo 1	1	2.100	0.000	2.700	\N	06	E07TBL011	20
155	0	0	Aseo 1	1	2.000	0.000	2.700	\N	06	E07TBL011	21
156	0	0	Aseo 2	1	3.000	0.000	2.700	\N	06	E07TBL011	22
157	0	0	Aseo 2	1	2.000	0.000	2.700	\N	06	E07TBL011	23
158	0	0	Peldaños escalera	1	16.000	1.100	0.000	\N	06	E07WP010	0
159	0	0	Barandilla	1	10.270	0.000	0.000	\N	06	E07TRE010	0
160	0	0	Pasamanos	1	6.070	0.000	0.000	\N	06	E07TRW070	0
161	0	0	Vierteaguas piedra	1	23.500	0.000	0.000	\N	06	E12PVA010	0
162	0	0	Vestíbulo	1	2.500	0.750	0.000	\N	06	E07TRC010	0
163	0	0	Cocina	1	2.500	0.750	0.000	\N	06	E07TRC010	1
164	0	0	Sala de estar	2	2.500	0.750	0.000	\N	06	E07TRC010	2
165	0	0	Comedor	1	2.500	0.750	0.000	\N	06	E07TRC010	3
166	0	0	Dormitorio 1	1	2.500	0.750	0.000	\N	06	E07TRC010	4
167	0	0	Dormitorio 2	1	2.500	0.750	0.000	\N	06	E07TRC010	5
168	0	0	Dormitorio 3	1	2.500	0.750	0.000	\N	06	E07TRC010	6
169	0	0	Aseo 1	1	2.500	0.750	0.000	\N	06	E07TRC010	7
170	0	0	Aseo 2	1	2.500	0.750	0.000	\N	06	E07TRC010	8
171	0	0	Ventanas correderas	0	0.000	0.000	0.000	\N	06	E07TRC030	0
172	0	0	Tipo 1	1	1.500	2.000	0.000	\N	06	E07TRC030	1
173	0	0	Tipo 2	1	4.000	3.000	0.000	\N	06	E07TRC030	2
174	0	0	Tipo 3	2	1.000	2.500	0.000	\N	06	E07TRC030	3
175	0	0	Tipo 4	2	1.000	2.500	0.000	\N	06	E07TRC030	4
176	0	0	Tipo 5	5	1.000	1.000	0.000	\N	06	E07TRC030	5
177	0	0	Ventanas fachada post.	4	1.000	1.000	0.000	\N	06	E07TRC030	6
178	0	0	Puertas chapa enrasada	1	1.000	1.000	0.000	\N	06	E07TRC030	7
179	0	0	Armarios contadores	1	1.000	1.000	0.000	\N	06	E07TRC030	8
180	0	0	Persianas	4	2.700	2.500	0.000	\N	06	E07TRP020	0
181	0	0	Persianas	4	2.000	2.500	0.000	\N	06	E07TRP010	0
182	0	0	Rejas	1	1.000	3.600	0.000	\N	06	E07TRE020	0
183	0	0	Chimenea	1	12.000	0.000	0.000	\N	06	E12PCC040	0
184	0	0	Chimenea	1	6.000	0.000	0.000	\N	06	E07WF010	0
185	0	0	Bañeras	2	0.000	0.000	0.000	\N	06	E07TRW020	0
186	0	0	Ayudas	1	0.000	0.000	0.000	\N	06	E07WA020	0
187	0	0	Ayudas	1	0.000	0.000	0.000	\N	06	E07WA010	0
188	0	0	Ayudas	1	0.000	0.000	0.000	\N	06	E07WA030	0
189	0	0	Cubierta	1	12.300	10.100	0.000	\N	07	E09ICX030	0
190	0	0	Alero	2	12.300	0.000	0.000	\N	07	E09IWA030	0
191	0	0	Alero	2	10.100	0.000	0.000	\N	07	E09IWA030	1
192	0	0	Cubierta	1	11.000	10.000	0.000	\N	08	E10ATP180	0
193	0	0	1ª Planta	1	10.500	10.000	0.000	\N	08	E10AAR009	0
194	0	0	2ª Planta	1	10.500	10.000	0.000	\N	08	E10AAR009	1
195	0	0	Cubierta	1	10.000	10.000	0.000	\N	08	E10ATT070	0
196	0	0	Vestíbulo	1	3.150	0.000	2.700	\N	08	E10ATV360	0
197	0	0	Vestíbulo	1	3.000	0.000	2.700	\N	08	E10ATV360	1
198	0	0	Cocina	1	3.000	0.000	2.700	\N	08	E10ATV360	2
199	0	0	Cocina	1	1.750	0.000	2.700	\N	08	E10ATV360	3
200	0	0	Cocina	1	3.000	0.000	2.700	\N	08	E10ATV360	4
201	0	0	Sala de estar	1	3.000	0.000	2.700	\N	08	E10ATV360	5
202	0	0	Sala de estar	1	2.600	0.000	2.700	\N	08	E10ATV360	6
203	0	0	Sala de estar	1	4.000	0.000	2.700	\N	08	E10ATV360	7
204	0	0	Comedor	1	3.000	0.000	2.700	\N	08	E10ATV360	8
205	0	0	Comedor	1	3.000	0.000	2.700	\N	08	E10ATV360	9
206	0	0	Comedor	1	3.000	0.000	2.700	\N	08	E10ATV360	10
207	0	0	Dormitorio 1	1	3.500	0.000	2.700	\N	08	E10ATV360	11
208	0	0	Dormitorio 1	1	2.700	0.000	2.700	\N	08	E10ATV360	12
209	0	0	Dormitorio 1	1	2.600	0.000	2.700	\N	08	E10ATV360	13
210	0	0	Dormitorio 2	1	3.000	0.000	2.700	\N	08	E10ATV360	14
211	0	0	Dormitorio 2	1	2.000	0.000	2.700	\N	08	E10ATV360	15
212	0	0	Dormitorio 2	1	3.250	0.000	2.700	\N	08	E10ATV360	16
213	0	0	Dormitorio 3	1	2.400	0.000	2.700	\N	08	E10ATV360	17
214	0	0	Dormitorio 3	1	2.200	0.000	2.700	\N	08	E10ATV360	18
215	0	0	Dormitorio 3	1	4.000	0.000	2.700	\N	08	E10ATV360	19
216	0	0	Aseo 1	1	2.100	0.000	2.700	\N	08	E10ATV360	20
217	0	0	Aseo 1	1	2.000	0.000	2.700	\N	08	E10ATV360	21
218	0	0	Aseo 2	1	3.000	0.000	2.700	\N	08	E10ATV360	22
219	0	0	Aseo 2	1	2.000	0.000	2.700	\N	08	E10ATV360	23
220	0	0	Tuberías de 21	1	40.570	0.000	0.000	\N	08	E10AKV010	0
221	0	0	Tuberías de 34	1	25.840	0.000	0.000	\N	08	E10AKV060	0
222	0	0	Tuberías de 60	1	8.710	0.000	0.000	\N	08	E10AKV120	0
223	0	0	Muros	1	44.000	0.000	0.500	\N	09	E10INR090	0
224	0	0	Cubierta	1	4.800	0.000	0.000	\N	09	E10INX010	0
225	0	0	Cubierta	1	44.750	0.000	0.000	\N	09	E10IAW049	0
226	0	0	Cubierta	1	14.400	1.000	0.000	\N	09	E10INL060	0
227	0	0	Vestíbulo	1	3.150	0.000	2.700	\N	10	E08PFA020	0
228	0	0	Vestíbulo	1	3.000	0.000	2.700	\N	10	E08PFA020	1
229	0	0	Cocina	1	3.000	0.000	2.700	\N	10	E08PFA020	2
230	0	0	Cocina	1	1.750	0.000	2.700	\N	10	E08PFA020	3
231	0	0	Cocina	1	3.000	0.000	2.700	\N	10	E08PFA020	4
232	0	0	Sala de estar	1	3.000	0.000	2.700	\N	10	E08PFA020	5
233	0	0	Sala de estar	1	2.600	0.000	2.700	\N	10	E08PFA020	6
234	0	0	Sala de estar	1	4.000	0.000	2.700	\N	10	E08PFA020	7
235	0	0	Comedor	1	3.000	0.000	2.700	\N	10	E08PFA020	8
236	0	0	Comedor	1	3.000	0.000	2.700	\N	10	E08PFA020	9
237	0	0	Comedor	1	3.000	0.000	2.700	\N	10	E08PFA020	10
238	0	0	Dormitorio 1	1	3.500	0.000	2.700	\N	10	E08PFA020	11
239	0	0	Dormitorio 1	1	2.700	0.000	2.700	\N	10	E08PFA020	12
240	0	0	Dormitorio 1	1	2.600	0.000	2.700	\N	10	E08PFA020	13
241	0	0	Dormitorio 2	1	3.000	0.000	2.700	\N	10	E08PFA020	14
242	0	0	Dormitorio 2	1	2.000	0.000	2.700	\N	10	E08PFA020	15
243	0	0	Dormitorio 2	1	3.250	0.000	2.700	\N	10	E08PFA020	16
244	0	0	Dormitorio 3	1	2.400	0.000	2.700	\N	10	E08PFA020	17
245	0	0	Dormitorio 3	1	2.200	0.000	2.700	\N	10	E08PFA020	18
246	0	0	Dormitorio 3	1	4.000	0.000	2.700	\N	10	E08PFA020	19
247	0	0	Aseo 1	1	2.100	0.000	2.700	\N	10	E08PFA020	20
248	0	0	Aseo 1	1	2.000	0.000	2.700	\N	10	E08PFA020	21
249	0	0	Aseo 2	1	3.000	0.000	2.700	\N	10	E08PFA020	22
250	0	0	Aseo 2	1	2.000	0.000	2.700	\N	10	E08PFA020	23
251	0	0	Distribuidor	1	23.380	0.000	2.700	\N	10	E08PEM010	0
252	0	0	Distribuidor	1	20.000	0.000	2.700	\N	10	E08PEM010	1
253	0	0	Salón	1	22.600	0.000	2.700	\N	10	E08PEM010	2
254	0	0	Salón	1	43.000	0.000	2.700	\N	10	E08PEM010	3
255	0	0	Comedor	1	14.000	0.000	2.700	\N	10	E08PEM010	4
256	0	0	Comedor	1	9.000	0.000	2.700	\N	10	E08PEM010	5
257	0	0	Trastero	1	8.220	0.000	2.700	\N	10	E08PEM010	6
258	0	0	Trastero	1	8.220	0.000	2.700	\N	10	E08PEM010	7
259	0	0	Garaje	1	17.600	0.000	2.700	\N	10	E08PEM010	8
260	0	0	Garaje	1	17.600	0.000	2.700	\N	10	E08PEM010	9
261	0	0	Hall	1	10.500	0.000	2.700	\N	10	E08PEM010	10
262	0	0	Hall	1	10.500	0.000	2.700	\N	10	E08PEM010	11
263	0	0	Esc. Baja	1	14.100	0.000	2.700	\N	10	E08PEM010	12
264	0	0	Esc. Baja	1	14.100	0.000	2.700	\N	10	E08PEM010	13
265	0	0	Dormitorio 1	1	12.000	0.000	2.700	\N	10	E08PEM010	14
266	0	0	Dormitorio 1	1	17.000	0.000	2.700	\N	10	E08PEM010	15
267	0	0	Dormitorio 2	1	13.360	0.000	2.700	\N	10	E08PEM010	16
268	0	0	Dormitorio 2	1	15.000	0.000	2.700	\N	10	E08PEM010	17
269	0	0	Dormitorio 3	1	13.160	0.000	2.700	\N	10	E08PEM010	18
270	0	0	Dormitorio 3	1	11.000	0.000	2.700	\N	10	E08PEM010	19
271	0	0	Faldon ext.	1	6.000	0.000	0.200	\N	10	E08PEM010	20
272	0	0	Faldon ext.	1	6.000	0.000	0.200	\N	10	E08PEM010	21
273	0	0	Terraza 1	1	6.780	0.000	2.400	\N	10	E08PEM010	22
274	0	0	Terraza 1	1	6.780	0.000	2.400	\N	10	E08PEM010	23
275	0	0	Cocina	1	1.700	0.000	2.700	\N	10	E08PFM081	0
276	0	0	Cocina	1	4.000	0.000	2.700	\N	11	E12AC101	0
277	0	0	Cocina	1	3.000	0.000	2.700	\N	11	E12AC101	1
278	0	0	Cocina	1	4.200	0.000	2.700	\N	11	E12AC101	2
279	0	0	Cocina	1	3.500	0.000	2.700	\N	11	E12AC101	3
280	0	0	Aseo 1	1	3.500	0.000	2.700	\N	11	E12AC101	4
281	0	0	Aseo 1	1	2.000	0.000	2.700	\N	11	E12AC101	5
282	0	0	Aseo 2	1	3.000	0.000	2.400	\N	11	E12AC101	6
283	0	0	Aseo 2	1	2.000	0.000	2.400	\N	11	E12AC101	7
284	0	0	Aseo 1	1	3.500	0.000	0.000	\N	11	E12AC180	0
285	0	0	Aseo 1	1	2.000	0.000	0.000	\N	11	E12AC180	1
286	0	0	Aseo 1	1	3.000	0.000	0.000	\N	11	E12AC180	2
287	0	0	Aseo 2	1	3.000	0.000	0.000	\N	11	E12AC180	3
288	0	0	Aseo 2	1	2.000	0.000	0.000	\N	11	E12AC180	4
289	0	0	Aseo 2	1	3.000	0.000	0.000	\N	11	E12AC180	5
290	0	0	Cocina	1	4.000	0.000	0.000	\N	11	E12AC180	6
291	0	0	Cocina	1	3.000	0.000	0.000	\N	11	E12AC180	7
292	0	0	Cocina	1	4.200	0.000	0.000	\N	11	E12AC180	8
293	0	0	Cocina	1	2.300	0.000	0.000	\N	11	E12AC180	9
294	0	0	Cocina	1	6.000	0.000	0.000	\N	11	E12AC220	0
295	0	0	Cocina	1	2.000	0.000	0.000	\N	11	E12PNM010	0
296	0	0	Cocina	1	5.000	4.000	0.000	\N	12	E11EXB030	0
297	0	0	Peldaños escalera	1	120.000	0.000	0.200	\N	12	E11EXP220	0
298	0	0	Peldaños escalera	1	16.000	1.100	0.000	\N	12	E11EXP012	0
299	0	0	Aseo 1	1	3.000	0.000	0.000	\N	12	E11EXP212	0
300	0	0	Aseo 2	1	3.000	0.000	0.000	\N	12	E11EXP212	1
301	0	0	Hall	1	3.000	2.000	0.000	\N	12	E11RAM050	0
302	0	0	Salón	1	9.000	6.000	0.000	\N	12	E11RAM050	1
303	0	0	Comedor	1	5.000	4.000	0.000	\N	12	E11RAM050	2
304	0	0	Habitación 1	1	5.000	4.000	0.000	\N	12	E11RAM050	3
305	0	0	Habitación 2	1	4.000	3.000	0.000	\N	12	E11RAM050	4
306	0	0	Habitación 3	1	4.000	3.000	0.000	\N	12	E11RAM050	5
307	0	0	Pasillo	1	23.000	2.000	0.000	\N	12	E11RAM050	6
308	0	0	Hall	1	12.000	0.000	0.000	\N	12	E11RRA010	0
309	0	0	Salón	1	55.000	0.000	0.000	\N	12	E11RRA010	1
310	0	0	Comedor	1	30.000	0.000	0.000	\N	12	E11RRA010	2
311	0	0	Habitación 1	1	24.000	0.000	0.000	\N	12	E11RRA010	3
312	0	0	Habitación 2	1	16.000	0.000	0.000	\N	12	E11RRA010	4
313	0	0	Habitación 3	1	14.000	0.000	0.000	\N	12	E11RRA010	5
314	0	0	Pasillo	2	23.000	0.000	0.000	\N	12	E11RRA010	6
315	0	0	Aseo 1	1	4.000	3.000	0.000	\N	12	E11MB060	0
316	0	0	Aseo 2	1	4.000	3.000	0.000	\N	12	E11MB060	1
317	0	0	Terraza	1	6.000	3.000	0.000	\N	12	E11CTB020	0
318	0	0	Acceso	1	0.000	0.000	0.000	\N	13	E13EEB050	0
319	0	0	Dormitorios	3	0.000	0.000	0.000	\N	13	E13EPL080	0
320	0	0	Aseos	3	0.000	0.000	0.000	\N	13	E13EPL080	1
321	0	0	Salón	1	0.000	0.000	0.000	\N	13	E13EPL080	2
322	0	0	Cocina	1	0.000	0.000	0.000	\N	13	E13EPL080	3
323	0	0	Pasillo	2	0.000	0.000	0.000	\N	13	E13EPL080	4
324	0	0	Habitación 1	1	3.000	0.000	2.500	\N	13	E13MCL010	0
325	0	0	Habitación 2	1	2.000	0.000	2.500	\N	13	E13MCL010	1
326	0	0	Habitación 3	1	1.500	0.000	2.500	\N	13	E13MCL010	2
327	0	0	Ventanas	12	1.600	1.400	1.200	\N	14	E14PV030	0
328	0	0	Persianas	1	23.500	0.000	0.000	\N	14	E14PV010	0
329	0	0	Balcón	1	0.900	0.000	2.100	\N	14	E14ACP070	0
330	0	0	Ventanas	12	1.600	1.400	1.200	\N	14	E14ACV050	0
331	0	0	Varios	1	1.600	0.000	1.200	\N	15	E15CCH020	0
332	0	0	Cocina	1	1.650	0.000	0.950	\N	15	E14PS050	0
333	0	0	Chimenea	1	0.000	0.000	0.000	\N	15	E15WC020	0
334	0	0	Escalera interior	1	6.070	0.000	0.000	\N	15	E14ACD020	0
335	0	0	Terraza	1	4.200	0.000	0.000	\N	15	E15DBA060	0
336	0	0	Valla exterior	1	31.500	0.000	1.200	\N	15	E15DRA020	0
337	0	0	Acceso exterior	1	0.000	0.000	0.000	\N	15	E15VPM010	0
338	0	0	Ventanas	12	1.600	1.400	1.200	\N	16	E16ECA030	0
339	0	0	Salón	2	2.000	0.000	0.800	\N	16	E16ECA110	0
340	0	0	Cocina	1	0.700	0.000	1.700	\N	16	E16AMA010	0
341	0	0	Cocina	1	4.000	4.000	0.000	\N	17	E08TAE010	0
342	0	0	Aseo 1	1	3.000	3.000	0.000	\N	17	E08TAE010	1
343	0	0	Aseo 2	1	2.000	3.000	0.000	\N	17	E08TAE010	2
344	0	0	Pasillo	1	10.000	1.700	0.000	\N	17	E08TAE010	3
345	0	0	Habitación 1	1	3.000	0.000	2.500	\N	18	E27MB030	0
346	0	0	Habitación 2	1	2.000	0.000	2.500	\N	18	E27MB030	1
347	0	0	Habitación 3	1	1.500	0.000	2.500	\N	18	E27MB030	2
348	0	0	Puertas	14	0.900	0.000	2.100	\N	18	E27MB030	3
349	0	0	Puerta metálica	1	1.890	0.000	1.000	\N	18	E27HS030	0
350	0	0	Hall	1	3.000	2.000	0.000	\N	18	E27EPA020	0
351	0	0	Salón	1	9.000	6.000	0.000	\N	18	E27EPA020	1
352	0	0	Comedor	1	5.000	4.000	0.000	\N	18	E27EPA020	2
353	0	0	Habitación 1	1	5.000	4.000	0.000	\N	18	E27EPA020	3
354	0	0	Habitación 2	1	4.000	3.000	0.000	\N	18	E27EPA020	4
355	0	0	Habitación 3	1	4.000	3.000	0.000	\N	18	E27EPA020	5
356	0	0	Pasillo	1	23.000	2.000	0.000	\N	18	E27EPA020	6
357	0	0	Cocina	1	5.000	4.000	0.000	\N	18	E27EPA020	7
358	0	0	Aseo 1	1	4.000	3.000	0.000	\N	18	E27EPA020	8
359	0	0	Aseo 2	1	4.000	3.000	0.000	\N	18	E27EPA020	9
360	0	0	Distribuidor	1	23.380	0.000	2.700	\N	18	E27EEL030	0
361	0	0	Distribuidor	1	20.000	0.000	2.700	\N	18	E27EEL030	1
362	0	0	Salón	1	45.000	0.000	2.700	\N	18	E27EEL030	2
363	0	0	Salón	1	43.000	0.000	2.700	\N	18	E27EEL030	3
364	0	0	Comedor	1	26.000	0.000	2.700	\N	18	E27EEL030	4
365	0	0	Comedor	1	14.000	0.000	2.700	\N	18	E27EEL030	5
366	0	0	Hall	1	10.500	0.000	2.700	\N	18	E27EEL030	6
367	0	0	Hall	1	10.500	0.000	2.700	\N	18	E27EEL030	7
368	0	0	Esc. Baja	1	14.100	0.000	2.700	\N	18	E27EEL030	8
369	0	0	Esc. Baja	1	14.100	0.000	2.700	\N	18	E27EEL030	9
370	0	0	Dormitorio 1	1	12.000	0.000	2.700	\N	18	E27EEL030	10
371	0	0	Dormitorio 1	1	17.000	0.000	2.700	\N	18	E27EEL030	11
372	0	0	Dormitorio 2	1	13.360	0.000	2.700	\N	18	E27EEL030	12
373	0	0	Dormitorio 2	1	15.000	0.000	2.700	\N	18	E27EEL030	13
374	0	0	Dormitorio 3	1	13.160	0.000	2.700	\N	18	E27EEL030	14
375	0	0	Dormitorio 3	1	11.000	0.000	2.700	\N	18	E27EEL030	15
376	0	0	Valla exterior	1	80.000	0.000	1.200	\N	18	E27HET020	0
377	0	0	Electricidad	9	0.000	0.000	0.000	\N	19	E17MSC010	0
378	0	0	Electricidad	6	0.000	0.000	0.000	\N	19	E17MSC020	0
379	0	0	Electricidad	2	0.000	0.000	0.000	\N	19	E17MSC050	0
380	0	0	Electricidad	2	0.000	0.000	0.000	\N	19	E17MSC060	0
381	0	0	Electricidad	26	0.000	0.000	0.000	\N	19	E17MSB090	0
382	0	0	Electricidad	3	0.000	0.000	0.000	\N	19	E17BD100	0
383	0	0	Electricidad	2	0.000	0.000	0.000	\N	19	E18IRA030	0
384	0	0	Electricidad	9	0.000	0.000	0.000	\N	19	E18IMA010	0
385	0	0	Electricidad	4	0.000	0.000	0.000	\N	19	E18IDE010	0
386	0	0	Electricidad	4	0.000	0.000	0.000	\N	19	E18IDA120	0
387	0	0	Electricidad	1	44.720	0.000	0.000	\N	19	E17BD050	0
388	0	0	Electricidad	1	0.000	0.000	0.000	\N	19	E17CBL060	0
389	0	0	Electricidad	1	0.000	0.000	0.000	\N	19	E17BCM010	0
390	0	0	Electricidad	1	0.000	0.000	0.000	\N	19	E17CBL020	0
391	0	0	Electricidad	1	46.480	0.000	0.000	\N	19	E17CC010	0
392	0	0	Electricidad	1	46.480	0.000	0.000	\N	19	E17CC020	0
393	0	0	Electricidad	1	46.480	0.000	0.000	\N	19	E17CC030	0
394	0	0	Electricidad	1	46.480	0.000	0.000	\N	19	E17CC040	0
395	0	0	Electricidad	1	0.000	0.000	0.000	\N	19	E17BAP010	0
396	0	0	Electricidad	1	2.000	0.000	0.000	\N	19	E17BB005	0
397	0	0	Electricidad	1	7.000	0.000	0.000	\N	19	E17CI010	0
398	0	0	Electricidad	2	0.000	0.000	0.000	\N	19	E17BD020	0
399	0	0	Fontanería	1	0.000	0.000	0.000	\N	20	E03EUF020	0
400	0	0	Fontanería	1	30.000	0.000	0.000	\N	20	E20WJP070	0
401	0	0	Fontanería	1	49.900	0.000	0.000	\N	20	E20WNA050	0
402	0	0	Fontanería	1	0.000	0.000	0.000	\N	20	E21ABC010	0
403	0	0	Fontanería	2	0.000	0.000	0.000	\N	20	E21ABC060	0
404	0	0	Fontanería	1	0.000	0.000	0.000	\N	20	E21ADP020	0
405	0	0	Fontanería	3	0.000	0.000	0.000	\N	20	E21ALA060	0
406	0	0	Fontanería	1	0.000	0.000	0.000	\N	20	E21ATC020	0
407	0	0	Fontanería	1	0.000	0.000	0.000	\N	20	E21ALA050	0
408	0	0	Fontanería	4	0.000	0.000	0.000	\N	20	E21ANB010	0
409	0	0	Fontanería	1	0.000	0.000	0.000	\N	20	E21FA090	0
410	0	0	Fontanería	1	0.000	0.000	0.000	\N	20	E21MA020	0
411	0	0	Fontanería	10	0.000	0.000	0.000	\N	20	E20VF020	0
412	0	0	Fontanería	2	0.000	0.000	0.000	\N	20	E20VF030	0
413	0	0	Fontanería	1	0.000	0.000	0.000	\N	20	E20VF040	0
414	0	0	Fontanería	1	9.000	0.000	0.000	\N	20	E20WJF010	0
415	0	0	Fontanería	1	9.000	0.000	0.000	\N	20	E20WJF020	0
416	0	0	Fontanería	1	0.000	0.000	0.000	\N	20	E20XVC040	0
417	0	0	Fontanería	1	22.650	0.000	0.000	\N	20	E20TC020	0
418	0	0	Fontanería	1	3.100	0.000	0.000	\N	20	E20TC010	0
419	0	0	Fontanería	1	3.870	0.000	0.000	\N	20	E20TC030	0
420	0	0	Fontanería	1	2.320	0.000	0.000	\N	20	E20TC040	0
421	0	0	Fontanería	1	2.350	0.000	0.000	\N	20	E20TC050	0
422	0	0	Fontanería	1	0.000	0.000	0.000	\N	20	E20AL020	0
423	0	0	Fontanería	1	0.000	0.000	0.000	\N	20	E20CIR020	0
424	0	0	Colocación en terraza	1	0.000	0.000	0.000	\N	21	E22CF010	0
425	0	0	Calefacción	1	0.000	0.000	0.000	\N	21	E22DG030	0
426	0	0	Calefacción	1	7.000	0.000	0.000	\N	21	E22HC020	0
427	0	0	Calefacción	120	0.000	0.000	0.000	\N	21	E22SEL020	0
428	0	0	Calefacción	1	7.130	0.000	0.000	\N	21	E22NTC010	0
429	0	0	Calefacción	1	10.690	0.000	0.000	\N	21	E22NTC020	0
430	0	0	Calefacción	1	8.910	0.000	0.000	\N	21	E22NTC030	0
431	0	0	Calefacción	1	5.340	0.000	0.000	\N	21	E22NTC040	0
432	0	0	Calefacción	1	3.560	0.000	0.000	\N	21	E22NTC050	0
433	0	0	Calefacción	2	0.000	0.000	0.000	\N	21	E22NVE010	0
434	0	0	Calefacción	2	0.000	0.000	0.000	\N	21	E22NVE020	0
435	0	0	Colocado en salón	1	0.000	0.000	0.000	\N	21	E17DGC020	0
2	0	0	Planta	1	8.000	3.500	0.000	\N	01	E02AM010	1
\.


--
-- TOC entry 3163 (class 0 OID 16942)
-- Dependencies: 221
-- Data for Name: CENZANO_Relacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."CENZANO_Relacion" (id, codpadre, codhijo, canpres, cancert, posicion) FROM stdin;
0	\N	CENZANO	1.000	1.000	0
1	CENZANO	01	1.000	1.000	0
2	CENZANO	02	1.000	1.000	1
3	CENZANO	03	1.000	1.000	2
4	CENZANO	04	1.000	1.000	3
5	CENZANO	05	1.000	1.000	4
6	CENZANO	06	1.000	1.000	5
7	CENZANO	07	1.000	1.000	6
8	CENZANO	08	1.000	1.000	7
9	CENZANO	09	1.000	1.000	8
10	CENZANO	10	1.000	1.000	9
11	CENZANO	11	1.000	1.000	10
12	CENZANO	12	1.000	1.000	11
13	CENZANO	13	1.000	1.000	12
14	CENZANO	14	1.000	1.000	13
15	CENZANO	15	1.000	1.000	14
16	CENZANO	16	1.000	1.000	15
17	CENZANO	17	1.000	1.000	16
18	CENZANO	18	1.000	1.000	17
19	CENZANO	19	1.000	1.000	18
20	CENZANO	20	1.000	1.000	19
21	CENZANO	21	1.000	1.000	20
22	CENZANO	I	0.000	0.000	21
24	01	E02EM030	248.844	66.368	1
25	01	E02PM030	6.925	6.926	2
40	02	E03ALA010	3.000	3.000	0
26	01	E02TT040	168.000	168.000	3
27	01	E02CM060	0.000	0.000	4
28	E02AM010	O01OA070	0.005	0.005	0
29	E02AM010	M05PN010	0.010	0.010	1
30	E02EM030	O01OA070	0.125	0.125	0
31	E02EM030	M05EN030	0.250	0.250	1
32	E02PM030	O01OA070	0.130	0.130	0
33	E02PM030	M05EN030	0.260	0.260	1
34	E02TT040	M05EN030	0.040	0.040	0
35	E02TT040	M07CB030	0.190	0.190	1
36	E02TT040	M07N060	1.000	1.000	2
37	E02CM060	O01OA070	0.200	0.200	0
38	E02CM060	M05EN050	0.350	0.350	1
39	E02CM060	M05PN010	0.100	0.100	2
41	02	E03ALR020	1.000	1.000	1
42	02	E03ALR040	1.000	1.000	2
43	02	E03ALS020	1.000	1.000	3
44	02	E03ZLR010	1.000	1.000	4
45	02	E03OEH010	9.000	9.000	5
46	02	E03OEH020	1.930	1.930	6
47	02	E03OEH030	0.640	0.640	7
48	02	E03OEP005	12.900	12.900	8
49	02	E03OEP008	23.200	23.201	9
50	02	E03OEP130	12.900	12.900	10
51	02	E03OEP140	2.580	2.580	11
52	02	E03M010	1.000	1.000	12
53	E03ALA010	O01OA030	1.600	1.600	0
54	E03ALA010	O01OA060	0.800	0.800	1
55	E03ALA010	P01HM020	0.039	0.039	2
56	E03ALA010	P01LT020	0.045	0.045	3
57	E03ALA010	P01MC040	0.020	0.020	4
58	E03ALA010	P01MC010	0.015	0.015	5
59	E03ALA010	P02CVC010	1.000	1.000	6
60	E03ALA010	P02EAT020	1.000	1.000	7
61	E03ALR020	O01OA030	1.500	1.500	0
62	E03ALR020	O01OA060	0.750	0.750	1
63	E03ALR020	P01HM020	0.039	0.039	2
64	E03ALR020	P01LT020	0.045	0.045	3
65	E03ALR020	P01MC040	0.020	0.020	4
66	E03ALR020	P01MC010	0.015	0.015	5
67	E03ALR020	P03AM070	0.430	0.430	6
68	E03ALR020	P02EAT020	1.000	1.000	7
69	E03ALR040	O01OA030	1.700	1.700	0
70	E03ALR040	O01OA060	0.850	0.850	1
71	E03ALR040	P01HM020	0.058	0.058	2
72	E03ALR040	P01LT020	0.070	0.070	3
73	E03ALR040	P01MC040	0.035	0.035	4
74	E03ALR040	P01MC010	0.025	0.025	5
75	E03ALR040	P03AM070	0.570	0.570	6
76	E03ALR040	P02EAT030	1.000	1.000	7
77	E03ALS020	O01OA030	1.800	1.800	0
78	E03ALS020	O01OA060	0.900	0.900	1
79	E03ALS020	P01HM020	0.058	0.058	2
80	E03ALS020	P01LT020	0.070	0.070	3
81	E03ALS020	P01MC040	0.035	0.035	4
82	E03ALS020	P01MC010	0.025	0.025	5
83	E03ALS020	P02CVC400	1.000	1.000	6
84	E03ALS020	P02EAT030	1.000	1.000	7
85	E03ZLR010	O01OA030	3.800	3.800	0
86	E03ZLR010	O01OA060	2.500	2.500	1
87	E03ZLR010	P01HA020	0.135	0.135	2
88	E03ZLR010	P03AM070	1.350	1.350	3
89	E03ZLR010	P01LT020	0.250	0.250	4
90	E03ZLR010	P01MC040	0.125	0.125	5
91	E03ZLR010	P01MC010	0.045	0.045	6
92	E03ZLR010	P02EPW020	3.000	3.000	7
93	E03ZLR010	P02EPO010	1.000	1.000	8
94	E03OEH010	O01OA030	0.400	0.400	0
95	E03OEH010	O01OA060	0.400	0.400	1
96	E03OEH010	P01AA020	0.232	0.232	2
97	E03OEH010	P01LT020	0.004	0.004	3
98	E03OEH010	P01MC040	0.002	0.002	4
99	E03OEH010	P02THM010	1.000	1.000	5
100	E03OEH020	O01OA030	0.400	0.400	0
101	E03OEH020	O01OA060	0.400	0.400	1
102	E03OEH020	P01AA020	0.249	0.249	2
103	E03OEH020	P01LT020	0.004	0.004	3
104	E03OEH020	P01MC040	0.002	0.002	4
105	E03OEH020	P02THM020	1.000	1.000	5
106	E03OEH030	O01OA030	0.400	0.400	0
107	E03OEH030	O01OA060	0.400	0.400	1
108	E03OEH030	M05RN020	0.166	0.166	2
109	E03OEH030	P01AA020	0.329	0.329	3
110	E03OEH030	P01LT020	0.004	0.004	4
111	E03OEH030	P01MC040	0.002	0.002	5
112	E03OEH030	P02THM030	1.000	1.000	6
113	E03OEP005	O01OA030	0.050	0.050	0
114	E03OEP005	O01OA060	0.050	0.050	1
115	E03OEP005	P01AA020	0.205	0.205	2
23	01	E02AM010	64.000	61.520	0
116	E03OEP005	P02TVO310	1.000	1.000	3
117	E03OEP008	O01OA030	0.050	0.050	0
118	E03OEP008	O01OA060	0.050	0.050	1
119	E03OEP008	P01AA020	0.215	0.215	2
120	E03OEP008	P02TVO320	1.000	1.000	3
121	E03OEP130	O01OA030	0.100	0.100	0
122	E03OEP130	O01OA060	0.100	0.100	1
123	E03OEP130	P01AA020	0.232	0.232	2
124	E03OEP130	P02CVM010	0.160	0.160	3
125	E03OEP130	P02CVW010	0.003	0.003	4
126	E03OEP130	P02TVO100	1.000	1.000	5
127	E03OEP140	O01OA030	0.150	0.150	0
128	E03OEP140	O01OA060	0.150	0.150	1
129	E03OEP140	P01AA020	0.249	0.249	2
130	E03OEP140	P02CVM020	0.160	0.160	3
131	E03OEP140	P02CVW010	0.004	0.004	4
132	E03OEP140	P02TVO110	1.000	1.000	5
133	E03M010	O01OA040	0.750	0.750	0
134	E03M010	O01OA060	1.500	1.500	1
135	E03M010	M06CM010	1.000	1.000	2
136	E03M010	M06MI010	1.000	1.000	3
137	E03M010	E02ES020	7.195	7.198	4
138	E03M010	P02THE150	8.000	8.000	5
139	E03M010	P01HM020	0.720	0.720	6
140	03	E04CM040	1.235	1.236	0
141	03	E04CA060	5.994	5.996	1
143	03	E04SE020	108.000	108.000	3
152	04	E05HSA010	5.431	5.433	0
144	E04CM040	O01OA070	0.600	0.600	0
145	E04CM040	P01HM010	1.150	1.150	1
146	E04CA060	E04CA010	1.000	1.000	0
147	E04CA060	M02GT120	0.200	0.200	1
148	E04SA020	E04SE090	0.150	0.150	0
149	E04SA020	E04AM060	1.000	1.000	1
150	E04SE020	O01OA070	0.200	0.200	0
151	E04SE020	P01AG130	0.220	0.220	1
154	04	E05HVA075	7.200	7.203	2
153	04	E05HVA030	16.740	16.742	1
156	04	E05HLA070	0.900	0.900	4
155	04	E05HFA060	240.000	240.000	3
157	04	E05HFS160	124.230	124.231	5
158	04	E05AW020	28.700	28.701	6
196	05	E07LSB040	252.756	252.766	0
159	04	E05AW040	44.000	44.000	7
160	E05HSA010	E05HSM010	1.000	1.000	0
161	E05HSA010	E05HSF010	13.330	13.330	1
162	E05HSA010	E04AB020	80.000	80.000	2
163	E05HVA030	E05HVM010	1.000	1.000	0
164	E05HVA030	E05HVE010	12.150	12.150	1
165	E05HVA030	E04AB020	150.000	150.000	2
166	E05HVA075	E05HVM030	1.000	1.000	0
167	E05HVA075	E05HVE030	13.500	13.500	1
168	E05HVA075	E04AB020	75.000	75.000	2
169	E05HFA060	O01OB010	0.450	0.450	0
170	E05HFA060	O01OB020	0.450	0.450	1
171	E05HFA060	P03VA030	2.800	2.800	2
172	E05HFA060	P03BC070	5.000	5.000	3
173	E05HFA060	P01HA010	0.100	0.100	4
174	E05HFA060	E04AB020	2.500	2.500	5
175	E05HFA060	E05HFE010	1.000	1.000	6
176	E05HLA070	E05HLM020	1.000	1.000	0
177	E05HLA070	E05HLE020	10.000	10.000	1
178	E05HLA070	E04AB020	100.000	100.000	2
179	E05HFS160	O01OB010	0.200	0.200	0
180	E05HFS160	O01OB020	0.200	0.200	1
181	E05HFS160	P03VS020	1.550	1.550	2
182	E05HFS160	P03BP010	3.000	3.000	3
183	E05HFS160	P01HA010	0.063	0.063	4
184	E05HFS160	E04AB020	1.500	1.500	5
185	E05HFS160	E05HFE010	1.000	1.000	6
186	E05AW020	O01OB130	0.300	0.300	0
187	E05AW020	O01OB140	0.300	0.300	1
188	E05AW020	P13TC010	8.300	8.300	2
189	E05AW020	P03AL005	2.856	2.856	3
190	E05AW020	P25OU080	0.120	0.120	4
191	E05AW040	O01OB130	0.500	0.500	0
192	E05AW040	P03AL005	7.090	7.090	1
193	E05AW040	P25OU080	0.200	0.200	2
194	E05AW040	P25JM010	0.200	0.200	3
195	E05AW040	P01DW090	1.500	1.500	4
202	06	E07TBL190	65.610	65.615	1
197	E07LSB040	O01OB050	1.660	1.660	0
198	E07LSB040	O01OB060	0.830	0.830	1
199	E07LSB040	P01LV105	0.136	0.136	2
200	E07LSB040	A02A080	0.060	0.060	3
201	06	E07TBL010	154.575	154.591	0
205	06	E07WP010	17.600	17.601	4
203	06	E07LP013	71.010	71.014	2
204	06	E07TBL011	181.575	181.595	3
206	06	E07TRE010	10.270	10.271	5
207	06	E07TRW070	6.070	6.071	6
208	06	E12PVA010	23.500	23.500	7
209	06	E07TRC010	18.750	18.750	8
210	06	E07TRC030	36.000	36.000	9
211	06	E07TRP020	27.000	27.000	10
212	06	E07TRP010	20.000	20.000	11
213	06	E07TRE020	3.600	3.600	12
214	06	E12PCC040	12.000	12.000	13
215	06	E07WF010	6.000	6.000	14
216	06	E07TRW020	2.000	2.000	15
217	06	E07WA020	1.000	1.000	16
218	06	E07WA010	1.000	1.000	17
219	06	E07WA030	1.000	1.000	18
220	E07TBL010	O01OA030	0.380	0.380	0
221	E07TBL010	O01OA070	0.190	0.190	1
222	E07TBL010	P01LH010	0.035	0.035	2
223	E07TBL010	A02A080	0.008	0.008	3
224	E07TBL190	O01OA030	0.430	0.430	0
225	E07TBL190	O01OA070	0.215	0.215	1
226	E07TBL190	P01LH050	0.025	0.025	2
227	E07TBL190	A02A080	0.018	0.018	3
228	E07LP013	O01OA030	0.410	0.410	0
229	E07LP013	O01OA070	0.205	0.205	1
142	03	E04SA020	108.000	108.000	2
230	E07LP013	P01LT020	0.052	0.052	2
231	E07LP013	A02A080	0.025	0.025	3
232	E07TBL011	O01OA030	0.330	0.330	0
233	E07TBL011	O01OA070	0.165	0.165	1
234	E07TBL011	P01LH010	0.035	0.035	2
235	E07TBL011	A02A080	0.008	0.008	3
236	E07WP010	O01OA030	0.400	0.400	0
237	E07WP010	O01OA050	0.400	0.400	1
238	E07WP010	P01LH020	0.018	0.018	2
239	E07WP010	A02A080	0.010	0.010	3
240	E07WP010	P01DW050	0.008	0.008	4
241	E07TRE010	O01OA030	0.350	0.350	0
242	E07TRE010	O01OA050	0.350	0.350	1
243	E07TRE010	A02A060	0.004	0.004	2
244	E07TRW070	O01OA030	0.250	0.250	0
245	E07TRW070	A01A030	0.010	0.010	1
246	E07TRW070	P01UC030	0.300	0.300	2
247	E12PVA010	O01OA030	0.350	0.350	0
248	E12PVA010	O01OA070	0.350	0.350	1
249	E12PVA010	P10VA010	1.000	1.000	2
250	E12PVA010	A02A080	0.005	0.005	3
251	E07TRC010	O01OA030	0.200	0.200	0
252	E07TRC010	O01OA050	0.200	0.200	1
253	E07TRC010	A01A030	0.005	0.005	2
254	E07TRC010	P01UC030	0.120	0.120	3
255	E07TRC030	O01OA030	0.320	0.320	0
256	E07TRC030	O01OA050	0.320	0.320	1
257	E07TRC030	A01A030	0.030	0.030	2
258	E07TRC030	A02A060	0.006	0.006	3
259	E07TRC030	P01UC030	0.120	0.120	4
260	E07TRP020	O01OA030	0.540	0.540	0
261	E07TRP020	O01OA050	0.540	0.540	1
262	E07TRP020	A01A030	0.010	0.010	2
263	E07TRP020	P01UC030	0.120	0.120	3
264	E07TRP010	O01OA030	0.480	0.480	0
265	E07TRP010	O01OA050	0.480	0.480	1
266	E07TRP010	A01A030	0.012	0.012	2
267	E07TRP010	P01UC030	0.120	0.120	3
268	E07TRE020	O01OA030	0.800	0.800	0
269	E07TRE020	O01OA050	0.800	0.800	1
270	E07TRE020	A02A060	0.008	0.008	2
271	E12PCC040	O01OA030	0.320	0.320	0
272	E12PCC040	O01OA050	0.320	0.320	1
273	E12PCC040	A01A030	0.030	0.030	2
274	E12PCC040	P01LH010	0.035	0.035	3
275	E07WF010	O01OA030	0.400	0.400	0
276	E07WF010	O01OA050	0.400	0.400	1
277	E07WF010	P01LH010	0.052	0.052	2
278	E07WF010	A02A080	0.015	0.015	3
279	E07WF010	A01A030	0.010	0.010	4
280	E07TRW020	O01OA030	2.500	2.500	0
281	E07TRW020	O01OA050	2.500	2.500	1
282	E07TRW020	P01LH010	0.030	0.030	2
283	E07TRW020	A02A060	0.008	0.008	3
284	E07WA020	P01WA010	0.080	0.080	0
285	E07WA010	P01WA010	0.250	0.250	0
286	E07WA030	P01WA010	0.150	0.150	0
302	08	E10ATP180	110.000	110.000	0
288	07	E09IWA030	44.800	44.802	1
289	E09ICX030	O01OA030	0.320	0.320	0
290	E09ICX030	O01OA050	0.320	0.320	1
291	E09ICX030	P05TM020	13.500	13.500	2
292	E09ICX030	P05TM060	0.050	0.050	3
293	E09ICX030	P05TM072	0.050	0.050	4
294	E09ICX030	P05TM080	0.770	0.770	5
295	E09ICX030	A02A090	0.020	0.020	6
296	E09IWA030	O01OA030	0.780	0.780	0
297	E09IWA030	O01OA050	0.780	0.780	1
298	E09IWA030	P05NH010	1.000	1.000	2
299	E09IWA030	P01LG090	4.000	4.000	3
300	E09IWA030	A03H090	0.030	0.030	4
301	E09IWA030	A02A040	0.020	0.020	5
304	08	E10ATT070	100.000	100.000	2
303	08	E10AAR009	210.000	210.000	1
306	08	E10AKV010	40.570	40.570	4
305	08	E10ATV360	181.575	181.595	3
307	08	E10AKV060	25.840	25.841	5
308	08	E10AKV120	8.710	8.711	6
332	09	E10INR090	22.000	22.000	0
309	E10ATP180	O01OA030	0.050	0.050	0
310	E10ATP180	O01OA050	0.050	0.050	1
311	E10ATP180	P07TX190	1.050	1.050	2
312	E10AAR009	O01OA030	0.100	0.100	0
313	E10AAR009	O01OA050	0.100	0.100	1
314	E10AAR009	P07AL080	1.100	1.100	2
315	E10ATT070	O01OA030	0.100	0.100	0
316	E10ATT070	O01OA060	0.100	0.100	1
317	E10ATT070	P07TC010	1.050	1.050	2
318	E10ATT070	P07W230	7.000	7.000	3
319	E10ATT070	A01A030	0.005	0.005	4
320	E10ATV360	O01OA030	0.050	0.050	0
321	E10ATV360	O01OA050	0.050	0.050	1
322	E10ATV360	P07TX520	1.050	1.050	2
323	E10AKV010	O01OA050	0.150	0.150	0
324	E10AKV010	P07CV010	1.050	1.050	1
325	E10AKV010	A01A020	0.001	0.001	2
326	E10AKV060	O01OA050	0.200	0.200	0
327	E10AKV060	P07CV080	1.050	1.050	1
328	E10AKV060	A01A020	0.001	0.001	2
329	E10AKV120	O01OA050	0.240	0.240	0
330	E10AKV120	P07CV160	1.050	1.050	1
331	E10AKV120	A01A020	0.001	0.001	2
333	09	E10INX010	4.800	4.801	1
334	09	E10IAW049	44.750	44.750	2
335	09	E10INL060	14.400	14.400	3
336	E10INR090	O01OA030	0.160	0.160	0
337	E10INR090	O01OA050	0.160	0.160	1
338	E10INR090	P06BI037	2.500	2.500	2
339	E10INX010	O01OA050	0.125	0.125	0
340	E10INX010	P06SR020	1.000	1.000	1
341	E10IAW049	O01OA030	0.120	0.120	0
342	E10IAW049	O01OA050	0.120	0.120	1
343	E10IAW049	P06BI036	0.150	0.150	2
344	E10IAW049	P06BS500	0.500	0.500	3
345	E10IAW049	P06BS610	0.500	0.500	4
346	E10INL060	O01OA030	0.120	0.120	0
347	E10INL060	O01OA050	0.120	0.120	1
348	E10INL060	P06SL310	1.050	1.050	2
349	E10INL060	P06SI100	0.060	0.060	3
352	10	E08PFM081	4.590	4.591	2
351	10	E08PEM010	883.662	883.680	1
366	11	E12AC220	6.000	6.000	2
353	E08PFA020	O01OA030	0.190	0.190	0
354	E08PFA020	O01OA050	0.095	0.095	1
355	E08PFA020	A02A080	0.020	0.020	2
356	E08PEM010	O01OB110	0.600	0.600	0
357	E08PEM010	O01OA070	0.050	0.050	1
358	E08PEM010	A01A030	0.012	0.012	2
359	E08PEM010	A01A040	0.003	0.003	3
360	E08PEM010	P04RW060	0.215	0.215	4
361	E08PFM081	O01OA030	0.540	0.540	0
362	E08PFM081	O01OA050	0.270	0.270	1
363	E08PFM081	A02S020	0.020	0.020	2
364	11	E12AC101	66.540	66.546	0
365	11	E12AC180	30.000	30.000	1
367	11	E12PNM010	2.000	2.000	3
387	12	E11EXB030	20.000	20.000	0
368	E12AC101	O01OB090	0.300	0.300	0
369	E12AC101	O01OA070	0.300	0.300	1
370	E12AC101	P09ABC101	1.050	1.050	2
371	E12AC101	A02A140	0.020	0.020	3
372	E12AC101	A01L090	0.001	0.001	4
373	E12AC180	O01OB090	0.150	0.150	0
374	E12AC180	O01OA070	0.010	0.010	1
375	E12AC180	P09ABC180	1.050	1.050	2
376	E12AC180	A02A140	0.001	0.001	3
377	E12AC180	A01L090	0.001	0.001	4
378	E12AC220	O01OB090	0.150	0.150	0
379	E12AC220	O01OA070	0.010	0.010	1
380	E12AC220	P09ABC220	1.050	1.050	2
381	E12AC220	A02A140	0.002	0.002	3
382	E12AC220	A01L090	0.001	0.001	4
383	E12PNM010	O01OB070	0.970	0.970	0
384	E12PNM010	O01OB080	0.970	0.970	1
385	E12PNM010	P09EM010	1.000	1.000	2
386	E12PNM010	P09ED030	1.000	1.000	3
388	12	E11EXP220	24.000	24.000	1
389	12	E11EXP012	17.600	17.601	2
391	12	E11RAM050	170.000	170.000	4
390	12	E11EXP212	6.000	6.000	3
392	12	E11RRA010	197.000	197.000	5
394	12	E11CTB020	18.000	18.000	7
393	12	E11MB060	24.000	24.000	6
443	13	E13EEB050	1.000	1.000	0
395	E11EXB030	O01OB090	0.450	0.450	0
396	E11EXB030	O01OA070	0.450	0.450	1
397	E11EXB030	P01AA020	0.020	0.020	2
398	E11EXB030	P08EXB030	1.050	1.050	3
399	E11EXB030	P08EXP215	1.050	1.050	4
400	E11EXB030	A02A080	0.030	0.030	5
401	E11EXB030	P01CC020	0.001	0.001	6
402	E11EXB030	A01L020	0.001	0.001	7
403	E11EXP220	O01OB090	0.100	0.100	0
404	E11EXP220	O01OA070	0.100	0.100	1
405	E11EXP220	P08EXP220	1.050	1.050	2
406	E11EXP220	A02A080	0.001	0.001	3
407	E11EXP220	A01L020	0.001	0.001	4
408	E11EXP012	O01OB090	0.350	0.350	0
409	E11EXP012	O01OA070	0.350	0.350	1
410	E11EXP012	P08EXP012	1.100	1.100	2
411	E11EXP012	P08EXP013	1.100	1.100	3
412	E11EXP012	A02A080	0.015	0.015	4
413	E11EXP012	A01L020	0.001	0.001	5
414	E11EXP212	O01OB090	0.100	0.100	0
415	E11EXP212	O01OA070	0.100	0.100	1
416	E11EXP212	P08EXP212	1.050	1.050	2
417	E11EXP212	A02A080	0.001	0.001	3
418	E11EXP212	A01L020	0.001	0.001	4
419	E11RAM050	O01OB150	0.450	0.450	0
420	E11RAM050	O01OA070	0.450	0.450	1
421	E11RAM050	P08MQ010	1.050	1.050	2
422	E11RAM050	P08MR160	1.150	1.150	3
423	E11RAM050	P08MA010	1.100	1.100	4
424	E11RAM050	E11RT010	1.000	1.000	5
425	E11RAM050	E11CCC050	1.000	1.000	6
426	E11RRA010	O01OB150	0.100	0.100	0
427	E11RRA010	P08MR080	1.050	1.050	1
428	E11MB060	O01OB070	0.380	0.380	0
429	E11MB060	O01OA070	0.380	0.380	1
430	E11MB060	P08AB060	1.000	1.000	2
431	E11MB060	A02A140	0.030	0.030	3
432	E11MB060	P01AA020	0.020	0.020	4
433	E11MB060	A01L090	0.001	0.001	5
434	E11MB060	P01CC120	0.001	0.001	6
435	E11MB060	P08AW010	1.000	1.000	7
436	E11CTB020	O01OB090	0.300	0.300	0
437	E11CTB020	O01OA070	0.300	0.300	1
438	E11CTB020	P08TB020	1.050	1.050	2
439	E11CTB020	A02A140	0.025	0.025	3
440	E11CTB020	P01AA020	0.020	0.020	4
441	E11CTB020	A01L090	0.001	0.001	5
442	E11CTB020	P01CC120	0.001	0.001	6
444	13	E13EPL080	10.000	10.000	1
445	13	E13MCL010	16.250	16.250	2
446	E13EEB050	O01OB150	2.600	2.600	0
447	E13EEB050	O01OB160	2.600	2.600	1
448	E13EEB050	E13CS030	1.000	1.000	2
449	E13EEB050	P11PM090	5.500	5.500	3
450	E13EEB050	P11TM090	11.000	11.000	4
451	E13EEB050	P11ER050	1.000	1.000	5
452	E13EEB050	P11EB060	1.000	1.000	6
453	E13EEB050	P11HB030	4.000	4.000	7
454	E13EEB050	P11HS060	1.000	1.000	8
455	E13EEB050	P11HT020	1.000	1.000	9
456	E13EEB050	P11HM020	1.000	1.000	10
457	E13EEB050	P11KW060	5.500	5.500	11
458	E13EEB050	P11WA010	1.000	1.000	12
459	E13EPL080	O01OB150	1.400	1.400	0
460	E13EPL080	O01OB160	1.400	1.400	1
461	E13EPL080	E13CD010	1.000	1.000	2
462	E13EPL080	P11PR040	6.000	6.000	3
463	E13EPL080	P11TL040	12.000	12.000	4
464	E13EPL080	P11CH020	2.000	2.000	5
465	E13EPL080	P11RB040	6.000	6.000	6
466	E13EPL080	P11WP080	36.000	36.000	7
467	E13EPL080	P11RP010	1.000	1.000	8
468	E13EPL080	P11RW030	2.000	2.000	9
469	E13EPL080	P11WA020	2.000	2.000	10
470	E13MCL010	O01OB150	1.000	1.000	0
471	E13MCL010	O01OB160	1.000	1.000	1
472	E13MCL010	P11PD010	5.800	5.800	2
473	E13MCL010	P11TR010	2.200	2.200	3
474	E13MCL010	P11TM100	2.200	2.200	4
475	E13MCL010	P11AH040	0.750	0.750	5
476	E13MCL010	P11AH080	0.750	0.750	6
477	E13MCL010	P11JW100	1.500	1.500	7
478	E13MCL010	P11JW115	2.550	2.550	8
479	E13MCL010	P11RW060	2.550	2.550	9
480	E13MCL010	P11WH100	1.500	1.500	10
481	E13MCL010	P11WP080	3.000	3.000	11
483	14	E14PV010	23.500	23.500	1
484	14	E14ACP070	1.890	1.890	2
485	14	E14ACV050	32.256	32.257	3
499	15	E15CCH020	1.920	1.921	0
486	E14PV030	O01OB130	0.425	0.425	0
487	E14PV030	P12PX060	1.100	1.100	1
488	E14PV010	O01OB130	0.300	0.300	0
489	E14PV010	O01OB140	0.150	0.150	1
490	E14PV010	P12PX010	1.000	1.000	2
491	E14ACP070	O01OB130	0.260	0.260	0
492	E14ACP070	O01OB140	0.130	0.130	1
493	E14ACP070	P12PW010	4.000	4.000	2
494	E14ACP070	P12ACP100	1.000	1.000	3
495	E14ACV050	O01OB130	0.240	0.240	0
496	E14ACV050	O01OB140	0.120	0.120	1
497	E14ACV050	P12PW010	4.000	4.000	2
498	E14ACV050	P12ACV160	1.000	1.000	3
500	15	E14PS050	1.568	1.568	1
501	15	E15WC020	1.000	1.000	2
502	15	E14ACD020	6.070	6.071	3
503	15	E15DBA060	4.200	4.200	4
504	15	E15DRA020	37.800	37.801	5
505	15	E15VPM010	1.000	1.000	6
532	16	E16ECA030	32.256	32.257	0
506	E15CCH020	O01OB140	0.200	0.200	0
507	E15CCH020	P13CC020	5.000	5.000	1
508	E14PS050	O01OB130	0.350	0.350	0
509	E14PS050	O01OB140	0.350	0.350	1
510	E14PS050	P12PL050	1.000	1.000	2
511	E15WC020	O01OA030	0.580	0.580	0
512	E15WC020	O01OB130	3.000	3.000	1
513	E15WC020	O01OB140	0.340	0.340	2
514	E15WC020	P13TT130	14.400	14.400	3
515	E15WC020	P13TT140	3.000	3.000	4
516	E15WC020	P13TC060	0.400	0.400	5
517	E15WC020	A02A060	0.008	0.008	6
518	E15WC020	E27HS030	1.000	1.000	7
519	E14ACD020	O01OA030	0.100	0.100	0
520	E14ACD020	O01OB130	0.500	0.500	1
521	E14ACD020	O01OB140	0.500	0.500	2
522	E14ACD020	P12ACD030	1.000	1.000	3
523	E15DBA060	O01OB130	0.300	0.300	0
524	E15DBA060	O01OB140	0.300	0.300	1
525	E15DBA060	P13BT060	1.000	1.000	2
526	E15DRA020	O01OB130	0.300	0.300	0
527	E15DRA020	O01OB140	0.300	0.300	1
528	E15DRA020	P13DR020	1.000	1.000	2
529	E15VPM010	O01OB130	1.000	1.000	0
530	E15VPM010	O01OB140	1.000	1.000	1
531	E15VPM010	P13VP210	1.000	1.000	2
533	16	E16ECA110	3.200	3.201	1
534	16	E16AMA010	1.190	1.191	2
554	18	E27HS030	1.890	1.890	1
535	E16ECA030	O01OB250	0.200	0.200	0
536	E16ECA030	P14ECA030	1.006	1.006	1
537	E16ECA030	P14KW060	7.000	7.000	2
538	E16ECA030	P01DW090	1.500	1.500	3
539	E16ECA110	O01OB250	0.200	0.200	0
540	E16ECA110	P14ECA110	1.006	1.006	1
541	E16ECA110	P14KW060	7.000	7.000	2
542	E16ECA110	P01DW090	1.500	1.500	3
543	E16AMA010	O01OB250	0.430	0.430	0
544	E16AMA010	P14CI010	1.012	1.012	1
545	E16AMA010	P14KW060	3.500	3.500	2
546	17	E08TAE010	48.000	48.000	0
547	E08TAE010	O01OB110	0.320	0.320	0
548	E08TAE010	O01OB120	0.320	0.320	1
549	E08TAE010	O01OA070	0.050	0.050	2
550	E08TAE010	P04TE010	1.100	1.100	3
551	E08TAE010	P04TS010	0.220	0.220	4
552	E08TAE010	A01A020	0.005	0.005	5
553	18	E27MB030	42.710	42.710	0
557	18	E27HET020	96.000	96.000	4
555	18	E27EPA020	214.000	214.000	2
556	18	E27EEL030	815.670	815.679	3
558	E27MB030	O01OB230	0.250	0.250	0
559	E27MB030	O01OB240	0.250	0.250	1
560	E27MB030	P25MB010	0.250	0.250	2
561	E27MB030	P25WW220	0.050	0.050	3
562	E27HS030	O01OB230	0.350	0.350	0
563	E27HS030	O01OB240	0.350	0.350	1
564	E27HS030	P25OU020	0.200	0.200	2
565	E27HS030	P25JM010	0.300	0.300	3
566	E27HS030	P25WW220	0.100	0.100	4
567	E27EPA020	O01OB230	0.160	0.160	0
568	E27EPA020	O01OB240	0.160	0.160	1
569	E27EPA020	P25OZ040	0.070	0.070	2
482	14	E14PV030	32.256	32.257	0
570	E27EPA020	P25OG040	0.060	0.060	3
571	E27EPA020	P25EI020	0.300	0.300	4
572	E27EPA020	P25WW220	0.200	0.200	5
573	E27EEL030	O01OB230	0.055	0.055	0
574	E27EEL030	O01OB240	0.055	0.055	1
575	E27EEL030	P25CT040	0.500	0.500	2
576	E27EEL030	P25CT020	0.050	0.050	3
577	E27EEL030	P25WW220	0.500	0.500	4
578	E27HET020	O01OB230	0.060	0.060	0
579	E27HET020	P25OU050	0.050	0.050	1
580	E27HET020	P25JA080	0.025	0.025	2
581	E27HET020	P25WW220	0.080	0.080	3
583	19	E17MSC020	6.000	6.000	1
584	19	E17MSC050	2.000	2.000	2
585	19	E17MSC060	2.000	2.000	3
586	19	E17MSB090	26.000	26.000	4
587	19	E17BD100	3.000	3.000	5
588	19	E18IRA030	2.000	2.000	6
589	19	E18IMA010	9.000	9.000	7
590	19	E18IDE010	4.000	4.000	8
591	19	E18IDA120	4.000	4.000	9
592	19	E17BD050	44.720	44.721	10
593	19	E17CBL060	1.000	1.000	11
594	19	E17BCM010	1.000	1.000	12
595	19	E17CBL020	1.000	1.000	13
596	19	E17CC010	46.480	46.480	14
597	19	E17CC020	46.480	46.480	15
598	19	E17CC030	46.480	46.480	16
599	19	E17CC040	46.480	46.480	17
600	19	E17BAP010	1.000	1.000	18
601	19	E17BB005	2.000	2.000	19
602	19	E17CI010	7.000	7.000	20
603	19	E17BD020	2.000	2.000	21
604	E17MSC010	O01OB200	0.400	0.400	0
605	E17MSC010	O01OB220	0.400	0.400	1
606	E17MSC010	P15GB010	8.000	8.000	2
607	E17MSC010	P15GA010	16.000	16.000	3
608	E17MSC010	P15GK050	1.000	1.000	4
609	E17MSC010	P15MSC010	1.000	1.000	5
610	E17MSC010	P01DW090	1.000	1.000	6
611	E17MSC020	O01OB200	0.500	0.500	0
612	E17MSC020	O01OB220	0.500	0.500	1
613	E17MSC020	P15GB010	13.000	13.000	2
614	E17MSC020	P15GA010	39.000	39.000	3
615	E17MSC020	P15GK050	1.000	1.000	4
616	E17MSC020	P15MSC020	2.000	2.000	5
617	E17MSC020	P01DW090	1.000	1.000	6
618	E17MSC050	O01OB200	0.700	0.700	0
619	E17MSC050	O01OB220	0.700	0.700	1
620	E17MSC050	P15GB010	26.000	26.000	2
621	E17MSC050	P15GA010	78.000	78.000	3
622	E17MSC050	P15GK050	1.000	1.000	4
623	E17MSC050	P15MSC060	2.000	2.000	5
624	E17MSC050	P01DW090	1.000	1.000	6
625	E17MSC060	O01OB200	0.400	0.400	0
626	E17MSC060	O01OB220	0.400	0.400	1
627	E17MSC060	P15GB010	6.000	6.000	2
628	E17MSC060	P15GA010	12.000	12.000	3
629	E17MSC060	P15GK050	1.000	1.000	4
630	E17MSC060	P15MSC040	1.000	1.000	5
631	E17MSC060	P15MW010	1.000	1.000	6
632	E17MSC060	P01DW090	1.000	1.000	7
633	E17MSB090	O01OB200	0.450	0.450	0
634	E17MSB090	O01OB220	0.450	0.450	1
635	E17MSB090	P15GB010	6.000	6.000	2
636	E17MSB090	P15GA020	18.000	18.000	3
637	E17MSB090	P15GK050	1.000	1.000	4
638	E17MSB090	P15MSB070	1.000	1.000	5
639	E17MSB090	P01DW090	1.000	1.000	6
640	E17BD100	O01OB200	0.750	0.750	0
641	E17BD100	O01OB220	0.750	0.750	1
642	E17BD100	P15GA030	6.000	6.000	2
643	E17BD100	P01DW090	1.000	1.000	3
644	E18IRA030	O01OB200	0.300	0.300	0
645	E18IRA030	O01OB220	0.300	0.300	1
646	E18IRA030	P16BA030	1.000	1.000	2
647	E18IRA030	P16CC090	1.000	1.000	3
648	E18IRA030	P01DW090	1.000	1.000	4
649	E18IMA010	O01OB200	0.400	0.400	0
650	E18IMA010	O01OB220	0.400	0.400	1
651	E18IMA010	P16BE010	1.000	1.000	2
652	E18IMA010	P16CC080	2.000	2.000	3
653	E18IMA010	P01DW090	1.000	1.000	4
654	E18IDE010	O01OB200	0.300	0.300	0
655	E18IDE010	P16BI010	1.000	1.000	1
656	E18IDE010	P16CA030	1.000	1.000	2
657	E18IDE010	P01DW090	1.000	1.000	3
658	E18IDA120	O01OB200	0.300	0.300	0
659	E18IDA120	P16BK120	1.000	1.000	1
660	E18IDA120	P16CC010	2.000	2.000	2
661	E18IDA120	P01DW090	1.000	1.000	3
662	E17BD050	O01OB200	0.100	0.100	0
663	E17BD050	O01OB220	0.100	0.100	1
664	E17BD050	P15EB010	1.000	1.000	2
665	E17BD050	P01DW090	1.000	1.000	3
666	E17CBL060	O01OB200	0.150	0.150	0
667	E17CBL060	P15FA010	1.000	1.000	1
668	E17CBL060	P01DW090	1.000	1.000	2
669	E17BCM010	O01OB200	0.250	0.250	0
670	E17BCM010	P15DB010	1.000	1.000	1
671	E17BCM010	P01DW090	1.000	1.000	2
672	E17CBL020	O01OB200	0.600	0.600	0
673	E17CBL020	P15FB200	1.000	1.000	1
674	E17CBL020	P15FE100	2.000	2.000	2
675	E17CBL020	P15FD020	2.000	2.000	3
676	E17CBL020	P15FE010	1.000	1.000	4
677	E17CBL020	P15FE020	3.000	3.000	5
678	E17CBL020	P15FE030	1.000	1.000	6
679	E17CBL020	P15FE040	3.000	3.000	7
680	E17CBL020	P01DW090	1.000	1.000	8
681	E17CC010	O01OB200	0.150	0.150	0
682	E17CC010	O01OB210	0.150	0.150	1
683	E17CC010	P15GB010	1.000	1.000	2
684	E17CC010	P15GA010	2.000	2.000	3
582	19	E17MSC010	9.000	9.000	0
685	E17CC010	P01DW090	1.000	1.000	4
686	E17CC020	O01OB200	0.150	0.150	0
687	E17CC020	O01OB210	0.150	0.150	1
688	E17CC020	P15GB020	1.000	1.000	2
689	E17CC020	P15GA020	3.000	3.000	3
690	E17CC020	P01DW090	1.000	1.000	4
691	E17CC030	O01OB200	0.200	0.200	0
692	E17CC030	O01OB210	0.200	0.200	1
693	E17CC030	P15GB020	1.000	1.000	2
694	E17CC030	P15GA030	3.000	3.000	3
695	E17CC030	P01DW090	1.000	1.000	4
696	E17CC040	O01OB200	0.250	0.250	0
697	E17CC040	O01OB210	0.250	0.250	1
698	E17CC040	P15GB020	1.000	1.000	2
699	E17CC040	P15GA040	3.000	3.000	3
700	E17CC040	P01DW090	1.000	1.000	4
701	E17BAP010	O01OB200	0.500	0.500	0
702	E17BAP010	O01OB220	0.500	0.500	1
703	E17BAP010	P15CA010	1.000	1.000	2
704	E17BAP010	P01DW090	1.000	1.000	3
705	E17BB005	O01OB200	0.200	0.200	0
706	E17BB005	O01OB210	0.200	0.200	1
707	E17BB005	P15GC030	1.000	1.000	2
708	E17BB005	P15AE080	1.000	1.000	3
709	E17BB005	P01DW090	1.000	1.000	4
710	E17CI010	O01OB200	0.250	0.250	0
711	E17CI010	O01OB210	0.250	0.250	1
712	E17CI010	P15AI370	3.000	3.000	2
713	E17CI010	P15AI340	1.000	1.000	3
714	E17CI010	P15GD020	1.000	1.000	4
715	E17CI010	P01DW090	1.000	1.000	5
716	E17BD020	O01OB200	1.000	1.000	0
717	E17BD020	O01OB220	1.000	1.000	1
718	E17BD020	P15EA010	1.000	1.000	2
719	E17BD020	P15EB010	20.000	20.000	3
720	E17BD020	P15ED030	1.000	1.000	4
721	E17BD020	P15EC010	1.000	1.000	5
722	E17BD020	P15EC020	1.000	1.000	6
723	E17BD020	P01DW090	1.000	1.000	7
725	20	E20WJP070	30.000	30.000	1
726	20	E20WNA050	49.900	49.901	2
727	20	E21ABC010	1.000	1.000	3
728	20	E21ABC060	2.000	2.000	4
729	20	E21ADP020	1.000	1.000	5
730	20	E21ALA060	3.000	3.000	6
731	20	E21ATC020	1.000	1.000	7
732	20	E21ALA050	1.000	1.000	8
733	20	E21ANB010	4.000	4.000	9
734	20	E21FA090	1.000	1.000	10
735	20	E21MA020	1.000	1.000	11
736	20	E20VF020	10.000	10.000	12
737	20	E20VF030	2.000	2.000	13
738	20	E20VF040	1.000	1.000	14
739	20	E20WJF010	9.000	9.000	15
740	20	E20WJF020	9.000	9.000	16
741	20	E20XVC040	1.000	1.000	17
742	20	E20TC020	22.650	22.650	18
743	20	E20TC010	3.100	3.100	19
744	20	E20TC030	3.870	3.870	20
745	20	E20TC040	2.320	2.320	21
746	20	E20TC050	2.350	2.350	22
747	20	E20AL020	1.000	1.000	23
748	20	E20CIR020	1.000	1.000	24
749	E03EUF020	O01OB170	0.310	0.310	0
750	E03EUF020	O01OB180	0.155	0.155	1
751	E03EUF020	P02EDF010	1.000	1.000	2
752	E03EUF020	P01DW090	1.000	1.000	3
753	E20WJP070	O01OB170	0.200	0.200	0
754	E20WJP070	P17JG020	1.000	1.000	1
755	E20WNA050	O01OB170	0.350	0.350	0
756	E20WNA050	P17NA080	1.250	1.250	1
757	E20WNA050	P17NC130	2.000	2.000	2
758	E21ABC010	O01OB170	1.000	1.000	0
759	E21ABC010	P18BC010	1.000	1.000	1
760	E21ABC010	P18GB195	1.000	1.000	2
761	E21ABC010	P17SC130	1.000	1.000	3
762	E21ABC010	P17SV090	1.000	1.000	4
763	E21ABC060	O01OB170	1.000	1.000	0
764	E21ABC060	P18BC090	1.000	1.000	1
765	E21ABC060	P18GB180	1.000	1.000	2
766	E21ABC060	P17SC130	1.000	1.000	3
767	E21ABC060	P17SV090	1.000	1.000	4
768	E21ADP020	O01OB170	0.800	0.800	0
769	E21ADP020	P18DP240	1.000	1.000	1
770	E21ADP020	P18GD320	1.000	1.000	2
771	E21ADP020	P18DM200	1.000	1.000	3
772	E21ALA060	O01OB170	1.100	1.100	0
773	E21ALA060	P18LP080	1.000	1.000	1
774	E21ALA060	P18GL080	1.000	1.000	2
775	E21ALA060	P17SV100	1.000	1.000	3
776	E21ALA060	P17XT030	2.000	2.000	4
777	E21ALA060	P18GW040	2.000	2.000	5
778	E21ATC020	O01OB170	1.000	1.000	0
779	E21ATC020	P18VT040	1.000	1.000	1
780	E21ATC020	P18GT060	1.000	1.000	2
781	E21ATC020	P17SV100	1.000	1.000	3
782	E21ATC020	P17XT030	2.000	2.000	4
783	E21ATC020	P18GW040	2.000	2.000	5
784	E21ALA050	O01OB170	1.100	1.100	0
785	E21ALA050	P18LP070	1.000	1.000	1
786	E21ALA050	P18GL080	1.000	1.000	2
787	E21ALA050	P17SV100	1.000	1.000	3
788	E21ALA050	P17XT030	2.000	2.000	4
789	E21ALA050	P18GW040	2.000	2.000	5
790	E21ANB010	O01OB170	1.300	1.300	0
791	E21ANB010	P18IB010	1.000	1.000	1
792	E21ANB010	P17XT030	1.000	1.000	2
793	E21ANB010	P18GW040	1.000	1.000	3
794	E21FA090	O01OB170	1.200	1.200	0
795	E21FA090	P18FA220	1.000	1.000	1
796	E21FA090	P18GF270	1.000	1.000	2
797	E21FA090	P17SV060	2.000	2.000	3
798	E21FA090	P17XT030	2.000	2.000	4
799	E21FA090	P18GW040	2.000	2.000	5
724	20	E03EUF020	1.000	1.000	0
800	E21MA020	O01OA030	1.500	1.500	0
801	E21MA020	P18CE060	1.000	1.000	1
802	E20VF020	O01OB170	0.200	0.200	0
803	E20VF020	P17XE020	1.000	1.000	1
804	E20VF030	O01OB170	0.200	0.200	0
805	E20VF030	P17XE030	1.000	1.000	1
806	E20VF040	O01OB170	0.200	0.200	0
807	E20VF040	P17XE040	1.000	1.000	1
808	E20WJF010	O01OB170	0.150	0.150	0
809	E20WJF010	P17VC050	1.000	1.000	1
810	E20WJF010	P17VP050	0.300	0.300	2
811	E20WJF010	P17JP060	1.000	1.000	3
812	E20WJF020	O01OB170	0.150	0.150	0
813	E20WJF020	P17VC060	1.000	1.000	1
814	E20WJF020	P17VP060	0.300	0.300	2
815	E20WJF020	P17JP070	1.000	1.000	3
816	E20XVC040	E20XEC030	1.000	1.000	0
817	E20XVC040	E20XEC040	2.000	2.000	1
818	E20XVC040	E20XEC050	1.000	1.000	2
819	E20TC020	O01OB170	0.180	0.180	0
820	E20TC020	P17CH020	1.000	1.000	1
821	E20TC020	P17CW020	0.500	0.500	2
822	E20TC020	P15GC020	1.000	1.000	3
823	E20TC020	P17CW100	0.300	0.300	4
824	E20TC010	O01OB170	0.180	0.180	0
825	E20TC010	P17CH010	1.000	1.000	1
826	E20TC010	P17CW010	0.800	0.800	2
827	E20TC010	P15GC020	1.000	1.000	3
828	E20TC030	O01OB170	0.180	0.180	0
829	E20TC030	P17CH030	1.000	1.000	1
830	E20TC030	P17CW030	0.500	0.500	2
831	E20TC030	P17CW110	0.300	0.300	3
832	E20TC030	P15GC030	1.000	1.000	4
833	E20TC040	O01OB170	0.150	0.150	0
834	E20TC040	P17CD050	1.000	1.000	1
835	E20TC040	P17CW120	0.300	0.300	2
836	E20TC040	P17CW200	0.100	0.100	3
837	E20TC040	P15GC030	1.000	1.000	4
838	E20TC050	O01OB170	0.150	0.150	0
839	E20TC050	P17CD060	1.000	1.000	1
840	E20TC050	P17CP030	0.300	0.300	2
841	E20TC050	P17CW210	0.100	0.100	3
842	E20TC050	P15GC040	1.000	1.000	4
843	E20AL020	O01OB170	1.600	1.600	0
844	E20AL020	O01OB180	0.800	0.800	1
845	E20AL020	P17PB020	8.500	8.500	2
846	E20AL020	P17PP010	1.000	1.000	3
847	E20AL020	P17PP260	1.000	1.000	4
848	E20CIR020	O01OB170	1.500	1.500	0
849	E20CIR020	O01OB180	1.500	1.500	1
850	E20CIR020	P17BI020	1.000	1.000	2
851	E20CIR020	P17AA030	1.000	1.000	3
852	E20CIR020	P17AA110	1.000	1.000	4
853	E20CIR020	P17AA190	1.000	1.000	5
854	E20CIR020	P17XE030	2.000	2.000	6
855	E20CIR020	P17XA090	1.000	1.000	7
856	E20CIR020	P17XR020	1.000	1.000	8
857	E20CIR020	P17W020	1.000	1.000	9
859	21	E22DG030	1.000	1.000	1
860	21	E22HC020	7.000	7.000	2
861	21	E22SEL020	120.000	120.000	3
862	21	E22NTC010	7.130	7.131	4
863	21	E22NTC020	10.690	10.690	5
864	21	E22NTC030	8.910	8.910	6
865	21	E22NTC040	5.340	5.341	7
866	21	E22NTC050	3.560	3.560	8
867	21	E22NVE010	2.000	2.000	9
868	21	E22NVE020	2.000	2.000	10
869	21	E17DGC020	1.000	1.000	11
870	E22CF010	O01OA090	8.000	8.000	0
871	E22CF010	P20CF010	1.000	1.000	1
872	E22CF010	P20TC040	8.000	8.000	2
873	E22CF010	P20WT090	1.000	1.000	3
874	E22CF010	P20WH030	3.000	3.000	4
875	E22CF010	P07CV010	8.000	8.000	5
876	E22CF010	P20WH120	1.000	1.000	6
877	E22DG030	O01OB170	7.500	7.500	0
878	E22DG030	O01OB180	7.500	7.500	1
879	E22DG030	M02GE020	1.500	1.500	2
880	E22DG030	P20DO030	1.000	1.000	3
881	E22DG030	P20DO240	1.000	1.000	4
882	E22DG030	P20TC010	10.000	10.000	5
883	E22DG030	P20DO210	1.000	1.000	6
884	E22DG030	P20TC120	10.000	10.000	7
885	E22DG030	P20DO260	1.000	1.000	8
886	E22DG030	P20DO250	1.000	1.000	9
887	E22HC020	O01OB170	1.500	1.500	0
888	E22HC020	O01OB180	1.500	1.500	1
889	E22HC020	P20WH410	1.000	1.000	2
890	E22SEL020	O01OB170	0.100	0.100	0
891	E22SEL020	O01OB180	0.100	0.100	1
892	E22SEL020	P20MA020	1.000	1.000	2
893	E22SEL020	P20MW061	0.200	0.200	3
894	E22SEL020	P20MW010	0.100	0.100	4
895	E22SEL020	P20MW020	0.100	0.100	5
896	E22SEL020	P20MW030	0.500	0.500	6
897	E22SEL020	P20MW050	0.100	0.100	7
898	E22NTC010	O01OB170	0.250	0.250	0
899	E22NTC010	P20TC010	1.000	1.000	1
900	E22NTC010	P20TC100	1.000	1.000	2
901	E22NTC020	O01OB170	0.250	0.250	0
902	E22NTC020	P20TC020	1.000	1.000	1
903	E22NTC020	P20TC110	1.000	1.000	2
904	E22NTC030	O01OB170	0.250	0.250	0
905	E22NTC030	P20TC030	1.000	1.000	1
906	E22NTC030	P20TC120	1.000	1.000	2
907	E22NTC040	O01OB170	0.300	0.300	0
908	E22NTC040	P20TC040	1.000	1.000	1
909	E22NTC040	P20TC130	1.000	1.000	2
910	E22NTC050	O01OB170	0.300	0.300	0
911	E22NTC050	P20TC050	1.000	1.000	1
912	E22NTC050	P20TC140	1.000	1.000	2
858	21	E22CF010	1.000	1.000	0
913	E22NVE010	O01OB170	0.500	0.500	0
914	E22NVE010	P20TV010	1.000	1.000	1
915	E22NVE020	O01OB170	0.500	0.500	0
916	E22NVE020	P20TV020	1.000	1.000	1
917	E17DGC020	O01OB200	0.350	0.350	0
918	E17DGC020	O01OB220	0.350	0.350	1
919	E17DGC020	P15KC040	1.000	1.000	2
920	E17DGC020	P15GB010	8.000	8.000	3
921	E17DGC020	P15GA010	18.000	18.000	4
922	E17DGC020	P01DW090	1.000	1.000	5
923	A01A020	O01OA070	2.500	2.500	0
924	A01A020	P01CY080	0.790	0.790	1
925	A01A020	P01DW050	0.700	0.700	2
926	A01A030	O01OA070	2.500	2.500	0
927	A01A030	P01CY010	0.850	0.850	1
928	A01A030	P01DW050	0.600	0.600	2
929	A01A040	O01OA070	2.500	2.500	0
930	A01A040	P01CY030	0.810	0.810	1
931	A01A040	P01DW050	0.650	0.650	2
932	A01L020	O01OA070	2.000	2.000	0
933	A01L020	P01CC020	0.425	0.425	1
934	A01L020	P01DW050	0.850	0.850	2
935	A01L090	O01OA070	2.000	2.000	0
936	A01L090	P01CC120	0.500	0.500	1
937	A01L090	P01DW050	0.900	0.900	2
938	A02A040	O01OA070	1.700	1.700	0
939	A02A040	P01CC020	0.600	0.600	1
940	A02A040	P01AA020	0.880	0.880	2
941	A02A040	P01DW050	0.265	0.265	3
942	A02A040	M03HH020	0.400	0.400	4
943	A02A050	O01OA070	1.700	1.700	0
944	A02A050	P01CC020	0.440	0.440	1
945	A02A050	P01AA020	0.975	0.975	2
946	A02A050	P01DW050	0.260	0.260	3
947	A02A050	M03HH020	0.400	0.400	4
948	A02A060	O01OA070	1.700	1.700	0
949	A02A060	P01CC020	0.350	0.350	1
950	A02A060	P01AA020	1.030	1.030	2
951	A02A060	P01DW050	0.260	0.260	3
952	A02A060	M03HH020	0.400	0.400	4
953	A02A080	O01OA070	1.700	1.700	0
954	A02A080	P01CC020	0.250	0.250	1
955	A02A080	P01AA020	1.100	1.100	2
956	A02A080	P01DW050	0.255	0.255	3
957	A02A080	M03HH020	0.400	0.400	4
958	A02A090	O01OA070	1.700	1.700	0
959	A02A090	P01CC020	0.190	0.190	1
960	A02A090	P01AA020	1.140	1.140	2
961	A02A090	P01DW050	0.250	0.250	3
962	A02A090	M03HH020	0.400	0.400	4
963	A02A140	O01OA070	1.700	1.700	0
964	A02A140	P01CC020	0.250	0.250	1
965	A02A140	P01AA060	1.100	1.100	2
966	A02A140	P01DW050	0.255	0.255	3
967	A02A140	M03HH020	0.400	0.400	4
968	A02S020	O01OA070	1.800	1.800	0
969	A02S020	P01CC020	0.350	0.350	1
970	A02S020	P01AA020	1.030	1.030	2
971	A02S020	P01DW050	0.240	0.240	3
972	A02S020	P01DH010	1.750	1.750	4
973	A02S020	M03HH020	0.400	0.400	5
974	A03H090	O01OA070	0.800	0.800	0
975	A03H090	P01CC020	0.330	0.330	1
976	A03H090	P01AA030	0.650	0.650	2
977	A03H090	P01AG020	1.300	1.300	3
978	A03H090	P01DW050	0.180	0.180	4
979	A03H090	M03HH030	0.500	0.500	5
980	I	INDI01	1.000	1.000	0
981	I	INDI02	1.000	1.000	1
982	I	INDI03	2.000	2.000	2
983	I	INDI04	0.600	0.600	3
984	I	INDI05	1.000	1.000	4
985	I	INDI10	1.000	1.000	5
986	I	INDI11	1.000	1.000	6
987	I	INDI12	1.000	1.000	7
988	I	INDI20	4.000	4.000	8
989	I	INDI21	4.000	4.000	9
990	I	INDI31	1.000	1.000	10
991	I	INDI33	1.000	1.000	11
992	I	INDI34	1.000	1.000	12
993	I	INDI35	1.000	1.000	13
994	I	INDI36	1.000	1.000	14
995	E02ES020	O01OA070	3.400	3.400	0
996	E02ES020	M08RI010	0.800	0.800	1
997	E04AB020	O01OB030	0.013	0.013	0
998	E04AB020	O01OB040	0.013	0.013	1
999	E04AB020	P03AC200	1.100	1.100	2
1000	E04AB020	P03AA020	0.006	0.006	3
1001	E04AM060	O01OB030	0.008	0.008	0
1002	E04AM060	O01OB040	0.008	0.008	1
1003	E04AM060	P03AM030	1.250	1.250	2
1004	E04CA010	E04CM050	1.000	1.000	0
1005	E04CA010	E04AB020	40.000	40.000	1
1006	E04CM050	O01OA030	0.360	0.360	0
1007	E04CM050	O01OA070	0.360	0.360	1
1008	E04CM050	M11HV120	0.360	0.360	2
1009	E04CM050	P01HA010	1.150	1.150	3
1010	E04SE090	O01OA030	0.600	0.600	0
1011	E04SE090	O01OA070	0.600	0.600	1
1012	E04SE090	P01HA010	1.050	1.050	2
1013	E05HFE010	O01OB010	0.055	0.055	0
1014	E05HFE010	O01OB020	0.055	0.055	1
1015	E05HFE010	P01EM290	0.007	0.007	2
1016	E05HFE010	P01UC030	0.050	0.050	3
1017	E05HFE010	P03AA020	0.040	0.040	4
1018	E05HFE010	M13CP100	0.005	0.005	5
1019	E05HLM020	O01OB010	0.250	0.250	0
1020	E05HLM020	O01OB020	0.250	0.250	1
1021	E05HLM020	O01OB025	0.170	0.170	2
1022	E05HLM020	M02GT002	0.170	0.170	3
1023	E05HLM020	P01HA010	1.000	1.000	4
1024	E05HLE020	O01OB010	0.250	0.250	0
1025	E05HLE020	O01OB020	0.250	0.250	1
1026	E05HLE020	M13EM030	1.000	1.000	2
1027	E05HLE020	P01EM280	0.020	0.020	3
1028	E05HLE020	P01UC030	0.150	0.150	4
1029	E05HLE020	P03AA020	0.500	0.500	5
1030	E05HLE020	M13CP100	0.010	0.010	6
1031	E05HSM010	O01OB010	0.250	0.250	0
1032	E05HSM010	O01OB020	0.250	0.250	1
1033	E05HSM010	O01OB025	0.170	0.170	2
1034	E05HSM010	M02GT002	0.170	0.170	3
1035	E05HSM010	P01HA010	1.050	1.050	4
1036	E05HSF010	O01OB010	0.070	0.070	0
1037	E05HSF010	O01OB020	0.070	0.070	1
1038	E05HSF010	M13EF010	1.000	1.000	2
1039	E05HSF010	P01UC030	0.050	0.050	3
1040	E05HSF010	P03AA020	0.050	0.050	4
1041	E05HVM010	O01OB010	0.125	0.125	0
1042	E05HVM010	O01OB020	0.125	0.125	1
1043	E05HVM010	O01OB025	0.100	0.100	2
1044	E05HVM010	M02GT002	0.100	0.100	3
1045	E05HVM010	P01HA010	1.000	1.000	4
1046	E05HVE010	O01OB010	0.650	0.650	0
1047	E05HVE010	O01OB020	0.650	0.650	1
1048	E05HVE010	M13EM030	1.050	1.050	2
1049	E05HVE010	P01EM290	0.028	0.028	3
1050	E05HVE010	P01UC030	0.070	0.070	4
1051	E05HVE010	P03AA020	0.070	0.070	5
1052	E05HVE010	M13CP100	0.020	0.020	6
1053	E05HVM030	O01OB010	0.125	0.125	0
1054	E05HVM030	O01OB020	0.125	0.125	1
1055	E05HVM030	O01OB025	0.100	0.100	2
1056	E05HVM030	M02GT002	0.100	0.100	3
1057	E05HVM030	P01HA010	1.000	1.000	4
1058	E05HVE030	O01OB010	0.650	0.650	0
1059	E05HVE030	O01OB020	0.650	0.650	1
1060	E05HVE030	M13EM030	1.000	1.000	2
1061	E05HVE030	P01EM280	0.015	0.015	3
1062	E05HVE030	P01UC030	0.060	0.060	4
1063	E05HVE030	P03AA020	0.050	0.050	5
1064	E05HVE030	M13CP100	0.010	0.010	6
1065	E11CCC050	O01OA030	0.170	0.170	0
1066	E11CCC050	O01OA060	0.170	0.170	1
1067	E11CCC050	A02A050	0.030	0.030	2
1068	E11RT010	O01OB150	0.250	0.250	0
1069	E11RT010	O01OA070	0.100	0.100	1
1070	E11RT010	P25MW010	0.900	0.900	2
1071	E13CD010	O01OB160	0.180	0.180	0
1072	E13CD010	P11PP010	6.000	6.000	1
1073	E13CS030	O01OB160	0.100	0.100	0
1074	E13CS030	P11PP030	5.300	5.300	1
1075	E20VE020	O01OB170	0.200	0.200	0
1076	E20VE020	P17XP050	1.000	1.000	1
1077	E20WBV010	O01OB170	0.100	0.100	0
1078	E20WBV010	P17VC010	1.000	1.000	1
1079	E20WBV010	P17VP010	0.300	0.300	2
1080	E20WBV010	P17VP170	0.100	0.100	3
1081	E20WBV020	O01OB170	0.100	0.100	0
1082	E20WBV020	P17VC020	1.000	1.000	1
1083	E20WBV020	P17VP020	0.300	0.300	2
1084	E20WBV020	P17VP180	0.100	0.100	3
1085	E20WGB020	O01OB170	0.400	0.400	0
1086	E20WGB020	P17SB020	1.000	1.000	1
1087	E20WGB020	P17VC030	1.500	1.500	2
1088	E20WGB020	P17VP180	4.000	4.000	3
1089	E20WGB020	P17VP190	1.000	1.000	4
1090	E20WGB030	O01OB170	0.500	0.500	0
1091	E20WGB030	P17SB030	1.000	1.000	1
1092	E20WGB030	P17VC030	1.500	1.500	2
1093	E20WGB030	P17VP180	3.000	3.000	3
1094	E20WGB030	P17VP190	1.000	1.000	4
1095	E20WGI060	O01OB170	0.400	0.400	0
1096	E20WGI060	P17SD020	1.000	1.000	1
1097	E20WGI060	P17VC020	0.300	0.300	2
1098	E20WGI060	P17VP180	2.000	2.000	3
1099	E20WGI110	O01OB170	0.300	0.300	0
1100	E20WGI110	P17SS030	1.000	1.000	1
1101	E20WGI110	P17VC020	0.150	0.150	2
1102	E20WGI110	P17VP180	2.000	2.000	3
1103	E20WJF030	O01OB170	0.150	0.150	0
1104	E20WJF030	P17VC070	1.000	1.000	1
1105	E20WJF030	P17VP070	0.300	0.300	2
1106	E20WJF030	P17JP080	1.000	1.000	3
1107	E20XEC030	E20TC020	11.500	11.500	0
1108	E20XEC030	E20TC030	4.200	4.200	1
1109	E20XEC030	E20TC040	2.800	2.800	2
1110	E20XEC030	E20VE020	2.000	2.000	3
1111	E20XEC030	E20WBV010	1.700	1.700	4
1112	E20XEC030	E20WBV020	1.700	1.700	5
1113	E20XEC030	E20WGB020	1.000	1.000	6
1114	E20XEC030	E20WJF020	3.000	3.000	7
1115	E20XEC030	P17SW010	1.000	1.000	8
1116	E20XEC040	E20TC020	15.000	15.000	0
1117	E20XEC040	E20TC030	5.400	5.400	1
1118	E20XEC040	E20TC040	3.600	3.600	2
1119	E20XEC040	E20VE020	2.000	2.000	3
1120	E20XEC040	E20WBV010	3.400	3.400	4
1121	E20XEC040	E20WBV020	1.700	1.700	5
1122	E20XEC040	E20WGB030	1.000	1.000	6
1123	E20XEC040	E20WJF030	3.000	3.000	7
1124	E20XEC040	P17SW040	1.000	1.000	8
1125	E20XEC050	E20TC020	11.500	11.500	0
1126	E20XEC050	E20TC030	5.400	5.400	1
1127	E20XEC050	E20TC040	3.600	3.600	2
1128	E20XEC050	E20VE020	2.000	2.000	3
1129	E20XEC050	E20WBV020	5.100	5.100	4
1130	E20XEC050	E20WGI060	1.000	1.000	5
1131	E20XEC050	E20WGI110	2.000	2.000	6
1132	E20XEC050	E20WJF020	3.000	3.000	7
1133	O01OA090	O01OA030	1.000	1.000	0
1134	O01OA090	O01OA050	1.000	1.000	1
1135	O01OA090	O01OA070	0.500	0.500	2
287	07	E09ICX030	124.230	124.231	0
350	10	E08PFA020	181.575	181.595	0
\.


--
-- TOC entry 3156 (class 0 OID 16684)
-- Dependencies: 214
-- Data for Name: PruebaBBDDVacia_Conceptos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."PruebaBBDDVacia_Conceptos" (codigo, resumen, descripcion, descripcionhtml, preciomed, preciobloq, naturaleza, fecha, ud, preciocert) FROM stdin;
P01	PARTIDA 1			12.390	\N	7	2019-06-18	m2	0.000
C02	CAPITULO 2		\N	52.000	\N	6	2019-06-18		52.000
PruebaBBDDVacia	Prueba para ver si escribo en la BBDD	\N	\N	1982.553	\N	6	2019-06-18	\N	\N
C03	CAPITULO 3 y MAS			1500.000	\N	6	2019-06-18		1500.000
C01	CAPITULO			430.553	\N	6	2019-06-18		0.000
P02	PARTIDA 2			0.000	\N	7	2019-06-18	kg	0.000
MO_OFICIAL	Oficial 1ª			18.850	\N	1	2019-06-18	h	18.850
MO_PEON	Peon			16.550	\N	1	2019-06-18	h	16.550
\.


--
-- TOC entry 3161 (class 0 OID 16778)
-- Dependencies: 219
-- Data for Name: PruebaBBDDVacia_GuardarRelaciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."PruebaBBDDVacia_GuardarRelaciones" (idguardar, paso, r) FROM stdin;
\.


--
-- TOC entry 3159 (class 0 OID 16703)
-- Dependencies: 217
-- Data for Name: PruebaBBDDVacia_Mediciones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."PruebaBBDDVacia_Mediciones" (id, num_certif, tipo, comentario, ud, longitud, anchura, altura, formula, codpadre, codhijo, posicion) FROM stdin;
1	0	\N	Suelo salón	2	2.000	5.000	2.000	(a+b+c)*d	C01	P01	0
2	0	\N	Suelo Dormitorio 1	1.00	2.550	5.000	0.000		C01	P01	1
3	0	\N	Otro suelo	1.00	2.000	2.000	0.000		C01	P01	2
\.


--
-- TOC entry 3157 (class 0 OID 16692)
-- Dependencies: 215
-- Data for Name: PruebaBBDDVacia_Relacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."PruebaBBDDVacia_Relacion" (id, codpadre, codhijo, canpres, cancert, posicion) FROM stdin;
0	\N	PruebaBBDDVacia	1.000	1.000	0
5	P01	MO_OFICIAL	0.350	1.000	0
6	P01	MO_PEON	0.350	1.000	1
4	C01	P02	1.000	1.000	1
1	PruebaBBDDVacia	C01	1.000	1.000	0
2	PruebaBBDDVacia	C02	1.000	1.000	1
7	PruebaBBDDVacia	C03	1.000	1.000	2
3	C01	P01	34.750	1.000	0
\.


--
-- TOC entry 3155 (class 0 OID 16632)
-- Dependencies: 213
-- Data for Name: tipoperfiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tipoperfiles (id, nombre, descripcion) FROM stdin;
\.


--
-- TOC entry 3153 (class 0 OID 16626)
-- Dependencies: 211
-- Data for Name: perfiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.perfiles (id, nombre, b, h, tw, tf, r2, d, seccion, peso, "Iy", "Wy", iy, "Iz", "Wz", iz, id_tipoperfil) FROM stdin;
\.


--
-- TOC entry 3154 (class 0 OID 16629)
-- Dependencies: 212
-- Data for Name: tCorrugados; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."tCorrugados" (diametro, seccion, peso, id_perfil) FROM stdin;
\.


--
-- TOC entry 3172 (class 0 OID 0)
-- Dependencies: 224
-- Name: CENZANO_Mediciones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."CENZANO_Mediciones_id_seq"', 435, true);


--
-- TOC entry 3173 (class 0 OID 0)
-- Dependencies: 222
-- Name: CENZANO_Relacion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."CENZANO_Relacion_id_seq"', 1135, true);


--
-- TOC entry 3174 (class 0 OID 0)
-- Dependencies: 218
-- Name: PruebaBBDDVacia_Mediciones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."PruebaBBDDVacia_Mediciones_id_seq"', 3, true);


--
-- TOC entry 3175 (class 0 OID 0)
-- Dependencies: 216
-- Name: PruebaBBDDVacia_Relacion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."PruebaBBDDVacia_Relacion_id_seq"', 7, true);


-- Completed on 2019-06-22 20:08:51 CEST

--
-- PostgreSQL database dump complete
--


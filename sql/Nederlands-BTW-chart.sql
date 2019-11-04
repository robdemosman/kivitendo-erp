--- nederlands rekeningsschema
-- Erstellt am 30-10-2019


-- This file is part of kivitendo.
-- kivitendo is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 2 of the License, or
-- (at your option) any later version.
--
-- kivitendo is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with kivitendo. If not, see <http://www.gnu.org/licenses/>.

-- Diese Datei ist Teil von kivitendo.
--
-- kivitendo ist Freie Software: Sie können es unter den Bedingungen
-- der GNU General Public License, wie von der Free Software Foundation,
-- Version 2 der Lizenz oder (nach Ihrer Wahl) jeder späteren
-- veröffentlichten Version, weiterverbreiten und/oder modifizieren.
--
-- kivitendo wird in der Hoffnung, dass es nützlich sein wird, aber
-- OHNE JEDE GEWÄHRLEISTUNG, bereitgestellt; sogar ohne die implizite
-- Gewährleistung der MARKTFÄHIGKEIT oder EIGNUNG FÜR EINEN BESTIMMTEN ZWECK.
-- Siehe die GNU General Public License für weitere Details.
--
-- Sie sollten eine Kopie der GNU General Public License zusammen mit diesem
-- Programm erhalten haben. Wenn nicht, siehe <http://www.gnu.org/licenses/>.

DELETE FROM chart;

--INSERT INTO chart (accno, description, charttype, category, link, gifi_accno, taxkey_id, pos_ustva, pos_bwa, pos_bilanz, pos_eur, datevautomatik) VALUES

INSERT INTO chart
(accno, 	description, 															     charttype, category, link, 		taxkey_id, pos_ustva, pos_bwa, pos_bilanz, pos_eur, new_chart_id, valid_from)
VALUES

 ('010', 	  'Immateriële vaste activa', 											  'H', ' ', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('010400', 'Goodwill', 																        'A', 'A', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('010405', 'Afschrijvingen Goodwill', 													'A', 'A', '',										  0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),

 ('03', 	'Voorzieningen', 															        'H', ' ', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('030000', 'Voorzieningen', 															      'A', 'Q', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('030001', 'Toename voorzieningen', 													  'A', 'Q', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('030002', 'Afname voorzieningen', 													  'A', 'Q', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),

 ('04', 	'Langlopende Schulden', 													    'H', ' ', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('041100', 'Hypotheek', 																        'A', 'L', '', 									  0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('041102', 'Hypotheek opnamen', 														    'A', 'L', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('041103', 'Hypotheek aflossing', 														  'A', 'L', '', 										11, NULL, NULL, NULL, NULL, NULL, '1970-01-01'),

 ('011', 	  'Materiële vaste activa', 												  'H', ' ', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('011000', 'Bedrijfsgebouwen en -terreinen', 									'A', 'A', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('011002', 'Investeringen Bedrijfsgebouwen en -terreinen', 		'A', 'A', '', 										8, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('011005', 'Afschrijvingen Bedrijfsgebouwen en -terreinen', 		'A', 'A', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('011100', 'Machines en installaties', 												'A', 'A', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('011102', 'investeringen Machines en installaties', 					'A', 'A', '', 										8, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('011103', 'desinvesteringen Machines en installaties', 				'A', 'A', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('011105', 'Afschrijvingen Machines en installaties', 					'A', 'A', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('011200', 'Auto', 																	          'A', 'A', '', 									  8, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('011205', 'Afschrijvingen Auto', 														  'A', 'A', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),

 ('012', 	'Financiële vaste activa', 													  'H', ' ', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('012000', 'Borg huur pand', 															    'A', 'A', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),

 ('11', 	'Liquide middelen', 														      'H', ' ', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('111000', 'ABN-AMRO doorlopend krediet', 											'A', 'A', 'AR_paid:AP_paid',			0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('110000', 'Kas', 																		          'A', 'A', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('112000', 'ABN-AMRO Spaarrekening TopDeposito ', 							'A', 'A', 'AR_paid:AP_paid', 			0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('115000', 'Tegoed Openprovider', 														  'A', 'A', 'AP_paid', 							0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),

 ('12', 	'Kortlopende vorderingen', 													  'H', ' ', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('120000', 'Debiteuren', 																      'A', 'A', 'AR', 									0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('120001', 'Dubieuze debiteuren',														  'A', 'A', '', 									  0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),

 ('13', 	  'Kortlopende Schulden', 													  'H', ' ', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('131000', 'Crediteuren', 																      'A', 'L', 'AP', 									0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),

 ('134', 	'Btw', 																		            'H', ' ', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('134000', 'Btw over leveringen / diensten belast met 21%', 		'A', 'L', 'AR_tax:IC_taxpart', 		0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('134001', 'Btw over leveringen / diensten belast met 9%', 		'A', 'L', 'AR_tax:IC_taxpart', 		0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('134002', 'Btw over leveringen / diensten belast met overige tarieven behalve 0%', 	'A', 'L', 'AR_tax:IC_taxpart', 	0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('134003', 'Btw over leveringen / diensten belast met 0% of niet bij u belast', 		'A', 'L', 'AR_tax:IC_taxpart', 		0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('134004', 'Btw inzake privégebruik', 													'A', 'L', 'AR_tax:AP_tax:IC_taxpart:IC_taxservice',   0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('134005', 'Leveringen/diensten waarbij heffing van omzetbelasting naar u is verlegd', 'A', 'A', '',		0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('134006', 'Leveringen naar landen buiten de EU (uitvoer)', 		'A', 'A', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('134007', 'Leveringen naar landen binnen de EU', 							'A', 'A', 'AR_tax:IC_taxpart',		0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('134008', 'Leveringen naar/diensten in landen binnen de EU', 	'A', 'A', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('134009', 'Installatie/afstandsverkopen binnen de EU', 				'A', 'A', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('134010', 'Leveringen uit landen buiten de EU (invoer)', 			'A', 'A', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('134011', 'Verwervingen van goederen uit landen binnen de EU','A', 'A', 'AP_tax:IC_taxpart',		0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('134012', 'Btw voorbelasting 21%', 													  'A', 'A', 'AP_tax:IC_taxpart',		0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('134013', 'Btw voorbelasting 9%', 													  'A', 'A', 'AP_tax:IC_taxpart',		0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('134014', 'Vermindering volgens de kleineondernemersregeling','A', 'A', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('134015', 'Lokale btw in andere EU landen', 									'A', 'A', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('134016', 'Vrijgesteld van btw', 														  'A', 'A', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('134017', 'Btw afdrachten', 															    'A', 'A', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('134018', 'BTW fiscale eenheid', 														  'A', 'A', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('134019', 'Te corrigeren btw', 														    'A', 'A', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),

 ('20', 	'Tussenrekeningen', 														      'H', ' ', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('200000', 'Kruisposten', 																      'A', 'A', '', 									  0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('210000', 'Vraagposten', 																      'A', 'A', '',										  0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),

 ('30', 	  'Voorraden', 																          'H', ' ', '', 									0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('300000', 'Voorraad grondstoffen', 													  'A', 'A', 'IC', 									8, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('301000', 'Voorraad hulpstoffen', 													  'A', 'A', 'AP_amount', 						8, NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('302000', 'Voorraad onderhanden werk', 												'A', 'A', '', 										8, NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('303000', 'Voorraad gereed product', 													'A', 'A', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('304000', 'Voorraad handelsgoederen', 												'A', 'A', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('305000', 'Voorruitbetalingen op voorraden', 									'A', 'A', '', 										0, NULL, NULL, NULL, NULL, NULL, '1970-01-01'),

 ('40', 	'Afschrijvingskosten', 														    'H', ' ', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('400300', 'Afschrijving Goodwill', 													  'A', 'E', 'AP_amount', 						0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('400301', 'Boekwinst Goodwill', 														  'A', 'E', 'AR_amount', 						0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('401100', 'Afschrijving Machines', 													  'A', 'E', 'AP_amount', 						0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('401101', 'Boekwinst Machines', 														  'A', 'E', 'AR_amount', 						0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('401200', 'Afschrijving Auto', 														    'A', 'E', 'AP_amount', 						0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('401201', 'Boekwinst Auto', 															    'A', 'E', 'AR_amount', 						0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),

 ('42', 	'Huisvestingskosten', 														    'H', ' ', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('420000', 'Betaalde huur', 															      'A', 'E', 'AP_amount', 						8, NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('420001', 'Verzekeringskosten', 														  'A', 'E', 'AP_amount', 						0, NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('420002', 'Onderhoud en reparaties huisvestiging', 						'A', 'E', 'AP_amount', 						8, NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('420003', 'Gas, water en electra', 													  'A', 'E', 'AP_amount', 						8, NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('420005', 'Onroerende Zaak Belasting', 												'A', 'E', 'AP_amount', 						0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('420007', 'Service kosten huur reclamebord', 									'A', 'E', 'AP_amount', 						8, NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('420008', 'Overige huisvestingskosten', 											'A', 'E', 'AP_amount', 						8, NULL, NULL, NULL, NULL, NULL, '1970-01-01'),

 ('43', 	'Machine- en exploitatiekosten', 											'H', ' ', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('430000', 'Onderhoud en reparaties Machines', 								'A', 'E', 'AP_amount', 						8, NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('430001', 'Service kosten Machines', 													'A', 'E', 'AP_amount', 						8, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('430003', 'kleine aanschaffingen Machines', 									'A', 'E', 'AP_amount', 						8, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('430004', 'gereedschapskosten Machines', 											'A', 'E', 'AP_amount', 						8, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('430005', 'werk door derden', 														    'A', 'E', 'AP_amount', 						8, NULL, NULL, NULL, NULL, NULL, '1970-01-01'),

 ('44', 	'Autokosten', 																        'H', ' ', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('440000', 'Brandstofkosten', 															    'A', 'E', 'AP_amount', 						8, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('440001', 'Autoverzekering', 															    'A', 'E', 'AP_amount', 						0, NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('440002', 'Motorrijtuigenbelasting', 													'A', 'E', 'AP_amount', 						0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('440003', 'Boetes en bekeuringen', 													  'A', 'E', 'AP_amount', 						0, NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('440004', 'onderhoud en reparaties auto', 										'A', 'E', 'AP_amount', 						8, NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('440005', 'leasekosten', 																      'A', 'E', 'AP_amount', 						8, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('440006', 'Privé gebruik auto', 														  'A', 'E', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('440007', 'Btw privégebruik auto', 													  'A', 'E', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),

 ('45', 	'Verkoopkosten', 															        'A', 'E', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('450000', 'Reclame en advertentiekosten', 										'A', 'E', 'AP_amount', 						8, NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('450001', 'Kosten sponsoring', 														    'A', 'E', 'AP_amount', 						0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('450003', 'Relatiegeschenken', 														    'A', 'E', 'AP_amount', 						8, NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('450004', 'Representatiekosten', 														  'A', 'E', 'AP_amount', 						8, NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('450005', 'Reis-en verblijfkosten', 													'A', 'E', 'AP_amount', 						0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('450006', 'Vrachtkosten inkomende zendingen', 								'A', 'E', 'AP_amount', 						8, NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('450007', 'Vrachtkosten uitgaande zendingen', 								'A', 'E', 'AP_amount', 						8, NULL, NULL, NULL, NULL, NULL, '1970-01-01'),

 ('46', 	'Kantoorkosten', 															        'A', 'E', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('460000', 'Kantoorbenodigdheden', 													  'A', 'E', 'AP_amount', 						8, NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('460001', 'Communicatiekosten', 														  'A', 'E', 'AP_amount', 						8, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('460002', 'Onderhoud en reparaties kantoor', 									'A', 'E', 'AP_amount', 						8, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('460003', 'Porti', 																	          'A', 'E', 'AP_amount', 						8, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('460004', 'Automatiseringskosten', 													  'A', 'E', 'AP_amount', 						8, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),

 ('47', 	'Branche specifieke kosten', 												  'H', ' ', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('470000', 'Branche specifieke kosten', 												'A', 'E', 'AP_amount', 						8, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),

 ('48', 	'Algemene kosten', 															      'H', ' ', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('480000', 'Abonnementen en contributies', 										'A', 'E', 'AP_amount', 						8, NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('480001', 'Verzekeringen algemeen', 													'A', 'E', 'AP_amount', 						0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('480002', 'Administratiekosten', 														  'A', 'E', 'AP_amount', 						8, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('480003', 'Accountantskosten', 														    'A', 'E', 'AP_amount', 						8, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),

 ('49', 	'Bankkosten', 																        'H', ' ', '',										  0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('490000', 'Bankkosten', 																      'A', 'E', 'AP_amount', 						0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('490010', 'Kosten Pin', 																      'A', 'E', 'AP_amount', 						0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),

 ('700000', 'Inkoopwaarde van de omzet (inkooprijs van alle verkochte producten)', 		'A', 'C', 'IC_cogs', 	8, NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('710000', 'Voorraadmutaties', 														    'A', 'C', '', 										8, NULL, NULL, NULL, NULL, NULL, '1970-01-01'),

 ('80', 	'netto Omzet', 																        'H', ' ', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('800000', 'Omzet Offset', 															      'A', 'I', 'AR_amount:IC_sale:IC_income', 			4, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('800100', 'Omzet Print/Copy', 														    'A', 'I', 'AR_amount:IC_sale:IC_income', 			4, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('800200', 'Omzet LFP', 																        'A', 'I', 'AR_amount:IC_sale:IC_income', 			4, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('800300', 'Omzet uitbesteed werk', 													  'A', 'I', 'AR_amount:IC_sale:IC_income', 			4, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('800400', 'Omzet diverse', 															      'A', 'I', 'AR_amount:IC_sale:IC_income', 			4, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),

 ('90', 	'Bijzondere baten/lasten', 													  'H', ' ', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('900000', 'Bijzondere baten', 														    'A', 'I', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('900001', 'Bijzondere lasten', 														    'A', 'E', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),

 ('91', 	'Eigen Vermogen v.o.f.', 													    'H', ' ', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('910000', 'Kapitaal vennoot A', 														  'A', 'Q', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('910001', 'Resultaat huidig boekjaar', 												'A', 'Q', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('910002', 'Privé opnamen',															      'A', 'Q', 'AR_paid', 							0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('910003', 'Privé stortingen', 														    'A', 'Q', 'AP_paid', 							0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('912018', 'Winst 2018', 																      'A', 'Q', '',										  0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01'),
 ('912019', 'Winst 2019', 																      'A', 'Q', '', 										0, 	NULL, NULL, NULL, NULL, NULL, '1970-01-01');


DELETE FROM buchungsgruppen;

INSERT INTO buchungsgruppen (
 description, inventory_accno_id,
 income_accno_id_0, expense_accno_id_0,
 income_accno_id_1, expense_accno_id_1,
 income_accno_id_2, expense_accno_id_2,
 income_accno_id_3, expense_accno_id_3
) VALUES (
 'Standaard 21%',(SELECT id FROM chart WHERE accno = '300000'),
 (SELECT id FROM chart WHERE accno = '800000'), (SELECT id FROM chart WHERE accno = '700000'),
 (SELECT id FROM chart WHERE accno = '800000'), (SELECT id FROM chart WHERE accno = '700000'),
 (SELECT id FROM chart WHERE accno = '800000'), (SELECT id FROM chart WHERE accno = '700000'),
 (SELECT id FROM chart WHERE accno = '800000'), (SELECT id FROM chart WHERE accno = '700000')
),(
 'Standaard 9%',(SELECT id FROM chart WHERE accno = '300000'),
 (SELECT id FROM chart WHERE accno = '800000'), (SELECT id FROM chart WHERE accno = '700000'),
 (SELECT id FROM chart WHERE accno = '800000'), (SELECT id FROM chart WHERE accno = '700000'),
 (SELECT id FROM chart WHERE accno = '800000'), (SELECT id FROM chart WHERE accno = '700000'),
 (SELECT id FROM chart WHERE accno = '800000'), (SELECT id FROM chart WHERE accno = '700000')
);


DELETE FROM tax_zones;

INSERT INTO tax_zones (id, description) VALUES
(0, 'Nederland'), -- siehe auch Pg-upgrade2/taxzone_id_in_oe_delivery_orders.sql )=:
(1, 'Binnen EU met BTW nummer'),
(2, 'Binnen EU zonder BTW nummer'),
(3, 'Buiten de EU');


DELETE FROM tax;

INSERT INTO tax (taxkey, taxdescription, rate) VALUES
(0, 'Onbelast', 0.00000),
(1, 'BTW Vrij', 0.00000);

INSERT INTO tax (taxkey, taxdescription, rate, taxnumber, chart_id) VALUES
(2, 'geen BTW', 0.00000, '', null),
(3, 'overige BTW binnen NL', 0.00000, '134002', (SELECT id FROM chart WHERE accno='134002')),
(4, '21% BTW binnen NL', 0.21000, '134000', (SELECT id FROM chart WHERE accno='134000')),
(5, '9% BTW binnen NL', 0.09000, '134001', (SELECT id FROM chart WHERE accno='134001')),
(6, 'ICT Leveringen binnen de EU', 0.00000, '134007', (SELECT id FROM chart WHERE accno='134007')),
(7, 'ICT verwervingen van goederen uit landen binnen de EU', 0.00000, '134011', (SELECT id FROM chart WHERE accno='134011')),
(8, 'BTW te vorderen hoog', 0.21000, '134012', (SELECT id FROM chart WHERE accno='134012')),
(9, 'BTW te vorderen laag', 0.09000, '134013', (SELECT id FROM chart WHERE accno='134013'));


DELETE FROM taxkeys;

INSERT INTO taxkeys (taxkey_id, tax_id, chart_id, startdate) SELECT 0, (SELECT tax.id FROM tax WHERE taxkey=0), chart.id, '2011-01-01' FROM chart WHERE taxkey_id=0;
INSERT INTO taxkeys (taxkey_id, tax_id, chart_id, startdate) SELECT 1, (SELECT tax.id FROM tax WHERE taxkey=1), chart.id, '2011-01-01' FROM chart WHERE taxkey_id=1;
INSERT INTO taxkeys (taxkey_id, tax_id, chart_id, startdate) SELECT 2, (SELECT tax.id FROM tax WHERE taxkey=2), chart.id, '2011-01-01' FROM chart WHERE taxkey_id=2;
INSERT INTO taxkeys (taxkey_id, tax_id, chart_id, startdate) SELECT 3, (SELECT tax.id FROM tax WHERE taxkey=3), chart.id, '2011-01-01' FROM chart WHERE taxkey_id=3;
INSERT INTO taxkeys (taxkey_id, tax_id, chart_id, startdate) SELECT 4, (SELECT tax.id FROM tax WHERE taxkey=4), chart.id, '2011-01-01' FROM chart WHERE taxkey_id=4;
INSERT INTO taxkeys (taxkey_id, tax_id, chart_id, startdate) SELECT 5, (SELECT tax.id FROM tax WHERE taxkey=5), chart.id, '2011-01-01' FROM chart WHERE taxkey_id=5;
INSERT INTO taxkeys (taxkey_id, tax_id, chart_id, startdate) SELECT 6, (SELECT tax.id FROM tax WHERE taxkey=6), chart.id, '2011-01-01' FROM chart WHERE taxkey_id=6;
INSERT INTO taxkeys (taxkey_id, tax_id, chart_id, startdate) SELECT 7, (SELECT tax.id FROM tax WHERE taxkey=7), chart.id, '2011-01-01' FROM chart WHERE taxkey_id=7;
INSERT INTO taxkeys (taxkey_id, tax_id, chart_id, startdate) SELECT 8, (SELECT tax.id FROM tax WHERE taxkey=8), chart.id, '2011-01-01' FROM chart WHERE taxkey_id=8;
INSERT INTO taxkeys (taxkey_id, tax_id, chart_id, startdate) SELECT 9, (SELECT tax.id FROM tax WHERE taxkey=9), chart.id, '2011-01-01' FROM chart WHERE taxkey_id=9;


DELETE FROM units;

INSERT INTO units (name, base_unit, factor, type) VALUES
('Stuk', NULL, 0.00000, 'dimension'),
('mg', NULL, 0.00000, 'dimension'),
('g', 'mg', 1000.00000, 'dimension'),
('kg', 'g', 1000.00000, 'dimension'),
('t', 'kg', 1000.00000, 'dimension'),
('ml', NULL, 0.00000, 'dimension'),
('L', 'ml', 1000.00000, 'dimension'),
('Min', NULL, 0.00000, 'service'),
('Uur', 'Min', 60.00000, 'service'),
('Dag', 'Uur', 8.00000, 'service'),
('Week', NULL, 0.00000, 'service'),
('Maand', 'Week', 4.00000, 'service'),
('Jaar', 'Maand', 12.00000, 'service');



-- Minimal
DELETE FROM customer;

INSERT INTO customer (
             id,  name
)  VALUES  (  0,  'selecteer een klant');

DELETE FROM vendor;

INSERT INTO vendor (
             id,  name
)  VALUES  (  0,  'selecteer een leverancier');



DELETE FROM defaults;

INSERT INTO defaults (
  inventory_accno_id,
  income_accno_id, expense_accno_id,
  fxgain_accno_id, fxloss_accno_id,
  invnumber, sonumber,
  weightunit,
  businessnumber,
  version,
  closedto,
  revtrans,
  ponumber, sqnumber, rfqnumber,
  customernumber, vendornumber,
  audittrail,
  articlenumber, servicenumber,
  rmanumber, cnnumber
) VALUES (
  (SELECT id FROM CHART WHERE accno='300000'),
  (SELECT id FROM CHART WHERE accno='800000'), (SELECT id FROM CHART WHERE accno='300000'),
  (SELECT id FROM CHART WHERE accno='900000'), (SELECT id FROM CHART WHERE accno='900001'),
  'F200000', 'OR200000',
  'kg',
  '',
  '1.0.0 NL',
  NULL,
  FALSE,
  0, 'OF20000', 0,
  0, 0,
  FALSE,
  0, 0,
  0, 0
);

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
(accno, description, charttype, category, link, taxkey_id, pos_ustva, pos_bwa, pos_bilanz, pos_eur, itime, mtime, new_chart_id, valid_from)
VALUES

 ('011200', 'Auto', 'A', 'A', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 17:31:11.407076', '2019-10-06 09:16:06.381235', NULL, '1970-01-01'),
 ('134005', 'Leveringen/diensten waarbij de heffing van omzetbelasting naar u is verlegd', 'A', 'A', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 19:55:52.750188', '2019-10-05 19:55:52.750188', NULL, '1970-01-01'),
 ('120001', 'Dubieuze debiteuren', 'A', 'A', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 18:36:30.159757', '2019-10-06 16:13:14.045342', NULL, '1970-01-01'),
 ('041100', 'Hypotheek', 'A', 'L', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 18:06:59.2143', '2019-10-06 15:52:07.667101', NULL, '1970-01-01'),
 ('200000', 'Kruisposten', 'A', 'A', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:07:36.313015', '2019-10-06 16:17:07.241707', NULL, '1970-01-01'),
 ('210000', 'Vraagposten', 'A', 'A', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:07:53.519418', '2019-10-06 16:22:51.675115', NULL, '1970-01-01'),
 ('134006', 'Leveringen naar landen buiten de EU (uitvoer)', 'A', 'A', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 19:56:20.882859', '2019-10-05 19:56:20.882859', NULL, '1970-01-01'),
 ('131000', 'Crediteuren', 'A', 'L', 'AP', 0, NULL, NULL, NULL, NULL, '2019-10-05 19:29:08.493695', '2019-10-06 16:38:55.749633', NULL, '1970-01-01'),
 ('134004', 'Btw inzake privégebruik', 'A', 'L', 'AR_tax:AP_tax:IC_taxpart:IC_taxservice', 0, NULL, NULL, NULL, NULL, '2019-10-05 19:55:28.781704', '2019-10-05 21:42:14.742954', NULL, '1970-01-01'),
 ('13', 'Kortlopende Schulden', 'H', ' ', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 19:31:45.503434', '2019-10-05 19:50:58.309114', NULL, '1970-01-01'),
 ('030001', 'Toename voorzieningen', 'A', 'Q', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 18:03:32.998111', '2019-10-06 17:36:04.88998', NULL, '1970-01-01'),
 ('030000', 'Voorzieningen', 'A', 'Q', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 17:23:53.008268', '2019-10-06 17:36:16.536996', NULL, '1970-01-01'),
 ('011102', 'investeringen Machines en installaties', 'A', 'A', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 17:46:18.385242', '2019-10-06 09:15:08.130925', NULL, '1970-01-01'),
 ('030002', 'Afname voorzieningen', 'A', 'Q', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 17:24:28.940566', '2019-10-06 17:36:27.405994', NULL, '1970-01-01'),
 ('011103', 'desinvesteringen Machines en installaties', 'A', 'A', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 17:46:39.185633', '2019-10-06 09:15:16.559662', NULL, '1970-01-01'),
 ('011105', 'Afschrijvingen Machines en installaties', 'A', 'A', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 17:38:50.633047', '2019-10-06 09:15:22.548243', NULL, '1970-01-01'),
 ('011000', 'Bedrijfsgebouwen en -terreinen', 'A', 'A', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 17:22:29.486662', '2019-10-06 09:14:04.257737', NULL, '1970-01-01'),
 ('010400', 'Goodwill', 'A', 'A', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 17:39:13.066282', '2019-10-06 09:11:39.473563', NULL, '1970-01-01'),
 ('011205', 'Afschrijvingen Auto', 'A', 'A', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 17:31:27.830371', '2019-10-06 09:16:00.73977', NULL, '1970-01-01'),
 ('011002', 'Investeringen Bedrijfsgebouwen en -terreinen', 'A', 'A', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 17:56:35.360422', '2019-10-06 09:14:12.706876', NULL, '1970-01-01'),
 ('011', 'Materiële vaste activa', 'H', ' ', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 17:50:34.757773', '2019-10-05 17:50:34.757773', NULL, '1970-01-01'),
 ('010', 'Immateriële vaste activa', 'H', ' ', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 17:51:21.911571', '2019-10-05 17:51:21.911571', NULL, '1970-01-01'),
 ('012000', 'Borg huur pand', 'A', 'A', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 19:07:36.929629', '2019-10-06 09:30:58.699544', NULL, '1970-01-01'),
 ('041102', 'Hypotheek opnamen', 'A', 'L', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 18:23:30.964349', '2019-10-06 15:52:39.072019', NULL, '1970-01-01'),
 ('302000', 'Voorraad onderhanden werk', 'A', 'A', '', 12, NULL, NULL, NULL, NULL, '2019-10-05 20:12:56.28959', '2019-10-07 20:23:00.904633', NULL, '1970-01-01'),
 ('134', 'Btw', 'H', ' ', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 19:52:15.34936', '2019-10-05 19:52:15.34936', NULL, '1970-01-01'),
 ('111000', 'ABN-AMRO doorlopend krediet', 'A', 'A', 'AR_paid:AP_paid', 0, NULL, NULL, NULL, NULL, '2019-10-05 18:30:55.849325', '2019-10-06 15:55:00.782464', NULL, '1970-01-01'),
 ('110000', 'Kas', 'A', 'A', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 18:30:07.895581', '2019-10-05 18:30:07.895581', NULL, '1970-01-01'),
 ('134003', 'Btw over leveringen / diensten belast met 0% of niet bij u belast', 'A', 'L', 'AR_tax:IC_taxpart', 0, NULL, NULL, NULL, NULL, '2019-10-05 19:55:08.515486', '2019-10-06 19:06:22.708222', NULL, '1970-01-01'),
 ('134007', 'Leveringen naar landen binnen de EU', 'A', 'A', 'AR_tax:IC_taxpart', 0, NULL, NULL, NULL, NULL, '2019-10-05 19:56:37.712153', '2019-10-06 19:13:37.572775', NULL, '1970-01-01'),
 ('115000', 'Tegoed Openprovider', 'A', 'A', 'AP_paid', 0, NULL, NULL, NULL, NULL, '2019-10-05 19:02:13.504339', '2019-10-06 15:56:08.192479', NULL, '1970-01-01'),
 ('910002', 'Privé opnamen', 'A', 'Q', 'AR_paid', 0, NULL, NULL, NULL, NULL, '2019-10-05 18:36:01.016943', '2019-10-06 15:57:42.431736', NULL, '1970-01-01'),
 ('910003', 'Privé stortingen', 'A', 'Q', 'AP_paid', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:19:54.047444', '2019-10-06 15:57:54.641737', NULL, '1970-01-01'),
 ('134011', 'Verwervingen van goederen uit landen binnen de EU', 'A', 'A', 'AP_tax:IC_taxpart', 0, NULL, NULL, NULL, NULL, '2019-10-05 19:58:33.647734', '2019-10-06 19:17:44.475833', NULL, '1970-01-01'),
 ('120000', 'Debiteuren', 'A', 'A', 'AR', 0, NULL, NULL, NULL, NULL, '2019-10-05 19:23:22.636444', '2019-10-06 16:12:27.331506', NULL, '1970-01-01'),
 ('134012', 'Btw voorbelasting 21%', 'A', 'A', 'AP_tax:IC_taxpart', 0, NULL, NULL, NULL, NULL, '2019-10-05 19:58:52.287653', '2019-10-06 19:20:09.486761', NULL, '1970-01-01'),
 ('11', 'Liquide middelen', 'H', ' ', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 18:38:53.485301', '2019-10-05 18:38:53.485301', NULL, '1970-01-01'),
 ('04', 'Langlopende Schulden', 'H', ' ', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 18:24:38.751143', '2019-10-05 18:39:16.187148', NULL, '1970-01-01'),
 ('134013', 'Btw voorbelasting 9%', 'A', 'A', 'AP_tax:IC_taxpart', 0, NULL, NULL, NULL, NULL, '2019-10-05 19:59:42.295883', '2019-10-06 19:23:06.650355', NULL, '1970-01-01'),
 ('011100', 'Machines en installaties', 'A', 'A', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 17:38:34.076779', '2019-10-07 20:21:39.449876', NULL, '1970-01-01'),
 ('03', 'Voorzieningen', 'H', ' ', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 18:39:43.185641', '2019-10-07 20:20:11.206416', NULL, '1970-01-01'),
 ('300000', 'Voorraad grondstoffen', 'A', 'A', 'IC', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:11:42.250192', '2019-10-07 19:14:37.095448', NULL, '1970-01-01'),
 ('041103', 'Hypotheek aflossing', 'A', 'L', '', 11, NULL, NULL, NULL, NULL, '2019-10-05 18:23:49.049765', '2019-10-07 20:18:36.685958', NULL, '1970-01-01'),
 ('134008', 'Leveringen naar/diensten in landen binnen de EU', 'A', 'A', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 19:57:37.980812', '2019-10-05 19:57:37.980812', NULL, '1970-01-01'),
 ('305000', 'Voorruitbetalingen op voorraden', 'A', 'A', '', 12, NULL, NULL, NULL, NULL, '2019-10-05 20:14:56.935921', '2019-10-07 19:34:22.804172', NULL, '1970-01-01'),
 ('134009', 'Installatie/afstandsverkopen binnen de EU', 'A', 'A', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 19:57:58.053625', '2019-10-05 19:57:58.053625', NULL, '1970-01-01'),
 ('112000', 'ABN-AMRO Spaarrekening TopDeposito ', 'A', 'A', 'AR_paid:AP_paid', 0, NULL, NULL, NULL, NULL, '2019-10-05 18:31:44.436659', '2019-10-07 20:35:25.903366', NULL, '1970-01-01'),
 ('012', 'Financiële vaste activa', 'H', ' ', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 19:05:48.798306', '2019-10-05 19:07:47.513529', NULL, '1970-01-01'),
 ('420001', 'Verzekeringskosten', 'A', 'E', 'AP_amount', 11, NULL, NULL, NULL, NULL, '2019-10-05 20:36:22.086132', '2019-10-15 22:58:47.775514', NULL, '1970-01-01'),
 ('301000', 'Voorraad hulpstoffen', 'A', 'A', 'AP_amount', 12, NULL, NULL, NULL, NULL, '2019-10-05 20:12:12.662618', '2019-10-08 19:51:09.836433', NULL, '1970-01-01'),
 ('401100', 'Afschrijving Machines', 'A', 'E', 'AP_amount', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:29:59.131922', '2019-10-15 23:00:28.31498', NULL, '1970-01-01'),
 ('134010', 'Leveringen uit landen buiten de EU (invoer)', 'A', 'A', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 19:58:18.841357', '2019-10-05 19:58:18.841357', NULL, '1970-01-01'),
 ('12', 'Kortlopende vorderingen', 'H', ' ', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 19:24:47.150092', '2019-10-05 19:24:47.150092', NULL, '1970-01-01'),
 ('440001', 'Autoverzekering', 'A', 'E', 'AP_amount', 11, NULL, NULL, NULL, NULL, '2019-10-05 20:46:54.006178', '2019-10-15 22:50:20.588549', NULL, '1970-01-01'),
 ('400300', 'Afschrijving Goodwill', 'A', 'E', 'AP_amount', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:28:36.097214', '2019-10-15 23:00:45.420277', NULL, '1970-01-01'),
 ('134014', 'Vermindering volgens de kleineondernemersregeling', 'A', 'A', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:00:06.538977', '2019-10-05 20:00:06.538977', NULL, '1970-01-01'),
 ('134015', 'Lokale btw in andere EU landen', 'A', 'A', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:00:24.20177', '2019-10-05 20:00:24.20177', NULL, '1970-01-01'),
 ('134016', 'Vrijgesteld van btw', 'A', 'A', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:00:41.424935', '2019-10-05 20:00:41.424935', NULL, '1970-01-01'),
 ('134017', 'Btw afdrachten', 'A', 'A', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:01:01.787093', '2019-10-05 20:01:01.787093', NULL, '1970-01-01'),
 ('134018', 'BTW fiscale eenheid', 'A', 'A', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:01:22.415199', '2019-10-05 20:01:22.415199', NULL, '1970-01-01'),
 ('134019', 'Te corrigeren btw', 'A', 'A', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:01:47.662062', '2019-10-05 20:01:47.662062', NULL, '1970-01-01'),
 ('20', 'Tussenrekeningen', 'H', ' ', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:09:18.285381', '2019-10-05 20:09:18.285381', NULL, '1970-01-01'),
 ('303000', 'Voorraad gereed product', 'A', 'A', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:13:36.886528', '2019-10-05 20:13:36.886528', NULL, '1970-01-01'),
 ('304000', 'Voorraad handelsgoederen', 'A', 'A', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:13:57.911222', '2019-10-05 20:13:57.911222', NULL, '1970-01-01'),
 ('30', 'Voorraden', 'H', ' ', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:14:23.447238', '2019-10-05 20:14:23.447238', NULL, '1970-01-01'),
 ('910000', 'Kapitaal Rob', 'A', 'Q', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 18:43:07.827343', '2019-10-05 20:17:16.360324', NULL, '1970-01-01'),
 ('910001', 'Resultaat huidig boekjaar', 'A', 'Q', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:20:27.348009', '2019-10-05 20:20:27.348009', NULL, '1970-01-01'),
 ('912018', 'Winst 2018', 'A', 'Q', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 17:37:43.792884', '2019-10-05 20:22:00.925859', NULL, '1970-01-01'),
 ('91', 'Eigen Vermogen v.o.f.', 'H', ' ', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 18:59:20.787325', '2019-10-05 20:20:52.992475', NULL, '1970-01-01'),
 ('912019', 'Winst 2019', 'A', 'Q', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 18:57:30.163197', '2019-10-05 20:22:09.480613', NULL, '1970-01-01'),
 ('400301', 'Boekwinst Goodwill', 'A', 'E', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:29:27.33491', '2019-10-05 20:29:27.33491', NULL, '1970-01-01'),
 ('401101', 'Boekwinst Machines', 'A', 'E', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:30:23.718409', '2019-10-05 20:30:23.718409', NULL, '1970-01-01'),
 ('401201', 'Boekwinst Auto', 'A', 'E', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:33:16.113963', '2019-10-05 20:33:16.113963', NULL, '1970-01-01'),
 ('40', 'Afschrijvingskosten', 'H', ' ', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:34:07.934272', '2019-10-05 20:34:07.934272', NULL, '1970-01-01'),
 ('900000', 'Bijzondere baten', 'A', 'I', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 21:18:57.309077', '2019-10-06 17:49:07.79576', NULL, '1970-01-01'),
 ('900001', 'Bijzondere lasten', 'A', 'E', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 21:19:16.703557', '2019-10-06 17:49:23.482908', NULL, '1970-01-01'),
 ('42', 'Huisvestingskosten', 'H', ' ', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:40:34.339575', '2019-10-05 20:40:44.356703', NULL, '1970-01-01'),
 ('134000', 'Btw over leveringen / diensten belast met 21%', 'A', 'L', 'AR_tax:IC_taxpart', 0, NULL, NULL, NULL, NULL, '2019-10-05 19:30:10.273149', '2019-10-06 19:10:40.2304', NULL, '1970-01-01'),
 ('45', 'Verkoopkosten', 'A', 'E', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:55:13.144502', '2019-10-05 20:55:13.144502', NULL, '1970-01-01'),
 ('430003', 'kleine aanschaffingen Machines', 'A', 'E', 'AP_amount', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:43:32.391321', '2019-10-15 22:54:41.411735', NULL, '1970-01-01'),
 ('43', 'Machine- en exploitatiekosten', 'H', ' ', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:45:18.084608', '2019-10-05 20:45:18.084608', NULL, '1970-01-01'),
 ('134002', 'Btw over leveringen / diensten belast met overige tarieven behalve 0%', 'A', 'L', 'AR_tax:IC_taxpart', 0, NULL, NULL, NULL, NULL, '2019-10-05 19:54:44.731538', '2019-10-06 19:04:45.717845', NULL, '1970-01-01'),
 ('134001', 'Btw over leveringen / diensten belast met 9%', 'A', 'L', 'AR_tax:IC_taxpart', 0, NULL, NULL, NULL, NULL, '2019-10-05 19:54:20.341113', '2019-10-06 19:08:24.193387', NULL, '1970-01-01'),
 ('460000', 'Kantoorbenodigdheden', 'A', 'E', 'AP_amount', 12, NULL, NULL, NULL, NULL, '2019-10-05 20:55:51.664938', '2019-10-15 21:44:19.005444', NULL, '1970-01-01'),
 ('440003', 'Boetes en bekeuringen', 'A', 'E', 'AP_amount', 11, NULL, NULL, NULL, NULL, '2019-10-05 20:47:51.261968', '2019-10-15 22:49:35.001275', NULL, '1970-01-01'),
 ('800300', 'Omzet uitbesteed werk', 'A', 'I', 'AR_amount:IC_sale:IC_income', 2, NULL, NULL, NULL, NULL, '2019-10-05 21:15:53.851186', '2019-10-15 21:37:45.809915', NULL, '1970-01-01'),
 ('440005', 'leasekosten', 'A', 'E', 'AP_amount', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:48:40.244666', '2019-10-15 22:48:55.56405', NULL, '1970-01-01'),
 ('490000', 'Bankkosten', 'A', 'E', 'AP_amount', 0, NULL, NULL, NULL, NULL, '2019-10-05 21:04:52.245813', '2019-10-15 22:38:51.732833', NULL, '1970-01-01'),
 ('44', 'Autokosten', 'H', ' ', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:50:08.901452', '2019-10-05 20:50:08.901452', NULL, '1970-01-01'),
 ('440006', 'Privé gebruik auto', 'A', 'E', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:49:16.778707', '2019-10-15 22:48:32.464581', NULL, '1970-01-01'),
 ('800100', 'Omzet Print/Copy', 'A', 'I', 'AR_amount:IC_sale:IC_income', 2, NULL, NULL, NULL, NULL, '2019-10-05 21:14:42.85245', '2019-10-15 21:36:47.718055', NULL, '1970-01-01'),
 ('450005', 'Reis-en verblijfkosten', 'A', 'E', 'AP_amount', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:53:33.471586', '2019-10-15 22:44:51.012188', NULL, '1970-01-01'),
 ('710000', 'Voorraadmutaties', 'A', 'C', '', 12, NULL, NULL, NULL, NULL, '2019-10-05 21:11:17.991056', '2019-10-07 19:33:35.678815', NULL, '1970-01-01'),
 ('450001', 'Kosten sponsoring', 'A', 'E', 'AP_amount', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:52:14.056166', '2019-10-15 22:45:49.32511', NULL, '1970-01-01'),
 ('700000', 'Inkoopwaarde van de omzet (inkooprijs van alle verkochte producten)', 'A', 'C', 'IC_cogs', 12, NULL, NULL, NULL, NULL, '2019-10-05 21:09:23.058108', '2019-10-07 20:18:01.410604', NULL, '1970-01-01'),
 ('470000', 'Branche specifieke kosten', 'A', 'E', 'AP_amount', 0, NULL, NULL, NULL, NULL, '2019-10-05 21:01:40.523694', '2019-10-15 22:42:47.411581', NULL, '1970-01-01'),
 ('450007', 'Vrachtkosten uitgaande zendingen', 'A', 'E', 'AP_amount', 12, NULL, NULL, NULL, NULL, '2019-10-05 20:54:43.642994', '2019-10-15 22:44:20.888882', NULL, '1970-01-01'),
 ('450003', 'Relatiegeschenken', 'A', 'E', 'AP_amount', 12, NULL, NULL, NULL, NULL, '2019-10-05 20:52:41.935497', '2019-10-15 22:45:33.391297', NULL, '1970-01-01'),
 ('460002', 'Onderhoud en reparaties kantoor', 'A', 'E', 'AP_amount', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:56:49.210248', '2019-10-15 22:43:34.861904', NULL, '1970-01-01'),
 ('440007', 'Btw privégebruik auto', 'A', 'E', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:49:40.414883', '2019-10-15 22:48:18.611519', NULL, '1970-01-01'),
 ('460003', 'Porti', 'A', 'E', 'AP_amount', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:57:14.869351', '2019-10-15 22:43:18.364558', NULL, '1970-01-01'),
 ('46', 'Kantoorkosten', 'A', 'E', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:58:03.942009', '2019-10-05 20:58:03.942009', NULL, '1970-01-01'),
 ('420005', 'Onroerende Zaak Belasting', 'A', 'E', 'AP_amount', 3, NULL, NULL, NULL, NULL, '2019-10-05 20:38:08.255574', '2019-10-15 22:57:43.246179', NULL, '1970-01-01'),
 ('800200', 'Omzet LFP', 'A', 'I', 'AR_amount:IC_sale:IC_income', 2, NULL, NULL, NULL, NULL, '2019-10-05 21:15:04.370371', '2019-10-15 21:37:22.672061', NULL, '1970-01-01'),
 ('480000', 'Abonnementen en contributies', 'A', 'E', 'AP_amount', 12, NULL, NULL, NULL, NULL, '2019-10-05 20:59:12.050074', '2019-10-15 22:42:29.040306', NULL, '1970-01-01'),
 ('800000', 'Omzet Offset', 'A', 'I', 'AR_amount:IC_sale:IC_income', 2, NULL, NULL, NULL, NULL, '2019-10-05 21:13:27.259415', '2019-10-15 21:36:23.138654', NULL, '1970-01-01'),
 ('480001', 'Verzekeringen algemeen', 'A', 'E', 'AP_amount', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:59:34.519555', '2019-10-15 22:42:16.055067', NULL, '1970-01-01'),
 ('48', 'Algemene kosten', 'H', ' ', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 21:01:10.026491', '2019-10-05 21:01:10.026491', NULL, '1970-01-01'),
 ('800400', 'Omzet diverse', 'A', 'I', 'AR_amount:IC_sale:IC_income', 2, NULL, NULL, NULL, NULL, '2019-10-05 21:16:30.648313', '2019-10-15 21:38:56.090297', NULL, '1970-01-01'),
 ('460004', 'Automatiseringskosten', 'A', 'E', 'AP_amount', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:57:38.450214', '2019-10-15 22:43:01.55404', NULL, '1970-01-01'),
 ('47', 'Branche specifieke kosten', 'H', ' ', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 21:01:57.248124', '2019-10-05 21:01:57.248124', NULL, '1970-01-01'),
 ('490010', 'Kosten Pin', 'A', 'E', 'AP_amount', 0, NULL, NULL, NULL, NULL, '2019-10-05 21:06:52.592416', '2019-10-15 22:36:51.412901', NULL, '1970-01-01'),
 ('480002', 'Administratiekosten', 'A', 'E', 'AP_amount', 0, NULL, NULL, NULL, NULL, '2019-10-05 21:00:03.951916', '2019-10-15 22:41:11.372147', NULL, '1970-01-01'),
 ('49', 'Bankkosten', 'H', ' ', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 21:05:15.904408', '2019-10-05 21:05:15.904408', NULL, '1970-01-01'),
 ('480003', 'Accountantskosten', 'A', 'E', 'AP_amount', 0, NULL, NULL, NULL, NULL, '2019-10-05 21:00:31.19455', '2019-10-15 22:39:22.479503', NULL, '1970-01-01'),
 ('460001', 'Communicatiekosten', 'A', 'E', 'AP_amount', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:56:16.303642', '2019-10-15 22:43:51.890288', NULL, '1970-01-01'),
 ('450006', 'Vrachtkosten inkomende zendingen', 'A', 'E', 'AP_amount', 12, NULL, NULL, NULL, NULL, '2019-10-05 20:54:26.521978', '2019-10-15 22:44:38.547509', NULL, '1970-01-01'),
 ('450004', 'Representatiekosten', 'A', 'E', 'AP_amount', 12, NULL, NULL, NULL, NULL, '2019-10-05 20:53:06.864367', '2019-10-15 22:45:20.558925', NULL, '1970-01-01'),
 ('450000', 'Reclame en advertentiekosten', 'A', 'E', 'AP_amount', 12, NULL, NULL, NULL, NULL, '2019-10-05 20:51:50.686672', '2019-10-15 22:45:59.978324', NULL, '1970-01-01'),
 ('440004', 'onderhoud en reparaties auto', 'A', 'E', 'AP_amount', 12, NULL, NULL, NULL, NULL, '2019-10-05 20:48:15.212318', '2019-10-15 22:49:15.469911', NULL, '1970-01-01'),
 ('440002', 'Motorrijtuigenbelasting', 'A', 'E', 'AP_amount', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:47:24.504052', '2019-10-15 22:50:04.011055', NULL, '1970-01-01'),
 ('440000', 'Brandstofkosten', 'A', 'E', 'AP_amount', 1, NULL, NULL, NULL, NULL, '2019-10-05 20:46:36.110166', '2019-10-15 22:51:23.475727', NULL, '1970-01-01'),
 ('430001', 'Service kosten Machines', 'A', 'E', 'AP_amount', 1, NULL, NULL, NULL, NULL, '2019-10-05 20:42:50.309104', '2019-10-15 22:53:13.239776', NULL, '1970-01-01'),
 ('430005', 'werk door derden', 'A', 'E', 'AP_amount', 11, NULL, NULL, NULL, NULL, '2019-10-05 20:45:56.576891', '2019-10-15 22:53:55.35897', NULL, '1970-01-01'),
 ('430004', 'gereedschapskosten Machines', 'A', 'E', 'AP_amount', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:44:12.154811', '2019-10-15 22:54:53.02565', NULL, '1970-01-01'),
 ('80', 'netto Omzet', 'H', ' ', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 21:18:27.352921', '2019-10-05 21:18:27.352921', NULL, '1970-01-01'),
 ('430000', 'Onderhoud en reparaties Machines', 'A', 'E', 'AP_amount', 12, NULL, NULL, NULL, NULL, '2019-10-05 20:42:04.250308', '2019-10-15 22:55:41.097854', NULL, '1970-01-01'),
 ('420007', 'Service kosten huur reclamebord', 'A', 'E', 'AP_amount', 12, NULL, NULL, NULL, NULL, '2019-10-05 20:38:48.536395', '2019-10-15 22:56:45.459157', NULL, '1970-01-01'),
 ('420008', 'Overige huisvestingskosten', 'A', 'E', 'AP_amount', 12, NULL, NULL, NULL, NULL, '2019-10-05 20:39:51.119389', '2019-10-15 22:57:07.120274', NULL, '1970-01-01'),
 ('420003', 'Gas, water en electra', 'A', 'E', 'AP_amount', 12, NULL, NULL, NULL, NULL, '2019-10-05 20:37:42.946543', '2019-10-15 22:58:08.9084', NULL, '1970-01-01'),
 ('420002', 'Onderhoud en reparaties huisvestiging', 'A', 'E', 'AP_amount', 12, NULL, NULL, NULL, NULL, '2019-10-05 20:37:15.017178', '2019-10-15 22:58:27.89714', NULL, '1970-01-01'),
 ('420000', 'Betaalde huur', 'A', 'E', 'AP_amount', 12, NULL, NULL, NULL, NULL, '2019-10-05 20:35:31.719914', '2019-10-15 22:59:16.836562', NULL, '1970-01-01'),
 ('011005', 'Afschrijvingen Bedrijfsgebouwen en -terreinen', 'A', 'A', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 17:23:20.772402', '2019-10-06 09:14:22.42031', NULL, '1970-01-01'),
 ('90', 'Bijzondere baten/lasten', 'H', ' ', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 21:19:44.549995', '2019-10-05 21:19:53.553526', NULL, '1970-01-01'),
 ('401200', 'Afschrijving Auto', 'A', 'E', 'AP_amount', 0, NULL, NULL, NULL, NULL, '2019-10-05 20:32:48.136794', '2019-10-15 23:00:12.958318', NULL, '1970-01-01'),
 ('010405', 'Afschrijvingen Goodwill', 'A', 'A', '', 0, NULL, NULL, NULL, NULL, '2019-10-05 17:39:28.07304', '2019-10-06 09:13:48.298231', NULL, '1970-01-01');

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

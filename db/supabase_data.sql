--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8
-- Dumped by pg_dump version 15.13 (Homebrew)

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
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO auth.schema_migrations VALUES ('20171026211738');
INSERT INTO auth.schema_migrations VALUES ('20171026211808');
INSERT INTO auth.schema_migrations VALUES ('20171026211834');
INSERT INTO auth.schema_migrations VALUES ('20180103212743');
INSERT INTO auth.schema_migrations VALUES ('20180108183307');
INSERT INTO auth.schema_migrations VALUES ('20180119214651');
INSERT INTO auth.schema_migrations VALUES ('20180125194653');
INSERT INTO auth.schema_migrations VALUES ('00');
INSERT INTO auth.schema_migrations VALUES ('20210710035447');
INSERT INTO auth.schema_migrations VALUES ('20210722035447');
INSERT INTO auth.schema_migrations VALUES ('20210730183235');
INSERT INTO auth.schema_migrations VALUES ('20210909172000');
INSERT INTO auth.schema_migrations VALUES ('20210927181326');
INSERT INTO auth.schema_migrations VALUES ('20211122151130');
INSERT INTO auth.schema_migrations VALUES ('20211124214934');
INSERT INTO auth.schema_migrations VALUES ('20211202183645');
INSERT INTO auth.schema_migrations VALUES ('20220114185221');
INSERT INTO auth.schema_migrations VALUES ('20220114185340');
INSERT INTO auth.schema_migrations VALUES ('20220224000811');
INSERT INTO auth.schema_migrations VALUES ('20220323170000');
INSERT INTO auth.schema_migrations VALUES ('20220429102000');
INSERT INTO auth.schema_migrations VALUES ('20220531120530');
INSERT INTO auth.schema_migrations VALUES ('20220614074223');
INSERT INTO auth.schema_migrations VALUES ('20220811173540');
INSERT INTO auth.schema_migrations VALUES ('20221003041349');
INSERT INTO auth.schema_migrations VALUES ('20221003041400');
INSERT INTO auth.schema_migrations VALUES ('20221011041400');
INSERT INTO auth.schema_migrations VALUES ('20221020193600');
INSERT INTO auth.schema_migrations VALUES ('20221021073300');
INSERT INTO auth.schema_migrations VALUES ('20221021082433');
INSERT INTO auth.schema_migrations VALUES ('20221027105023');
INSERT INTO auth.schema_migrations VALUES ('20221114143122');
INSERT INTO auth.schema_migrations VALUES ('20221114143410');
INSERT INTO auth.schema_migrations VALUES ('20221125140132');
INSERT INTO auth.schema_migrations VALUES ('20221208132122');
INSERT INTO auth.schema_migrations VALUES ('20221215195500');
INSERT INTO auth.schema_migrations VALUES ('20221215195800');
INSERT INTO auth.schema_migrations VALUES ('20221215195900');
INSERT INTO auth.schema_migrations VALUES ('20230116124310');
INSERT INTO auth.schema_migrations VALUES ('20230116124412');
INSERT INTO auth.schema_migrations VALUES ('20230131181311');
INSERT INTO auth.schema_migrations VALUES ('20230322519590');
INSERT INTO auth.schema_migrations VALUES ('20230402418590');
INSERT INTO auth.schema_migrations VALUES ('20230411005111');
INSERT INTO auth.schema_migrations VALUES ('20230508135423');
INSERT INTO auth.schema_migrations VALUES ('20230523124323');
INSERT INTO auth.schema_migrations VALUES ('20230818113222');
INSERT INTO auth.schema_migrations VALUES ('20230914180801');
INSERT INTO auth.schema_migrations VALUES ('20231027141322');
INSERT INTO auth.schema_migrations VALUES ('20231114161723');
INSERT INTO auth.schema_migrations VALUES ('20231117164230');
INSERT INTO auth.schema_migrations VALUES ('20240115144230');
INSERT INTO auth.schema_migrations VALUES ('20240214120130');
INSERT INTO auth.schema_migrations VALUES ('20240306115329');
INSERT INTO auth.schema_migrations VALUES ('20240314092811');
INSERT INTO auth.schema_migrations VALUES ('20240427152123');
INSERT INTO auth.schema_migrations VALUES ('20240612123726');
INSERT INTO auth.schema_migrations VALUES ('20240729123726');
INSERT INTO auth.schema_migrations VALUES ('20240802193726');
INSERT INTO auth.schema_migrations VALUES ('20240806073726');
INSERT INTO auth.schema_migrations VALUES ('20241009103726');


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: brands; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.brands VALUES (2, 'Centurion Labz', NULL, 'https://centurionlabz.com/', NULL, 'centurion-labz', '2025-05-08 21:37:00', '2025-05-08 21:37:00', false);
INSERT INTO public.brands VALUES (3, 'Nutrex Research', NULL, 'https://nutrex.com/', NULL, 'nutrex-research', '2025-05-08 21:45:52', '2025-05-08 21:45:52', false);
INSERT INTO public.brands VALUES (5, 'Gorilla Mind', NULL, 'https://gorillamind.com/', NULL, 'gorilla-mind', '2025-05-08 21:47:02', '2025-05-08 21:47:02', false);
INSERT INTO public.brands VALUES (6, 'Frontline Formulations', NULL, 'https://frontlineformulations.com/', NULL, 'frontline-formulations', '2025-05-08 21:47:24', '2025-05-08 21:47:24', false);
INSERT INTO public.brands VALUES (9, 'SAN Nutrition', NULL, 'https://www.sann.net/', NULL, 'san-nutrition', '2025-05-08 21:48:37', '2025-05-08 21:48:37', false);
INSERT INTO public.brands VALUES (10, 'Axe & Sledge', NULL, 'https://axeandsledge.com/', NULL, 'axe-sledge', '2025-05-08 21:49:11', '2025-05-08 21:49:11', false);
INSERT INTO public.brands VALUES (12, 'Inno Supps', NULL, 'https://www.innosupps.com/', NULL, 'inno-supps', '2025-05-08 21:50:30', '2025-05-08 21:50:30', false);
INSERT INTO public.brands VALUES (13, 'Panda Supps', NULL, 'https://www.pandasupps.com/', NULL, 'panda-supps', '2025-05-08 21:50:45', '2025-05-08 21:50:45', false);
INSERT INTO public.brands VALUES (14, 'Avry Labs', NULL, 'https://www.avrylabs.com/', NULL, 'avry-labs', '2025-05-08 21:51:07', '2025-05-08 21:51:07', false);
INSERT INTO public.brands VALUES (15, 'Black Magic Supply', NULL, 'https://www.blackmagicsupps.com/', NULL, 'black-magic-supply', '2025-05-08 21:51:25', '2025-05-08 21:51:25', false);
INSERT INTO public.brands VALUES (16, 'Bucked Up', NULL, 'https://www.buckedup.com/', NULL, 'bucked-up', '2025-05-08 21:51:40', '2025-05-08 21:51:40', false);
INSERT INTO public.brands VALUES (17, 'Blk Flg', NULL, 'https://blkflg.com/', NULL, 'blk-flg', '2025-05-08 21:52:02', '2025-05-08 21:52:02', false);
INSERT INTO public.brands VALUES (18, 'Formulation Factory', NULL, 'https://formulationfactory.com/', NULL, 'formulation-factory', '2025-05-08 21:52:26', '2025-05-08 21:52:26', false);
INSERT INTO public.brands VALUES (19, 'Klerpath Nutrition', NULL, 'https://klerpath.com/', NULL, 'klerpath-nutrition', '2025-05-08 21:53:18', '2025-05-08 21:53:18', false);
INSERT INTO public.brands VALUES (20, 'Nutristat', NULL, 'https://nutristat.com/', NULL, 'nutristat', '2025-05-08 21:53:54', '2025-05-08 21:53:54', false);
INSERT INTO public.brands VALUES (21, 'Bullfit', NULL, 'https://bullfit.com/', NULL, 'bullfit', '2025-05-08 21:54:11', '2025-05-08 21:54:11', false);
INSERT INTO public.brands VALUES (22, 'Revolution Nutrition', NULL, 'https://revolution-nutrition.com/', NULL, 'revolution-nutrition', '2025-05-08 21:54:31', '2025-05-08 21:54:31', false);
INSERT INTO public.brands VALUES (24, 'Ryse Supplements', NULL, 'https://rysesupps.com/', NULL, 'ryse-supplements', '2025-05-08 21:55:09', '2025-05-08 21:55:09', false);
INSERT INTO public.brands VALUES (25, 'Transparent Labs', NULL, 'https://www.transparentlabs.com/', NULL, 'transparent-labs', '2025-05-08 21:56:52', '2025-05-08 21:56:52', false);
INSERT INTO public.brands VALUES (26, 'Steel Supplements', NULL, 'https://steelsupplements.com/', NULL, 'steel-supplements', '2025-05-08 21:57:15', '2025-05-08 21:57:15', false);
INSERT INTO public.brands VALUES (27, 'White Lion Labs', NULL, 'https://whitelionlabs.com/', NULL, 'white-lion-labs', '2025-05-08 21:57:33', '2025-05-08 21:57:33', false);
INSERT INTO public.brands VALUES (28, 'Gaspari Nutrition', NULL, 'https://gasparinutrition.com/', NULL, 'gaspari-nutrition', '2025-05-08 21:57:50', '2025-05-08 21:57:50', false);
INSERT INTO public.brands VALUES (29, 'Wave Supplement', NULL, 'https://www.wavesupplement.co/', NULL, 'wave-supplement', '2025-05-08 21:58:19', '2025-05-08 21:58:19', false);
INSERT INTO public.brands VALUES (30, 'Global Formulas', NULL, 'https://globalformulas.com/', NULL, 'global-formulas', '2025-05-08 21:58:38', '2025-05-08 21:58:38', false);
INSERT INTO public.brands VALUES (31, 'Black Market Labs', NULL, 'https://blackmarketlabs.com/', NULL, 'black-market-labs', '2025-05-08 21:58:55', '2025-05-08 21:58:55', false);
INSERT INTO public.brands VALUES (32, 'GAT Sport', NULL, 'https://gatsport.com/', NULL, 'gat-sport', '2025-05-08 21:59:09', '2025-05-08 21:59:09', false);
INSERT INTO public.brands VALUES (33, 'Enhanced Labs', NULL, 'https://enhancedlabs.com/', NULL, 'enhanced-labs', '2025-05-08 21:59:27', '2025-05-08 21:59:27', false);
INSERT INTO public.brands VALUES (34, 'NutraBio', NULL, 'https://nutrabio.com/', NULL, 'nutrabio', '2025-05-08 21:59:43', '2025-05-08 21:59:43', false);
INSERT INTO public.brands VALUES (35, 'Kaged', NULL, 'https://www.kaged.com/', NULL, 'kaged', '2025-05-08 22:00:06', '2025-05-08 22:00:06', false);
INSERT INTO public.brands VALUES (36, 'Redsalt', NULL, 'https://redsaltsupps.com/', NULL, 'redsalt', '2025-05-08 22:00:20', '2025-05-08 22:00:20', false);
INSERT INTO public.brands VALUES (37, 'Titan Nutrition', NULL, 'https://titannutrition.net/', NULL, 'titan-nutrition', '2025-05-08 22:00:37', '2025-05-08 22:00:37', false);
INSERT INTO public.brands VALUES (38, 'Iron Outlaws', NULL, 'https://ironoutlaws.com/', NULL, 'iron-outlaws', '2025-05-08 22:01:17', '2025-05-08 22:01:17', false);
INSERT INTO public.brands VALUES (39, 'Core Nutritionals', NULL, 'https://www.corenutritionals.com/', NULL, 'core-nutritionals', '2025-05-08 22:01:44', '2025-05-08 22:01:44', false);
INSERT INTO public.brands VALUES (40, 'Shifted', NULL, 'https://getshifted.com/', NULL, 'shifted', '2025-05-08 22:02:19', '2025-05-08 22:02:19', false);
INSERT INTO public.brands VALUES (41, 'EFX Sports', NULL, 'https://efxsports.com/', NULL, 'efx-sports', '2025-05-08 22:02:38', '2025-05-08 22:02:38', false);
INSERT INTO public.brands VALUES (42, 'Metabolic Nutrition', NULL, 'https://metabolicnutrition.com/', NULL, 'metabolic-nutrition', '2025-05-08 22:03:02', '2025-05-08 22:03:02', false);
INSERT INTO public.brands VALUES (43, 'MuscleSport', NULL, 'https://musclesport.com/', NULL, 'musclesport', '2025-05-08 22:03:24', '2025-05-08 22:03:24', false);
INSERT INTO public.brands VALUES (44, 'Huge Supplements', NULL, 'https://hugesupplements.com/', NULL, 'huge-supplements', '2025-05-08 22:03:39', '2025-05-08 22:03:39', false);
INSERT INTO public.brands VALUES (45, 'Complete Nutrition', NULL, 'https://completenutrition.com/', NULL, 'complete-nutrition', '2025-05-08 22:04:03', '2025-05-08 22:04:03', false);
INSERT INTO public.brands VALUES (46, 'Psycho Pharma', NULL, 'https://www.psychopharma.com/', NULL, 'psycho-pharma', '2025-05-08 22:04:25', '2025-05-08 22:04:25', false);
INSERT INTO public.brands VALUES (47, 'Ninja', NULL, 'https://ninjaup.com/', NULL, 'ninja', '2025-05-08 22:04:43', '2025-05-08 22:04:43', false);
INSERT INTO public.brands VALUES (49, 'Swolverine', NULL, 'https://swolverine.com/', NULL, 'swolverine', '2025-05-08 22:05:16', '2025-05-08 22:05:16', false);
INSERT INTO public.brands VALUES (50, 'NG Nutra', NULL, 'https://ngnutra.com/', NULL, 'ng-nutra', '2025-05-08 22:05:31', '2025-05-08 22:05:31', false);
INSERT INTO public.brands VALUES (51, 'Millecor', NULL, 'https://millecor.com/', NULL, 'millecor', '2025-05-08 22:05:45', '2025-05-08 22:05:45', false);
INSERT INTO public.brands VALUES (52, 'Ghost', NULL, 'https://www.ghostlifestyle.com/', NULL, 'ghost', '2025-05-08 22:06:16', '2025-05-08 22:06:16', false);
INSERT INTO public.brands VALUES (53, 'Cellucor', NULL, 'https://cellucor.com/', NULL, 'cellucor', '2025-05-08 22:06:46', '2025-05-08 22:06:46', false);
INSERT INTO public.brands VALUES (54, 'Legion Athletics', NULL, 'https://legionathletics.com/', NULL, 'legion-athletics', '2025-05-08 22:07:06', '2025-05-08 22:07:06', false);
INSERT INTO public.brands VALUES (55, 'Build Fast Formula', NULL, 'https://buildfastformula.com/', NULL, 'build-fast-formula', '2025-05-08 22:07:24', '2025-05-08 22:07:24', false);
INSERT INTO public.brands VALUES (71, '1st Phorm', NULL, 'https://1stphorm.com/', NULL, '1st-phorm', '2025-05-08 22:35:37', '2025-05-11 21:28:20', true);
INSERT INTO public.brands VALUES (57, 'Onnit', NULL, 'https://www.onnit.com/', NULL, 'onnit', '2025-05-08 22:08:31', '2025-05-08 22:08:31', false);
INSERT INTO public.brands VALUES (58, 'Type Zero Health', NULL, 'https://typezerohealth.com/', NULL, 'type-zero-health', '2025-05-08 22:08:47', '2025-05-08 22:08:47', false);
INSERT INTO public.brands VALUES (59, 'Condemned Labz', NULL, 'https://condemnedlabz.com/', NULL, 'condemned-labz', '2025-05-08 22:09:05', '2025-05-08 22:09:05', false);
INSERT INTO public.brands VALUES (60, 'Reach Supplements', NULL, 'https://reachsupps.com/', NULL, 'reach-supplements', '2025-05-08 22:09:23', '2025-05-08 22:09:23', false);
INSERT INTO public.brands VALUES (61, 'Zim Fit', NULL, 'https://zimfitusa.com/', NULL, 'zim-fit', '2025-05-08 22:09:37', '2025-05-08 22:09:37', false);
INSERT INTO public.brands VALUES (62, 'Bare Performance Nutrition', NULL, 'https://www.bareperformancenutrition.com/', NULL, 'bare-performance-nutrition', '2025-05-08 22:10:04', '2025-05-08 22:10:04', false);
INSERT INTO public.brands VALUES (64, 'We Go Home', NULL, 'https://wegohomesupps.com/', NULL, 'we-go-home', '2025-05-08 22:10:43', '2025-05-08 22:10:43', false);
INSERT INTO public.brands VALUES (65, 'JYM Supplements', NULL, 'https://jymsupplementscience.com/', NULL, 'jym-supplements', '2025-05-08 22:11:01', '2025-05-08 22:11:01', false);
INSERT INTO public.brands VALUES (66, 'Redcon1', NULL, 'https://redcon1.com/', NULL, 'redcon1', '2025-05-08 22:11:20', '2025-05-08 22:11:20', false);
INSERT INTO public.brands VALUES (67, 'Granite Nutrition', NULL, 'https://granitenutrition.com/', NULL, 'granite-nutrition', '2025-05-08 22:11:39', '2025-05-08 22:11:39', false);
INSERT INTO public.brands VALUES (137, 'Frenetik Labs', NULL, 'https://frenetiklabs.com/', NULL, 'frenetik-labs', '2025-05-14 15:48:20', '2025-05-14 15:48:20', false);
INSERT INTO public.brands VALUES (70, 'Magnum', NULL, 'https://magnumsupps.com', NULL, 'magnum', '2025-05-08 22:13:43', '2025-05-08 22:13:43', false);
INSERT INTO public.brands VALUES (23, '5% Nutrition', NULL, 'https://5percentnutrition.com/', NULL, '5-nutrition', '2025-05-08 21:54:50', '2025-05-14 17:06:46', true);
INSERT INTO public.brands VALUES (8, 'AI Nutrition', NULL, 'https://ainutrition.com/', NULL, 'ai-nutrition', '2025-05-08 21:48:17', '2025-05-14 22:11:40', true);
INSERT INTO public.brands VALUES (63, 'Alpha Country', NULL, 'https://thealphacountry.com/', NULL, 'alpha-country', '2025-05-08 22:10:24', '2025-05-14 22:21:05', true);
INSERT INTO public.brands VALUES (4, 'Alpha Lion', NULL, 'https://www.alphalion.com/', NULL, 'alpha-lion', '2025-05-08 21:46:20', '2025-05-18 00:26:44', true);
INSERT INTO public.brands VALUES (11, 'Anabolic Warfare', NULL, 'https://anabolicwarfare.defynedbrands.com/', NULL, 'anabolic-warfare', '2025-05-08 21:50:13', '2025-05-18 02:29:19', true);
INSERT INTO public.brands VALUES (1, 'Animal Pak', NULL, 'https://www.animalpak.com/', 'Animal Pak Supplements', 'animal-pak', '2025-04-30 22:52:44', '2025-05-24 18:58:06', true);
INSERT INTO public.brands VALUES (7, 'AN Performance', NULL, 'https://ansupps.com/', NULL, 'an-performance', '2025-05-08 21:47:48', '2025-05-24 19:47:56', true);
INSERT INTO public.brands VALUES (48, 'Apollon Nutrition', NULL, 'https://www.apollonnutrition.com/', NULL, 'apollon-nutrition', '2025-05-08 22:05:00', '2025-05-24 20:17:05', true);


--
-- Data for Name: ingredients; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ingredients VALUES (197, 'Creatine', 'A naturally occurring compound found in muscle cells that helps produce energy during high-intensity exercise and heavy lifting. Considered one of the most researched and effective supplements available.', 'Increases strength, power output, and muscle size; improves high-intensity exercise performance; supports ATP regeneration', 'creatine', '2025-05-11 02:13:56', '2025-05-11 02:13:56');
INSERT INTO public.ingredients VALUES (198, 'L-Citrulline', 'An amino acid that converts to L-arginine in the body, leading to increased nitric oxide production and vasodilation. Often preferred over direct L-arginine supplementation due to better absorption.', 'Enhances nitric oxide production; improves blood flow and oxygen delivery; reduces muscle soreness; may increase exercise performance', 'l-citrulline', '2025-05-11 02:13:56', '2025-05-11 02:13:56');
INSERT INTO public.ingredients VALUES (199, 'Beta Alanine', 'A non-essential amino acid that combines with histidine to form carnosine, which helps buffer acid in muscles. Known for causing harmless tingling sensation (paresthesia) when consumed.', 'Increases muscle carnosine levels; buffers lactic acid; improves exercise endurance; enhances performance in high-intensity activities lasting 1-4 minutes', 'beta-alanine', '2025-05-11 02:13:56', '2025-05-11 02:13:56');
INSERT INTO public.ingredients VALUES (200, 'Betaine Anhydrous', 'A naturally occurring compound found in foods like beets, spinach, and whole grains. Works as an osmolyte to maintain cell hydration and as a methyl donor in many biological processes.', 'Enhances protein synthesis; may increase strength and power output; supports hydration at cellular level; potential fat loss effects', 'betaine-anhydrous', '2025-05-11 02:13:56', '2025-05-11 02:13:56');
INSERT INTO public.ingredients VALUES (201, 'L-Taurine', 'A conditionally essential amino acid with antioxidant properties. Helps regulate water balance, mineral levels, and supports proper muscle function including heart muscle.', 'Supports cell hydration; reduces oxidative stress; improves endurance; enhances recovery; supports cardiovascular function', 'l-taurine', '2025-05-11 02:13:56', '2025-05-11 02:13:56');
INSERT INTO public.ingredients VALUES (202, 'L-Tyrosine', 'An amino acid that serves as a precursor to dopamine, adrenaline, and noradrenaline. Particularly effective during high-stress situations or sleep deprivation.', 'Supports cognitive function during stress; maintains mental performance; helps produce neurotransmitters; may reduce stress symptoms', 'l-tyrosine', '2025-05-11 02:13:56', '2025-05-11 02:13:56');
INSERT INTO public.ingredients VALUES (203, 'L-Arginine', 'An amino acid involved in nitric oxide production, though less effective than citrulline for this purpose due to poor absorption when taken orally. Has roles in wound healing and immune function.', 'Precursor to nitric oxide; may enhance blood flow; supports immune function; assists in protein synthesis', 'l-arginine', '2025-05-11 02:13:57', '2025-05-11 02:13:57');
INSERT INTO public.ingredients VALUES (204, 'L-Theanine', 'An amino acid found primarily in tea leaves that crosses the blood-brain barrier. Creates a state of relaxed alertness and synergizes well with caffeine by reducing jitters and crash.', 'Promotes calm alertness; reduces stress without sedation; smooths out caffeine side effects; improves focus when paired with caffeine', 'l-theanine', '2025-05-11 02:13:57', '2025-05-11 02:13:57');
INSERT INTO public.ingredients VALUES (205, 'Caffeine Anhydrous', 'A dehydrated form of caffeine that is more concentrated and faster-absorbing than regular caffeine. Works by blocking adenosine receptors in the brain and stimulating the central nervous system.', 'Increases alertness and energy; enhances focus and concentration; improves endurance performance; reduces perceived exertion; mobilizes fat for energy', 'caffeine-anhydrous', '2025-05-11 02:13:57', '2025-05-11 02:13:57');
INSERT INTO public.ingredients VALUES (206, 'Choline Bitartrate', 'A form of choline, an essential nutrient that serves as a building block for acetylcholine, a neurotransmitter important for muscle control and cognitive function.', 'Supports cognitive function; enhances mind-muscle connection; precursor to acetylcholine; may improve exercise performance', 'choline-bitartrate', '2025-05-11 02:13:57', '2025-05-11 02:13:57');
INSERT INTO public.ingredients VALUES (207, 'Theacrine', 'A naturally occurring compound with a structure similar to caffeine, found in Kucha tea. Provides energy and cognitive enhancement with reduced risk of habituation compared to caffeine.', 'Provides sustained energy without tolerance development; enhances mood and focus; similar to caffeine but with less crash', 'theacrine', '2025-05-11 02:13:57', '2025-05-11 02:13:57');
INSERT INTO public.ingredients VALUES (208, 'Theobromine', 'A compound found in cocoa that is similar to caffeine but with milder, longer-lasting effects. Works as a vasodilator and may support cardiovascular health.', 'Mild stimulant effects; smoother energy than caffeine; supports vasodilation; potential mood enhancement', 'theobromine', '2025-05-11 02:13:57', '2025-05-11 02:13:57');
INSERT INTO public.ingredients VALUES (209, 'Alpha GPC', 'A choline-containing compound that readily crosses the blood-brain barrier. Delivers choline to the brain more effectively than choline bitartrate, supporting cognitive function and strength performance.', 'Increases acetylcholine levels; enhances cognitive function; may improve power output; supports cellular membrane health', 'alpha-gpc', '2025-05-11 02:13:57', '2025-05-11 02:13:57');
INSERT INTO public.ingredients VALUES (210, 'Huperzine A', 'A compound extracted from Chinese club moss that works as an acetylcholinesterase inhibitor, preventing the breakdown of acetylcholine and thereby increasing its levels in the brain.', 'Inhibits acetylcholine breakdown; enhances focus and mental clarity; may improve memory; increases muscle contraction efficiency', 'huperzine-a', '2025-05-11 02:13:57', '2025-05-11 02:13:57');
INSERT INTO public.ingredients VALUES (211, 'AstraGin', 'A proprietary blend of astragalus and panax notoginseng that has been shown to improve absorption of various nutrients including amino acids, vitamins, and minerals.', 'Enhances nutrient absorption; improves uptake of amino acids; may increase ATP production; supports gut health', 'astragin', '2025-05-11 02:13:57', '2025-05-11 02:13:57');
INSERT INTO public.ingredients VALUES (212, 'InnovaTea', NULL, NULL, 'innovatea', '2025-05-11 02:13:57', '2025-05-11 02:13:57');
INSERT INTO public.ingredients VALUES (213, 'Agmatine Sulfate', 'A metabolite of L-arginine that helps regulate nitric oxide synthase enzymes, potentially increasing nitric oxide production and enhancing blood flow to working muscles.', 'Enhances nitric oxide production; supports pain management; may enhance muscle pumps; potential cognitive benefits', 'agmatine-sulfate', '2025-05-11 02:13:57', '2025-05-11 02:13:57');
INSERT INTO public.ingredients VALUES (214, 'Yohimbine', 'An alkaloid derived from the bark of the yohimbe tree that blocks alpha-2 adrenergic receptors, potentially increasing fat burning, especially in "stubborn" fat areas. Can increase heart rate and anxiety in some individuals.', 'Promotes fat loss, especially from stubborn areas; increases adrenaline levels; may enhance physical performance', 'yohimbine', '2025-05-11 02:13:57', '2025-05-11 02:13:57');
INSERT INTO public.ingredients VALUES (215, 'Citrafuze', NULL, NULL, 'citrafuze', '2025-05-11 02:13:58', '2025-05-11 02:13:58');
INSERT INTO public.ingredients VALUES (216, 'Di-Caffeine Malate', NULL, NULL, 'di-caffeine-malate', '2025-05-11 02:13:58', '2025-05-11 02:13:58');
INSERT INTO public.ingredients VALUES (217, 'D-Aspartic Acid', 'An amino acid that plays a role in hormone production, particularly testosterone. Often used by men looking to support natural testosterone levels.', 'May temporarily increase testosterone levels; supports hormone production; potential benefits for muscle growth and recovery', 'd-aspartic-acid', '2025-05-11 02:13:58', '2025-05-11 02:13:58');
INSERT INTO public.ingredients VALUES (218, 'DMAE', 'Dimethylaminoethanol is a compound that may increase acetylcholine production in the brain, potentially enhancing cognitive function and focus during workouts.', 'Enhances cognitive function; may improve mood; supports skin health; precursor to acetylcholine', 'dmae', '2025-05-11 02:13:58', '2025-05-11 02:13:58');
INSERT INTO public.ingredients VALUES (219, 'N-Phenethyl Dimethylamine Citrate', NULL, NULL, 'n-phenethyl-dimethylamine-citrate', '2025-05-11 02:13:58', '2025-05-11 02:13:58');
INSERT INTO public.ingredients VALUES (220, 'L-Norvaline', NULL, NULL, 'l-norvaline', '2025-05-11 02:13:58', '2025-05-11 02:13:58');
INSERT INTO public.ingredients VALUES (221, 'Beta Phenylethylamine HCL', NULL, NULL, 'beta-phenylethylamine-hcl', '2025-05-11 02:13:58', '2025-05-11 02:13:58');
INSERT INTO public.ingredients VALUES (223, 'GBB (Gamma Butyrobetaine Ethyl Ester)', NULL, NULL, 'gbb-gamma-butyrobetaine-ethyl-ester', '2025-05-11 02:13:58', '2025-05-11 02:13:58');
INSERT INTO public.ingredients VALUES (222, 'Mucuna Pruriens', 'A tropical legume containing L-DOPA, a precursor to dopamine. May support hormone levels, mood, and motivation for workouts. Also called velvet bean.', 'Natural source of L-DOPA; may support dopamine levels; potential testosterone support; mood enhancement', 'mucuna-pruriens', '2025-05-11 02:13:58', '2025-05-11 02:13:58');
INSERT INTO public.ingredients VALUES (232, 'Acetyl-L-Carnitine', 'A more bioavailable form of L-carnitine that better crosses the blood-brain barrier. Helps transport fatty acids into mitochondria for energy production and offers neuroprotective benefits.', 'Supports fat metabolism; may enhance cognitive function; reduces mental fatigue; aids recovery from exercise', 'acetyl-l-carnitine', '2025-05-11 02:13:59', '2025-05-11 02:13:59');
INSERT INTO public.ingredients VALUES (242, 'Ashwagandha', 'An adaptogenic herb used in Ayurvedic medicine that helps the body manage stress. May support testosterone levels, reduce cortisol, and improve recovery and power output.', 'Reduces stress and cortisol levels; supports hormone balance; may increase strength and recovery; enhances cognitive function under stress', 'ashwagandha', '2025-05-11 02:14:00', '2025-05-11 02:14:00');
INSERT INTO public.ingredients VALUES (252, 'PurCaf', 'An organic caffeine extracted from green coffee beans that provides the stimulant benefits of caffeine from a natural source rather than synthetic production.', 'Provides clean, natural caffeine; increases energy and alertness; enhances focus; derived from organic coffee', 'purcaf', '2025-05-11 02:14:01', '2025-05-11 02:14:01');
INSERT INTO public.ingredients VALUES (224, 'Green Tea Leaf Extract', 'Contains catechins (particularly EGCG) and a moderate amount of caffeine, supporting fat metabolism, providing antioxidant effects, and offering a milder stimulant effect than synthetic caffeine.', 'Provides antioxidants; supports metabolism; enhances fat oxidation; moderate caffeine content; cardiovascular benefits', 'green-tea-leaf-extract', '2025-05-11 02:13:59', '2025-05-11 02:13:59');
INSERT INTO public.ingredients VALUES (234, 'Potassium Dodecanedioate', NULL, NULL, 'potassium-dodecanedioate', '2025-05-11 02:14:00', '2025-05-11 02:14:00');
INSERT INTO public.ingredients VALUES (244, 'Lion''s Mane', 'A medicinal mushroom that contains compounds that may stimulate nerve growth factor (NGF) production, supporting brain health and cognitive function during exercise.', 'Supports cognitive function; may enhance focus; neuroprotective properties; potential mood benefits', 'lion-s-mane', '2025-05-11 02:14:01', '2025-05-11 02:14:01');
INSERT INTO public.ingredients VALUES (254, 'L-Ornithine Hydrochloride', NULL, NULL, 'l-ornithine-hydrochloride', '2025-05-11 02:14:02', '2025-05-11 02:14:02');
INSERT INTO public.ingredients VALUES (225, 'Nitrosigine', 'A patented complex of bonded arginine silicate that increases nitric oxide levels for improved blood flow. Designed to provide longer-lasting effects than traditional arginine or citrulline.', 'Enhances nitric oxide production; improves blood flow; provides sustained pump effect; supports cognitive performance', 'nitrosigine', '2025-05-11 02:13:59', '2025-05-11 02:13:59');
INSERT INTO public.ingredients VALUES (235, 'Hemerocallis Fulva', NULL, NULL, 'hemerocallis-fulva', '2025-05-11 02:14:00', '2025-05-11 02:14:00');
INSERT INTO public.ingredients VALUES (245, 'VasoDrive AP', 'A proprietary ingredient derived from casein hydrolysate containing two lactotripeptides that help relax blood vessels and improve blood flow to working muscles.', 'Promotes vasodilation; lowers blood pressure; enhances blood flow; improves nutrient delivery', 'vasodrive-ap', '2025-05-11 02:14:01', '2025-05-11 02:14:01');
INSERT INTO public.ingredients VALUES (255, 'PEAK ATP', NULL, NULL, 'peak-atp', '2025-05-11 02:14:02', '2025-05-11 02:14:02');
INSERT INTO public.ingredients VALUES (226, 'Glycerol Monostearate', 'A compound that increases water retention in the bloodstream and tissues, creating a hyperhydration effect that can benefit endurance and create visual fullness to muscles.', 'Enhances cellular hydration; increases endurance; creates "hyper-hydration" effect; improves muscle fullness', 'glycerol-monostearate', '2025-05-11 02:13:59', '2025-05-11 02:13:59');
INSERT INTO public.ingredients VALUES (236, 'Cocoabuterol', NULL, NULL, 'cocoabuterol', '2025-05-11 02:14:00', '2025-05-11 02:14:00');
INSERT INTO public.ingredients VALUES (246, 'Synaptrix', NULL, NULL, 'synaptrix', '2025-05-11 02:14:01', '2025-05-11 02:14:01');
INSERT INTO public.ingredients VALUES (256, 'Zynamite', NULL, NULL, 'zynamite', '2025-05-11 02:14:02', '2025-05-11 02:14:02');
INSERT INTO public.ingredients VALUES (227, 'Nitro Rocket', NULL, NULL, 'nitro-rocket', '2025-05-11 02:13:59', '2025-05-11 02:13:59');
INSERT INTO public.ingredients VALUES (237, 'Caloriburn GP', NULL, NULL, 'caloriburn-gp', '2025-05-11 02:14:00', '2025-05-11 02:14:00');
INSERT INTO public.ingredients VALUES (247, 'Caffeine Citrate', 'A form of caffeine combined with citric acid that is more water-soluble than regular caffeine, allowing for faster absorption and quicker onset of effects.', 'Faster-acting caffeine form; quicker onset of alertness and energy; may have improved bioavailability', 'caffeine-citrate', '2025-05-11 02:14:01', '2025-05-11 02:14:01');
INSERT INTO public.ingredients VALUES (257, 'Senactiv', 'A proprietary ingredient containing Panax notoginseng and Rosa roxburghii that has been shown to help clear senescent cells and regenerate damaged muscle cells, potentially improving recovery and performance.', 'Enhances muscle endurance; accelerates muscle cell regeneration; increases VO2 max; improves recovery', 'senactiv', '2025-05-11 02:14:02', '2025-05-11 02:14:02');
INSERT INTO public.ingredients VALUES (228, 'Rauwolfa Vomitoria', NULL, NULL, 'rauwolfa-vomitoria', '2025-05-11 02:13:59', '2025-05-11 02:13:59');
INSERT INTO public.ingredients VALUES (238, 'zumXR', NULL, NULL, 'zumxr', '2025-05-11 02:14:00', '2025-05-11 02:14:00');
INSERT INTO public.ingredients VALUES (248, 'Bitter Orange Extract', NULL, NULL, 'bitter-orange-extract', '2025-05-11 02:14:01', '2025-05-11 02:14:01');
INSERT INTO public.ingredients VALUES (258, 'FitNox', 'A patented blend of nitric oxide boosting ingredients designed to increase blood flow and enhance exercise performance through improved oxygen and nutrient delivery.', 'Boosts nitric oxide production; enhances blood flow; improves exercise performance; supports muscle pumps', 'fitnox', '2025-05-11 02:14:02', '2025-05-11 02:14:02');
INSERT INTO public.ingredients VALUES (229, 'Aquamin', NULL, NULL, 'aquamin', '2025-05-11 02:13:59', '2025-05-11 02:13:59');
INSERT INTO public.ingredients VALUES (239, 'S7', NULL, NULL, 's7', '2025-05-11 02:14:00', '2025-05-11 02:14:00');
INSERT INTO public.ingredients VALUES (249, 'Grapefruit Extract', NULL, NULL, 'grapefruit-extract', '2025-05-11 02:14:01', '2025-05-11 02:14:01');
INSERT INTO public.ingredients VALUES (259, 'NooLVL', 'A patented complex of inositol-stabilized arginine silicate with additional inositol, designed to improve cognitive performance, particularly beneficial for gamers and those needing quick reaction times.', 'Enhances cognitive function; improves reaction time; increases focus and mental energy; supports gaming performance', 'noolvl', '2025-05-11 02:14:02', '2025-05-11 02:14:02');
INSERT INTO public.ingredients VALUES (230, 'BioPerine', 'A patented extract from black pepper containing piperine, which enhances the bioavailability of many nutrients by inhibiting enzymes that would metabolize them and by enhancing absorption in the intestines.', 'Enhances nutrient absorption; increases bioavailability of other ingredients; may improve thermogenesis', 'bioperine', '2025-05-11 02:13:59', '2025-05-11 02:13:59');
INSERT INTO public.ingredients VALUES (240, 'SaniEnergy Nu', NULL, NULL, 'sanienergy-nu', '2025-05-11 02:14:00', '2025-05-11 02:14:00');
INSERT INTO public.ingredients VALUES (250, 'Synephrine', NULL, NULL, 'synephrine', '2025-05-11 02:14:01', '2025-05-11 02:14:01');
INSERT INTO public.ingredients VALUES (260, 'Rhodiola Rosea', 'An adaptogenic herb that helps the body adapt to stress and may reduce fatigue. Can enhance physical performance, particularly endurance, and support cognitive function during stressful exercise.', 'Reduces mental and physical fatigue; enhances stress resistance; improves exercise performance; adaptogenic properties', 'rhodiola-rosea', '2025-05-11 02:14:02', '2025-05-11 02:14:02');
INSERT INTO public.ingredients VALUES (231, 'Cognatiq', NULL, NULL, 'cognatiq', '2025-05-11 02:13:59', '2025-05-11 02:13:59');
INSERT INTO public.ingredients VALUES (241, 'MitoBurn', NULL, NULL, 'mitoburn', '2025-05-11 02:14:00', '2025-05-11 02:14:00');
INSERT INTO public.ingredients VALUES (251, 'Citicoline', 'A compound that provides choline and cytidine, supporting phosphatidylcholine synthesis in the brain. Offers more potent cognitive benefits than standard choline sources.', 'Enhances brain energy metabolism; improves focus and attention; supports acetylcholine production; neuroprotective effects', 'citicoline', '2025-05-11 02:14:01', '2025-05-11 02:14:01');
INSERT INTO public.ingredients VALUES (233, 'Sodium Dodecanedioate', NULL, NULL, 'sodium-dodecanedioate', '2025-05-11 02:13:59', '2025-05-11 02:13:59');
INSERT INTO public.ingredients VALUES (243, 'HydroPrime', 'A highly concentrated form of glycerol that improves hydration and endurance. Creates a visual "pump" effect and may improve performance in hot conditions or during longer exercise sessions.', 'Enhanced form of glycerol; improves cellular hydration; increases endurance; creates fuller muscle appearance', 'hydroprime', '2025-05-11 02:14:00', '2025-05-11 02:14:00');
INSERT INTO public.ingredients VALUES (253, 'NeuroRush', NULL, NULL, 'neurorush', '2025-05-11 02:14:01', '2025-05-11 02:14:01');
INSERT INTO public.ingredients VALUES (271, 'Glycersize', '65% Glycerol Powder', NULL, 'glycersize', '2025-05-11 20:55:16', '2025-05-11 20:55:16');
INSERT INTO public.ingredients VALUES (272, 'Pine Bark Extract', '95% Proanthocyanidins', NULL, 'pine-bark-extract', '2025-05-11 20:56:40', '2025-05-11 20:56:40');
INSERT INTO public.ingredients VALUES (273, 'Phyt02', NULL, NULL, 'phyt02', '2025-05-11 20:59:20', '2025-05-11 20:59:20');
INSERT INTO public.ingredients VALUES (274, 'Caffeine Natural', 'From Coffee', NULL, 'caffeine-natural', '2025-05-11 21:00:05', '2025-05-11 21:00:05');
INSERT INTO public.ingredients VALUES (275, 'Neurofactor', 'Coffee Fruit Extract', NULL, 'neurofactor', '2025-05-11 21:00:38', '2025-05-11 21:00:38');
INSERT INTO public.ingredients VALUES (276, 'Methylliberine', NULL, NULL, 'methylliberine', '2025-05-11 21:08:38', '2025-05-11 21:08:38');
INSERT INTO public.ingredients VALUES (277, 'Peak02', NULL, NULL, 'peak02', '2025-05-11 21:12:03', '2025-05-11 21:12:03');
INSERT INTO public.ingredients VALUES (280, 'Dan Shen', NULL, NULL, 'dan-shen', '2025-05-14 16:30:24', '2025-05-14 16:30:24');
INSERT INTO public.ingredients VALUES (292, 'Glycerpump', NULL, NULL, 'glycerpump', '2025-05-14 22:14:49', '2025-05-14 22:14:49');
INSERT INTO public.ingredients VALUES (293, 'Guarana Extract', NULL, NULL, 'guarana-extract', '2025-05-14 22:15:40', '2025-05-14 22:15:40');
INSERT INTO public.ingredients VALUES (294, 'Yerba Mate Extract', NULL, NULL, 'yerba-mate-extract', '2025-05-14 22:16:15', '2025-05-14 22:16:15');
INSERT INTO public.ingredients VALUES (295, 'Inositol Arginine Silicate', NULL, NULL, 'inositol-arginine-silicate', '2025-05-14 22:19:39', '2025-05-14 22:19:39');
INSERT INTO public.ingredients VALUES (296, 'Beet Root Extract', NULL, NULL, 'beet-root-extract', '2025-05-14 22:20:27', '2025-05-14 22:20:27');
INSERT INTO public.ingredients VALUES (301, 'Taurine', NULL, NULL, 'taurine', '2025-05-18 00:12:42', '2025-05-18 00:12:42');
INSERT INTO public.ingredients VALUES (302, 'zumDR', NULL, NULL, 'zumdr', '2025-05-18 00:14:11', '2025-05-18 00:14:11');
INSERT INTO public.ingredients VALUES (303, 'Dendrobium Stem Extract', NULL, NULL, 'dendrobium-stem-extract', '2025-05-18 01:49:36', '2025-05-18 01:49:36');
INSERT INTO public.ingredients VALUES (304, 'Citrus aurantium Extract', NULL, NULL, 'citrus-aurantium-extract', '2025-05-18 01:50:56', '2025-05-18 01:50:56');
INSERT INTO public.ingredients VALUES (305, 'Cluster Dextrin', NULL, NULL, 'cluster-dextrin', '2025-05-18 01:57:13', '2025-05-18 01:57:13');
INSERT INTO public.ingredients VALUES (306, 'Metabolyte', NULL, NULL, 'metabolyte', '2025-05-18 02:21:17', '2025-05-18 02:21:17');
INSERT INTO public.ingredients VALUES (307, 'Dandelion Extract', NULL, NULL, 'dandelion-extract', '2025-05-18 02:22:46', '2025-05-18 02:22:46');
INSERT INTO public.ingredients VALUES (308, 'Raspberry Ketone', NULL, NULL, 'raspberry-ketone', '2025-05-18 02:23:34', '2025-05-18 02:23:34');
INSERT INTO public.ingredients VALUES (309, 'Evodiamine', NULL, NULL, 'evodiamine', '2025-05-18 02:24:17', '2025-05-18 02:24:17');
INSERT INTO public.ingredients VALUES (310, 'Norvaline', NULL, NULL, 'norvaline', '2025-05-18 02:27:31', '2025-05-18 02:27:31');
INSERT INTO public.ingredients VALUES (311, 'Arginine Nitrate', NULL, NULL, 'arginine-nitrate', '2025-05-24 19:53:25', '2025-05-24 19:53:25');
INSERT INTO public.ingredients VALUES (312, 'Grape Seed Extract', NULL, NULL, 'grape-seed-extract', '2025-05-24 20:09:03', '2025-05-24 20:09:03');


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.products VALUES (35, 'AlphaSurge', 'AlphaSurge isn’t just another typical nitric oxide “pump” product. Specifically formulated by athletes for athletes looking to expand and explode their training levels, AlphaSurge was precisely engineered with a hand-selected blend of ingredients that work together to help volumize your muscle cells and improve nutrient delivery.* This helps boost your training and promotes skin-tearing pumps in the gym!*

The ingredients of AlphaSurge were distinctively combined to help release nutrients and rich blood flowing directly to your muscle cells during your workout to help with training duration. This is achieved by drawing blood into the muscle – shuttling glycogen and nutrients to the cell membrane – forcing the muscle cells to expand. This process acts as an anabolic signal that helps trigger increased protein synthesis, glycogen uptake, muscular growth, and repair speeds.*

The ingredients of AlphaSurge help with the evacuation of acid buildup in the muscles to keep the burn away and fight off muscle fatigue. You’ll immediately feel the increased muscle density and improvements in strength and athletic performance.', 'https://1stphorm.com/products/alphasurge', 'https://1stphorm.com/cdn/shop/files/alphasurge-berry-lemonade_720x.png?v=1695160362', 45.99, '9.5', 20, 190, true, 'alphasurge', NULL, 71, '2025-05-11 20:56:59', '2025-05-11 21:24:04');
INSERT INTO public.products VALUES (36, 'Megawatt Natural', 'The dreaded early morning or late afternoon drag you experience before hitting the gym is a thing of the past. We know you will never stop improving... and neither will we! Megawatt has been formulated with natural caffeine and electrolytes to help give you the boost you need to hit your workouts at full speed.

The complete mental focus and fortitude you’ll experience will have you pushing past barriers and performing at your peak.

Our goal is to provide you with an amazing tasting pre-workout that is versatile, so you can use it for any type of athletic activity. Megawatt contains a specific blend of ingredients to give you incredible energy and mental focus like you’ve never experienced before.

The research-supported ingredients found in Megawatt also include B vitamins and nootropic ingredients that will help increase mental focus, alertness, and have you dialed in, so you’re going harder in each training session.

Electrolytes are intertwined with all fluids in the body, and a lack of electrolytes can lead to less-than-peak performance. The blend of Aquamin electrolytes in Megawatt is designed to keep you performing at an optimal level throughout your training session by delaying exercise-induced muscle fatigue, and improving mental capacity to help you push through the most grueling parts of your workout.', 'https://1stphorm.com/products/megawatt-natural', 'https://1stphorm.com/cdn/shop/files/megawatt-natural-strawberry-lemonade_1800x1800.png?v=1694545056', 46.99, '6', 40, 240, true, 'megawatt-natural', NULL, 71, '2025-05-11 21:01:12', '2025-05-11 21:01:12');
INSERT INTO public.products VALUES (37, 'Megawatt', 'The dreaded early morning or late afternoon drag before hitting the gym is a thing of the past. We know you will never stop improving ... and neither will we! Megawatt has been formulated with natural caffeine and electrolytes to help give you the boost you need to hit your workouts at full speed.

The complete mental focus and fortitude you’ll experience will have you pushing past barriers and performing at your peak.

Our goal is to provide you with an amazing-tasting pre-workout that is versatile, so you can use it for any type of athletic activity. Megawatt contains a blend of ingredients to give you energy and mental focus like you’ve never experienced before.

The research-supported ingredients found in Megawatt also include B vitamins and nootropics. This can further help increase mental focus, alertness, and have you dialed in, so you’re going harder in each training session.

Electrolytes are intertwined with all fluids in the body. A lack of electrolytes can lead to lower levels of performance. The blend of Aquamin electrolytes in Megawatt is designed to keep you performing at an optimal level throughout your training session by delaying exercise-induced muscle fatigue and improving mental capacity. You''ll be able to push through even the most grueling of workouts!', 'https://1stphorm.com/products/megawatt', 'https://1stphorm.com/cdn/shop/files/megawatt-pineapple-pomegranate_1800x1800.png?v=1730827019', 46.99, '5.5', 40, 220, true, 'megawatt', NULL, 71, '2025-05-11 21:03:59', '2025-05-11 21:03:59');
INSERT INTO public.products VALUES (56, 'Nuclear Armageddon', 'Nuclear Armageddon gives you the feeling of explosive energy and performance. It''s loaded with 395 mg of caffeine and 10 grams of Pump Activators.', 'https://anabolicwarfare.defynedbrands.com/products/nuclear-armageddon-1', 'https://cdn.shopify.com/s/files/1/0068/1925/0235/files/AWNARBBL_150.029.02_v1.3_Render.png?v=1743516802&width=1800&crop=center', 44.99, '12.8', 30, 384, true, 'nuclear-armageddon', NULL, 11, '2025-05-18 01:57:25', '2025-05-18 01:57:25');
INSERT INTO public.products VALUES (58, 'Defcon3', 'War is hell, but your workout doesn''t have to be with DEFCON3! This all-in-one, mid-stim pre-workout supports optimal strength, energy, and performance, without the jitters.', 'https://anabolicwarfare.defynedbrands.com/products/defcon3', 'https://cdn.shopify.com/s/files/1/0068/1925/0235/files/AWDEFCON3BBL_200.006.01_v2.3_Render.png?v=1743516711&width=1800&crop=center', 59.99, '30.9', 20, 618, true, 'defcon3', NULL, 11, '2025-05-18 02:12:19', '2025-05-18 02:12:19');
INSERT INTO public.products VALUES (60, 'Maniac', 'Train at peak performance with Maniac pre-workout powder. This highly potent comprehensive pre-workout blend is perfect for men and women who want crazy energy and razor-sharp focus!', 'https://anabolicwarfare.defynedbrands.com/products/anabolic-warfare-black-series-maniac', 'https://cdn.shopify.com/s/files/1/0068/1925/0235/files/AWBLKMANIACAA_150.026.02_v1.6_Render.png?v=1743516727&width=1800&crop=center', 49.99, '14.5', 25, 362, true, 'maniac', NULL, 11, '2025-05-18 02:19:49', '2025-05-18 02:19:49');
INSERT INTO public.products VALUES (62, 'Veiniac', 'Mega-Dosed Muscle Pump Accelerator', 'https://anabolicwarfare.defynedbrands.com/products/black-series-veiniac', 'https://cdn.shopify.com/s/files/1/0068/1925/0235/files/AWBLKVEINIACFS_100.026.01_v2.3_Render.png?v=1743516725&width=1800&crop=center', 49.99, '17.4', 20, 348, true, 'veiniac', NULL, 11, '2025-05-18 02:27:38', '2025-05-18 02:27:38');
INSERT INTO public.products VALUES (63, 'Pump N Grow', 'Stimulant-free pump and endurance activator.', 'https://anabolicwarfare.defynedbrands.com/products/pump-n-grow', 'https://cdn.shopify.com/s/files/1/0068/1925/0235/files/AWPUMPNA_150.088.02_v1.2_Render_d3d95adf-a2d3-4234-9eaf-425acbe3e21e.png?v=1743516817&width=1800&crop=center', 46.99, '11.5', 30, 345, true, 'pump-n-grow', NULL, 11, '2025-05-18 02:29:11', '2025-05-18 02:29:11');
INSERT INTO public.products VALUES (40, 'Endura-Formance', 'With each intense rep of your training, you are working towards your goal of becoming a stronger high-performance athlete! But when it comes to muscle growth and sports performance, how you fuel your training makes an enormous impact on your overall results. The ability to energize your muscle fibers with more power and stamina will allow you to train harder and longer. Endura-Formance accomplishes this by combining two powerful clinically proven muscle performance ingredients, creatine and beta-alanine, along with a comprehensive combination of well-studied nutrient and oxygen delivery enhancement compounds, so you can take your strength, power and sports endurance to its peak!

Creatine is an energy source found naturally in the human body to fight off muscle fatigue and increase the maximal force production of your muscles during intense training by allowing for optimal ATP energy regeneration. Effective supplementation with creatine and beta-alanine, an amino acid derivative aimed specifically at increasing your body’s carnosine levels, has been shown to reduce lactic acid to resist muscle fatigue and improve muscle endurance.

To further increase muscle performance and stamina, Endura- Formance includes a powerful blend of betaine anhydrous, Peak02™️, and S7® ingredients. This combination increases muscle hydration and allows your body to maximize oxygen and nutrient delivery to the muscle. This creates a synergistic effect to further protect against muscle fatigue, enhance muscle power output, and endurance so you can train harder and longer.

The well-rounded and robust formulation of Endura-Formance will increase aerobic capacity and endurance, as well as your anaerobic power output and overall strength levels making it an ideal supplement for all types of athletes.', 'https://1stphorm.com/products/endura-formance', 'https://1stphorm.com/cdn/shop/files/endura-formance-strawberry-pineapple_1800x1800.png?v=1705439207', 46.99, '16.2', 30, 480, true, 'endura-formance', NULL, 71, '2025-05-11 21:22:23', '2025-05-11 21:22:23');
INSERT INTO public.products VALUES (41, '5150', '5150 High Stimulant Pre-Workout delivers a supercharged punch with over 400mg of Caffeine per serving, plus the revolutionary energy and nootropic Cocoabuterol for more than 500mg of total stimulant per serving! With just a single scoop of 5150® you''ll surge with over 400mg of caffeine through your veins. Our precise ''STIM-JUNKIE'' complex combines 8 types of caffeine for a smooth, extended energy curve while nearly eliminating the caffeine jitters or crash that accompany most pre-workouts.', 'https://5percentnutrition.com/products/5150-high-stimulant-pre-workout', 'https://5percentnutrition.com/cdn/shop/files/5150_GreenApple_WEB.png?v=1746626137&width=1400', 48.99, '14.9', 30, 402, true, '5150', NULL, 23, '2025-05-14 16:23:19', '2025-05-14 16:25:54');
INSERT INTO public.products VALUES (42, 'Full as F*ck', 'Your working muscles feel like they’re about to explode, not to mention looking absolutely huge. There’s no doubt that a great pump can transform your physique right before your eyes. A pump like this forces your muscles to look FULL AS F*CK.

Yet there’s more than just a visual benefit to getting a great pump. That’s because the increased blood flow carries critical oxygen and nutrients to your working muscles. This improves endurance so you can get your best workout every time.

Of course, most bodybuilders want the most extreme pump they can get. They’ll search the market for the best pump-enhancing supplement they can find. If you''re looking for the ultimate pump, FULL AS F*CK is your desired pump pre-workout.', 'https://5percentnutrition.com/products/faf-nitric-oxide-booster', 'https://5percentnutrition.com/cdn/shop/products/full-as-f-ck-nitric-oxide-booster-legendary-series-5percent-nutrition-1.png?v=1746114679&width=1400', 48.99, '14', 30, 350, true, 'full-as-f-ck', NULL, 23, '2025-05-14 16:31:00', '2025-05-14 16:31:20');
INSERT INTO public.products VALUES (43, 'Kill-It', 'It''s been a popular and established part of our pre-workout lineup for quite some time - until we decided to shake things up. Now, it’s more hardcore than ever!

One of the great things about Kill It Pre-Workout is its flexibility. It’s always been and continues to be the perfect first pre-workout at one scoop. At this serving size, it''s also the answer for lifters who prefer less caffeine. When you bump that up to two scoops per serving, we''re looking at a more hardcore pre-workout!

Look at the formula. Kill It Pre-Workout still stands apart as one of the few pre-workouts containing creatine monohydrate. Now, there’s 325 mg of caffeine (with the 2-scoop serving). This outstanding pre-workout features an advanced combination of energy, pump, focus, endurance, and performance ingredients. Of course, they are precisely formulated to create a complete, balanced pre-workout. Many pre-workouts target either the pump or energy. Kill It Pre-Workout gives lifters a fully disclosed formula with flexible serving sizes. Finally, it tastes incredible, with two new flavors added to the lineup!', 'https://5percentnutrition.com/products/kill-it-pre-workout', 'https://5percentnutrition.com/cdn/shop/files/KillIt_BlueberryLemonade_WEB.png?v=1740000174&width=1400', 39.99, '20.4', 20, 404, true, 'kill-it', NULL, 23, '2025-05-14 17:01:33', '2025-05-14 17:01:33');
INSERT INTO public.products VALUES (57, 'Defcon1', 'DEFCON1, for when the shit''s about to hit the fan kind of workout! This explosive high-stim pre-workout targets epic strength & power, intense energy, & peak performance.', 'https://anabolicwarfare.defynedbrands.com/products/defcon1', 'https://cdn.shopify.com/s/files/1/0068/1925/0235/files/AWDEFCON1BBL_200.003.01_v2.3_Render.png?v=1743516713&width=1800&crop=center', 59.99, '31', 20, 620, true, 'defcon1', NULL, 11, '2025-05-18 02:09:53', '2025-05-18 02:09:53');
INSERT INTO public.products VALUES (61, 'BlackMarket x Anabolic Warfare SCORCH', 'Introducing SCORCH - an explosive collaboration between Anabolic Warfare & BlackMarketLabs

Scorch is the pinnacle of ultra-thermogenic pre-workouts. Loaded with a potent, fat-shredding formula that ramps up your metabolism to torch fat, crafted to ignite your performance, & amplify your endurance through your most intense workouts.', 'https://anabolicwarfare.defynedbrands.com/products/blackmarket-x-anabolic-warfare-scorch', 'https://cdn.shopify.com/s/files/1/0068/1925/0235/files/Scorch-CherryBomb-FRONT.png?v=1747159135&width=1800&crop=center', 54.99, '19.1', 20, 384, true, 'blackmarket-x-anabolic-warfare-scorch', NULL, 11, '2025-05-18 02:25:17', '2025-05-18 02:25:17');
INSERT INTO public.products VALUES (69, 'ABE', 'ABE™ Ultimate Pre-Workout delivers a unique blend of the most vital and researched active ingredients known to help increase physical performance†, reduce tiredness & fatigue†, and provide continual focus throughout your training, maximizing your body''s potential. However, talk is cheap and the proof is in the product. After extensive research, meticulous formulating, and precise lab testing, we are confident to let ABE™ do the talking. 

We believe true excellence comes from within. That’s why every ingredient in the ABE™ pre workout formula is subject to extensive research and lab testing. We go to great lengths to ensure you are only putting the best in your body. Using reputable 3rd party Informed Choice Supplement testing, we make sure our pre-workout is accredited, free of banned substances, and perfected for use by professional athletes.', NULL, NULL, 44.99, '13', 30, 390, true, 'abe', NULL, 7, '2025-05-24 19:47:45', '2025-05-24 19:47:45');
INSERT INTO public.products VALUES (70, 'Hooligan Extreme', NULL, 'https://www.apollonnutrition.com/products/hooligan-newest-version', 'https://www.apollonnutrition.com/cdn/shop/files/hooligan-extreme-pre-workout-apollon-nutrition-609062.jpg?v=1732324961&width=1946', 59.95, '20.65', 40, 800, true, 'hooligan-extreme', NULL, 48, '2025-05-24 19:54:55', '2025-05-24 19:54:55');
INSERT INTO public.products VALUES (71, 'Desperado', 'It stands to reason that you’d have a pre workout that you can rely on for a great workout, every workout. Now, don’t confuse cost-effective go-to pre workouts with the cracked-out stim bombs you chug after a night of 4 hours of sleep and a raging hangover (these pre workouts also have their place, but hopefully they’re used sparingly).

No, a cost effective go-to pre workout is the one that day in, day out, you mix up, drink, and BAM! You’re ready to seize the day.

Desperado is the cost-effective pre workout Apollon style.

True to Apollon form, we’ve packed out the performance and focus but keep the energy “moderate” (at least by our standards, which is to say it’s “high” for 90% of other brands).

With Desperado, you get it ALL -- energy, performance, pumps, and focus -- while being a cost-effective solution to fuel your daily training!', 'https://www.apollonnutrition.com/products/desperado-pre-workout', 'https://www.apollonnutrition.com/cdn/shop/files/desperado-pre-workout-apollon-nutrition-704587.jpg?v=1732324961&width=1946', 44.95, '11.4', 40, 454, true, 'desperado', NULL, 48, '2025-05-24 20:03:15', '2025-05-24 20:03:15');
INSERT INTO public.products VALUES (44, 'Reloaded', 'Introducing Reloaded, the next evolution in 5% Nutrition pre-workouts. A popular member of our lineup, Reloaded has now been enhanced to be more hardcore than ever, setting it apart from the rest.

Reloaded offers a unique flexibility with its 1 or 2 scoop servings. At one scoop, it''s a great choice for those who prefer a little less Caffeine. But at two scoops, it transforms into one of the most hardcore pre-workouts available, catering to a wide range of fitness needs.

Check out the formula - Reloaded is a pre-workout that stands above the crowd with an exceptional list of ingredients. 5% Nutrition has always been one of the few companies that feature Creatine Monohydrate in our pre-workouts. Now, we''ve gone a step further and created an exclusive Creatine Blend that features Creatine Monohydrate and 2 other forms of Creatine. What about Caffeine? We thought you''d never ask! Now, there are 3 sources supplying 360 mg of Caffeine (at two scoops). And there''s also a whopping 8 grams (at 2 scoops) of pure L-Citrulline - the most we''ve ever put in a pre-workout. Reloaded is an outstanding pre-workout featuring an advanced combination of energy, pump, focus, endurance, and performance ingredients. Of course, every ingredient with its dosage is clearly listed on the label - there are no prop blends here! The ingredient profile is designed to create a complete, balanced pre-workout. Reloaded has it all, and of course, it tastes incredible, making it a treat for your taste buds!', 'https://5percentnutrition.com/products/reloaded-pre-workout', 'https://5percentnutrition.com/cdn/shop/files/Reloaded_Frostbite_WEB.png?v=1746115431&width=1400', 52.99, '27.4', 20, 548, true, 'reloaded', NULL, 23, '2025-05-14 17:06:21', '2025-05-14 17:06:21');
INSERT INTO public.products VALUES (45, 'Creatine Pre-Workout', 'Get the edge in every workout with our Advanced Pre-Workout Formula, a powerhouse blend designed to boost energy, focus, and performance. Packed with creatine monohydrate, natural caffeine, and a unique blend of adaptogens, this formula is perfect for anyone looking to take their workouts to the next level. Whether you''re hitting the gym or gearing up for a big game, this formula provides the support you need to push through your toughest sessions.', 'https://ainutrition.com/products/creatine', 'https://ainutrition.com/cdn/shop/files/AIN_Energy_Watermelon_Angled_Shadow_1920x.png?v=1710973916', 39.00, '5', 40, 200, true, 'creatine-pre-workout', NULL, 8, '2025-05-14 22:11:33', '2025-05-14 22:11:33');
INSERT INTO public.products VALUES (46, 'Bangalore', 'When you step into the gym, you don’t need a sugar rush or a temporary high — you need real performance.

Bangalore Pre-Workout is built for athletes who demand more from themselves and their supplements.

This isn''t just about getting hyped — it’s about dialing into the zone where strength, endurance, and focus collide.

With a clean, powerful blend of energy drivers, blood flow enhancers, focus agents, and hydration support, Bangalore unlocks your body''s true capacity without the crash, jitters, or burnout of cheap pre-workouts.

Whether you''re crushing a heavy lift, grinding through a brutal endurance session, or chasing the best version of yourself — Bangalore keeps you locked in from the first rep to the final sprint.

If you''re ready for serious training, you’re ready for Bangalore.', 'https://thealphacountry.com/collections/pre-workout/products/bangalore-pre-workout', 'https://thealphacountry.com/cdn/shop/files/55BlackBangaloreMangofront.png?v=1721305938', 44.99, '22.23', 30, 644, true, 'bangalore', NULL, 63, '2025-05-14 22:17:21', '2025-05-14 22:17:21');
INSERT INTO public.products VALUES (47, 'Pump Non-Stim', 'You don’t need stimulants to have a powerful session — you need real blood flow, deep muscle hydration, and clean recovery support.

Pump – Non-Stim Pre-Workout is built for lifters and athletes who want all the performance benefits without relying on caffeine or crash-heavy energy.

With a powerhouse blend of ingredients that drive nitric oxide production, optimize hydration, and support recovery, Pump helps you train harder, look fuller, and recover faster — all without the stimulant overload.

Feel the pump, see the difference, and dominate your training — day or night.', 'https://thealphacountry.com/collections/pre-workout/products/pump-non-stim', 'https://thealphacountry.com/cdn/shop/files/IMG_7825.png?v=1724988826&width=1080', 44.99, '15.5', 30, 465, true, 'pump-non-stim', NULL, 63, '2025-05-14 22:20:57', '2025-05-14 22:20:57');
INSERT INTO public.products VALUES (55, 'Stim Lord', 'Unleash your inner Escobar and dominate your workout with Stim Lord. Our potent pre-workout blend is stacked with muscle pump activators and loaded up with caffeine to dominate your workouts.', 'https://anabolicwarfare.defynedbrands.com/products/stim-lord', 'https://cdn.shopify.com/s/files/1/0068/1925/0235/files/AWSTIMLORDBRC_190.009.01_v1.3_Render.png?v=1743516697&width=1800&crop=center', 56.99, '21.8', 20, 436, true, 'stim-lord', NULL, 11, '2025-05-18 01:51:03', '2025-05-18 01:51:03');
INSERT INTO public.products VALUES (50, 'Superhuman Burn', 'A 2-in-1 fat burning pre-workout (21 servings) designed to amplify your caloric expenditure while increasing training intensity.† Featuring research backed ingredients and powered by our novel SXT™ Energy System, Superhuman Burn will help you burn more calories while elevating strength and focus.† Truly the best of both worlds.', 'https://www.alphalion.com/products/superhuman-burn-pre-workout-fat-burner', 'https://www.alphalion.com/cdn/shop/products/SH-BURN-HULK-JUICE_1_1.png?v=1706628381', 59.99, '14.9', 21, 310, true, 'superhuman-burn', NULL, 4, '2025-05-18 00:15:36', '2025-05-18 00:15:36');
INSERT INTO public.products VALUES (51, 'Superhuman Pre', 'The original, high-performance pre-workout (21 Servings) that is the gold standard of training intensity. Its jam-packed but well-rounded formula is the perfect solution for anyone struggling with gym motivation or stagnant workouts.', 'https://www.alphalion.com/products/superhuman-pre-workout', 'https://www.alphalion.com/cdn/shop/products/SH-PRE-HULK-JUICE_1_1.png?v=1744740350', 49.99, '16.4', 21, 342, true, 'superhuman-pre', NULL, 4, '2025-05-18 00:18:48', '2025-05-18 00:18:48');
INSERT INTO public.products VALUES (52, 'Superhuman Extreme', 'Ready to take your workout intensity to the extreme? Behold our fully loaded pre-workout formula that takes feeling Superhuman to the next level (21 servings). 

With 350 mg of SXT™ energy + more hard-hitting ingredients than our original Superhuman Pre, Superhuman Extreme is perfect for anyone who craves extreme athletic performance.', 'https://www.alphalion.com/products/superhuman-extreme', 'https://www.alphalion.com/cdn/shop/files/SHEXTREMEHULKJUICEFRONT1500X1500.png?v=1744740374', 49.99, '16.1', 21, 325, true, 'superhuman-extreme', NULL, 4, '2025-05-18 00:21:56', '2025-05-18 00:21:56');
INSERT INTO public.products VALUES (53, 'Superhuman Pump', 'Crave Superhuman performance without caffeine? Try this stimulant-free pump and performance pre-workout (42 servings) designed to maximize vascularity, strength and power output.†

Perfect for anyone sensitive to stimulants, night owl athletes, or anyone cycling off caffeine.', 'https://www.alphalion.com/products/superhuman-pump', 'https://www.alphalion.com/cdn/shop/products/SuperhumanPumpHulkJuice_48f0db29-c501-465b-9c64-18bb709fd0fe.png?v=1744740366', 49.99, '18', 21, 372, true, 'superhuman-pump', NULL, 4, '2025-05-18 00:24:13', '2025-05-18 00:24:13');
INSERT INTO public.products VALUES (54, 'Superhuman Core', 'Craving Superhuman performance without all the bells and whistles? Superhuman Core (30 servings) is your essential budget-friendly pre-workout that’s perfect for beginners or advanced athletes.

Powered by the 6 most synergistic ingredients -- including creatine -- for peak Superhuman training. Long-lasting energy, focus, and intensity without the price tag.', 'https://www.alphalion.com/products/superhuman-core', 'https://www.alphalion.com/cdn/shop/files/SH_CPW_RAZZLEMANIA_3.png?v=1746469665', 29.99, '10', 30, 301, true, 'superhuman-core', NULL, 4, '2025-05-18 00:26:36', '2025-05-18 00:26:36');
INSERT INTO public.products VALUES (64, 'Animal Primal', 'Ready to work harder than ever? Ready for a pre-workout that doesn’t pull any punches? Then you’re ready for Primal. An innovative, science-backed pre-workout loaded with over 20 proven and patented ingredients that give your body and mind everything they need to blow the limits off your limits.

GET MAX ENERGY thanks to caffeine anhydrous (300mg), green tea leaf extract, and guarana seed that combine to deliver a more relentless energy jolt without the uncomfortable jitters or crashes.

GET MAX FOCUS with a powerful combination of TeaCrine® (50mg) and L-tyrosine (1000mg) that locks you into peak mental performance so you can fixate on every rep and dig deeper to destroy more sets.

GET MAX ENDURANCE from beta-alanine (3200mg) and taurine (1000mg) that get you more amped–and keep you more amped–by reducing lactic acid buildup and increasing muscle stamina.

GET MAX HYDRATION with a unique electrolyte complex, as well as 25mg of Astragin® and 25mg of Senactiv® to help you wage war on sweat by absorbing more nutrients and recovering faster.

GET MAX PUMP with 6000mg of 3DPUMP-Breakthrough® that contains L-Citrulline, high-yield glycerol, and Amla fruit extract for those legendary skin-splitting results.

GET MAX FLAVOR with easy mixing and no chalky aftertaste. Available in three uniquely craveable new varieties: Dragon Berry, Wick’d Peach, and Candy Crush’d.

Primal Pre-Workout is GMP-certified and third-party lab testing for quality, safety, and potency.

Explosive Energy, Mental Focus, Muscle Pump, and Stamina
Patented Ingredients for Intense Workouts–Train Longer and Harder
Great Taste, Easy to Mix, and Two Delicious Fruit Flavors', 'https://www.animalpak.com/products/primal-preworkout-powder-supplement', 'https://www.animalpak.com/cdn/shop/files/Primal_BloodOrange_stamp_1080x1080_ff43283f-fab2-4cca-94dd-c3e2ca7ede6f.jpg?v=1747808386&width=800', 45.95, '40.2', 25, 502, true, 'animal-primal', NULL, 1, '2025-05-24 18:51:36', '2025-05-24 18:51:36');
INSERT INTO public.products VALUES (65, 'Animal Pump Non-Stim', 'Maximize your muscle pump and vascularity with our pre-workout formula that is the ultimate choice for gym-goers seeking quick and sustained pumps, performance & endurance, and focus without stimulants.

Featuring clinical doses of L-Citrulline and Nitrosigine®, the Pump & Performance Complex boosts blood flow, muscle fullness, vascularity and nutrient delivery
Beta Alanine, Betaine Anhydrous and L-Taurine enhance strength, endurance, and workout performance.
The combined mix of Nitrosigine and Tyrosine helps provide laser focus during the workout without the need for stims like caffeine.
The Electrolytes & Hydration Complex provides key electrolytes to support hydration during intense workouts.
The “pump” is perhaps the most important physiological process when it comes to muscle-building. It is also how oxygen and nutrient-rich blood engorges working muscle, feeding it so that it can grow. Not only does it make you look bigger, blowing up the target muscle group like a balloon, it actually makes you bigger by triggering the process of anabolism. This process of muscle volumization is critical to muscle growth.
With Animal Pump Non-Stim, we designed a formula specifically to “up the volume” while improving performance through five key complexes:

Stimulant-Free Formula: Perfect for evening workouts or for those who prefer caffeine-free performance.
Muscle Fullness + Quick-Acting & Long-Lasting Pumps: Includes 6g of L-Citrulline and 1.5g of Nitrosigine® for increased nitric oxide production, enhanced vascularity, and nutrient delivery. Nitrosigine® is clinically proven to deliver intense pumps and performance in just 15 minutes with effects lasting up to 6 hours.
Performance and Endurance: with 3.2g Beta Alanine, 2.5g Betaine to enhance strength, endurance and overall workout performance.
Improved Mental Clarity & Focus: with 2g of Tyrosine and 1.5g Nitrosigine to support mental clarity, focus, and workout intensity without stimulants.
Optimized Hydration Support: Infused with essential electrolytes to maintain hydration, electrolyte balance and muscle fullness during intense workouts.
Bigger pumps lead to muscle growth, it’s as simple as that.', 'https://www.animalpak.com/products/animal-pump-non-stim', 'https://www.animalpak.com/cdn/shop/files/PumpNS_DragonBerry_PDP_1080x1080_7aa030ae-d61e-46c1-aafb-caa90267b36c.jpg?v=1744038416&width=800', 49.95, '11', 40, 440, true, 'animal-pump-non-stim', NULL, 1, '2025-05-24 18:55:43', '2025-05-24 18:55:43');
INSERT INTO public.products VALUES (66, 'Animal Fury', 'A no-nonsense yet powerful pre-workout supplement, Animal Fury is formulated with 350mg of Caffeine Anhydrous plus Citrulline Malate for increased nitrous oxide, Beta Alanine, L-Tyrosine, and BCAAs in each scoop. Train harder than you thought possible with high powered and great tasting Animal Fury, designed for both men and women.

350mg caffeine and 5g BCAA per serving
Enhances energy, performance, focus, and recovery
Feel the kick without bloating or upset stomach
Animal Fury pre-workout powder helps you stay focused and energized no matter what type of training you do, with vein popping pumps, nitric oxide, high energy and focus every single workout. Combining proven pre-training staples like Citrulline Malate, Beta Alanine, L-Tyrosine and Caffeine Anhydrous, formulated in the right doses, plus five grams of Branched-Chain Amino Acids (BCAA) in every scoop, Animal Fury packs a muscle-building punch. Additionally, this creatine free formula is perfect for any athlete in a bulk or cut season.

Coming in crisp and refreshing Green Apple, Blue Raspberry, Ice Pop, and Watermelon flavors, Animal Fury also features a tantalizing taste. This great-tasting pre-workout powder mixes easily in 12oz. of water or your drink of choice, and packs a powerful and delicious taste for all athletes. Flavorful and bright, drinking Animal Fury is an enjoyable ritual you will look forward to with each delicious sip giving you more energy and sharper focus.', 'https://www.animalpak.com/products/animal-fury-pre-workout-powder-supplement', 'https://www.animalpak.com/cdn/shop/files/Fury_KiwiLime_2000x2000_13728efa-575b-4390-af8d-c53a6e08261d.jpg?v=1746597407&width=800', 35.95, '17', 30, 510, true, 'animal-fury', NULL, 1, '2025-05-24 18:57:52', '2025-05-24 18:57:52');
INSERT INTO public.products VALUES (67, 'AN Performance Pre', 'Life is a series of moments, and athletic life is no different. You train day in and day out, preparing for that critical situation when it''s your time to shine. Whether it''s chasing a personal record in the squat rack, delivering a clutch performance in the bottom of the 9th, or pushing through exhaustion in overtime, you need to be at your best when it counts. That''s why we developed the AN Performance Pre-Workout – to fuel your moment. Put simply, we''ve built a pre-workout formula that not only performs better, it feels better. The AN Performance Pre-Workout combines scientifically-backed ergogenic ingredients, cutting-edge focus enhancers, and unique mood-boosters to ensure you perform at your peak for every moment. With 6g of L-Citrulline, 3.2g of Beta-Alanine, and 2.5 grams of Betaine, we provide the essential support for endurance and power, taking you from sideline to sideline until the whistle blows. Additionally, we''ve included 300mg of naturally-sourced PurCaf caffeine to deliver a clean, sustained energy boost, keeping you energized and alert throughout your workout. But that''s just the beginning. These are the bare minimums for a top-tier pre-workout in today''s competitive landscape. The real experience begins in our mental focus blend, where we''ve curated a clinically-researched 500mg of Cognizin Citicoline alongside 2g of Tyrosine to sharpen your mental focus. Additionally, 2g of Taurine, and 100mg of NeuroRush Coffee Fruit Extract provide unique, feel-good benefits that enhance your overall workout experience and keep you in the zone -- without overstimulating you. Balanced with 150mg of salt and 300mg of potassium citrate, this pre-workout also supports hydration and electrolyte levels to keep you going from start to finish. Engineered for serious athletes who demand the best and are here to win, AN Performance Pre-Workout is your key to unlocking peak performance. Fuel your moment and own it with a formula dedicated to excellence, just like you.', 'https://ansupps.com/collections/pre-workout/products/an-performance-pre-workout', 'https://ansupps.com/cdn/shop/files/AN-Performance-PRE-390g-BR-Front.png?v=1732587969&width=1200', 49.99, '13', 30, 390, true, 'an-performance-pre', NULL, 7, '2025-05-24 19:42:10', '2025-05-24 19:42:10');
INSERT INTO public.products VALUES (68, 'AN Performance Zero-Caffeine Pre', 'Who says "stimulant-free" should mean "zero-energy"?! At AN Performance, we''re redefining the game with our Non-Stim Pre-Workout formula, here to impact your every moment, regardless of the time. It''s based upon our caffeinated pre-workout, but with an added twist. The AN Non-Stim Pre-Workout starts with the classic blend of 6g of L-Citrulline, 3.2g of Beta-Alanine, 2.5 grams of Betaine, 2 grams of taurine, and electrolytes from sodium and potassium. This powerful combination supports blood flow, power output, and fluid balance, ensuring you''re primed for peak performance. But where we shift gears is by including Peak ATP - literal cellular energy in the form of disodium ATP -when dropping the 300mg caffeine from PurCaf. Peak ATP goes beyond simple energy, supporting improved blood flow, peak power, total strength, and lean body mass. Paired with the highly-experiential trifecta of L-Tyrosine (2g), Cognizin Citicoline (500mg), NeuroRush coffee fruit extract (100mg), you''ll be fully present in the moment… so that you can seize the moment. With a formula like this, you no longer need tons of caffeine to feel energy. Athletic supplement users want experiential products they can feel, a challenge in the lower-stimulant space. But it''s a challenge we''ve overcome, because the AN Performance Zero-Caffeine Pre-Workout can be felt -and it''s here to fuel your moment, day or night.', 'https://ansupps.com/collections/pre-workout/products/anp-zero-caffeine-pre-workout', 'https://ansupps.com/cdn/shop/files/AN-Performance-ZC-PRE-390g-BR-Front.png?v=1732588877&width=1200', 49.99, '13', 30, 390, true, 'an-performance-zero-caffeine-pre', NULL, 7, '2025-05-24 19:44:48', '2025-05-24 19:44:48');
INSERT INTO public.products VALUES (72, 'Bare Knuckle', NULL, 'https://www.apollonnutrition.com/products/hooligan-bare-knuckle-premium-non-stimulant-pre-workout-powerhouse', 'https://www.apollonnutrition.com/cdn/shop/files/bare-knuckle-premium-non-stimulant-nitrate-infused-pre-workout-powerhouse-apollon-nutrition-510712.jpg?v=1732324950&width=1946', 59.95, '14', 40, 540, true, 'bare-knuckle', NULL, 48, '2025-05-24 20:09:32', '2025-05-24 20:09:32');
INSERT INTO public.products VALUES (73, 'Bloodsport', NULL, 'https://www.apollonnutrition.com/products/bareknuckle-bloodsport-extreme-blood-pumping-powder-with-nitrates', 'https://www.apollonnutrition.com/cdn/shop/files/bloodsport-extreme-blood-pumping-powder-with-nitrates-apollon-nutrition-114003.jpg?v=1732324947&width=1946', 59.95, '8.5', 40, 300, true, 'bloodsport', NULL, 48, '2025-05-24 20:11:32', '2025-05-24 20:11:32');
INSERT INTO public.products VALUES (74, 'PRE99', NULL, 'https://www.apollonnutrition.com/products/pre99-strawberry-banana-99-servings', 'https://www.apollonnutrition.com/cdn/shop/files/pre99-strawberry-banana-99-servings-apollon-nutrition-577068.png?v=1743603605&width=1946', 139.00, '29.5', 99, 2920, true, 'pre99', NULL, 48, '2025-05-24 20:14:33', '2025-05-24 20:14:33');
INSERT INTO public.products VALUES (75, 'Apollon Gym Classic', 'Apollon Gym Classic offers an affordable solution that doesn’t compromise on quality or effectiveness. 

We’ve included only the most well-studied and evidence-based pre workout supplements and packaged them together in one affordable, delicious, and effective budget pre workout.', 'https://www.apollonnutrition.com/products/apollon-gym-classic', 'https://www.apollonnutrition.com/cdn/shop/files/apollon-gym-classic-apollon-nutrition-227096.png?v=1736965337&width=1946', 29.95, '15.4', 30, 462, true, 'apollon-gym-classic', NULL, 48, '2025-05-24 20:16:42', '2025-05-24 20:16:42');


--
-- Data for Name: product_ingredients; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_ingredients VALUES (140, 'mg', 44, 209, '2025-05-14 17:06:21', '2025-05-14 17:06:21', 200.00);
INSERT INTO public.product_ingredients VALUES (141, 'g', 44, 199, '2025-05-14 17:06:21', '2025-05-14 17:06:21', 2.00);
INSERT INTO public.product_ingredients VALUES (142, 'mg', 44, 205, '2025-05-14 17:06:21', '2025-05-14 17:06:21', 300.00);
INSERT INTO public.product_ingredients VALUES (143, 'mg', 44, 247, '2025-05-14 17:06:21', '2025-05-14 17:06:21', 50.00);
INSERT INTO public.product_ingredients VALUES (144, 'g', 44, 206, '2025-05-14 17:06:21', '2025-05-14 17:06:21', 1.00);
INSERT INTO public.product_ingredients VALUES (76, 'mg', 36, 230, '2025-05-11 21:01:12', '2025-05-11 21:01:12', 10.00);
INSERT INTO public.product_ingredients VALUES (77, 'mg', 36, 274, '2025-05-11 21:01:12', '2025-05-11 21:01:12', 150.00);
INSERT INTO public.product_ingredients VALUES (78, 'mcg', 36, 210, '2025-05-11 21:01:12', '2025-05-11 21:01:12', 50.00);
INSERT INTO public.product_ingredients VALUES (79, 'g', 36, 202, '2025-05-11 21:01:12', '2025-05-11 21:01:12', 1.00);
INSERT INTO public.product_ingredients VALUES (80, 'mg', 36, 275, '2025-05-11 21:01:12', '2025-05-11 21:01:12', 100.00);
INSERT INTO public.product_ingredients VALUES (81, 'mg', 36, 273, '2025-05-11 21:01:13', '2025-05-11 21:01:13', 190.00);
INSERT INTO public.product_ingredients VALUES (82, 'mg', 37, 230, '2025-05-11 21:03:59', '2025-05-11 21:03:59', 10.00);
INSERT INTO public.product_ingredients VALUES (83, 'mg', 37, 274, '2025-05-11 21:03:59', '2025-05-11 21:03:59', 150.00);
INSERT INTO public.product_ingredients VALUES (84, 'mcg', 37, 210, '2025-05-11 21:03:59', '2025-05-11 21:03:59', 50.00);
INSERT INTO public.product_ingredients VALUES (85, 'g', 37, 202, '2025-05-11 21:03:59', '2025-05-11 21:03:59', 1.00);
INSERT INTO public.product_ingredients VALUES (86, 'mg', 37, 275, '2025-05-11 21:03:59', '2025-05-11 21:03:59', 100.00);
INSERT INTO public.product_ingredients VALUES (87, 'mg', 37, 273, '2025-05-11 21:03:59', '2025-05-11 21:03:59', 190.00);
INSERT INTO public.product_ingredients VALUES (88, 'g', 40, 199, '2025-05-11 21:22:23', '2025-05-11 21:22:23', 3.20);
INSERT INTO public.product_ingredients VALUES (89, 'g', 40, 200, '2025-05-11 21:22:23', '2025-05-11 21:22:23', 2.50);
INSERT INTO public.product_ingredients VALUES (90, 'g', 40, 197, '2025-05-11 21:22:23', '2025-05-11 21:22:23', 5.00);
INSERT INTO public.product_ingredients VALUES (91, 'g', 40, 202, '2025-05-11 21:22:23', '2025-05-11 21:22:23', 1.00);
INSERT INTO public.product_ingredients VALUES (92, 'g', 40, 277, '2025-05-11 21:22:23', '2025-05-11 21:22:23', 1.00);
INSERT INTO public.product_ingredients VALUES (93, 'mg', 40, 239, '2025-05-11 21:22:23', '2025-05-11 21:22:23', 50.00);
INSERT INTO public.product_ingredients VALUES (94, 'g', 35, 213, '2025-05-11 21:24:04', '2025-05-11 21:24:04', 1.00);
INSERT INTO public.product_ingredients VALUES (95, 'mg', 35, 209, '2025-05-11 21:24:04', '2025-05-11 21:24:04', 600.00);
INSERT INTO public.product_ingredients VALUES (96, 'g', 35, 271, '2025-05-11 21:24:04', '2025-05-11 21:24:04', 2.00);
INSERT INTO public.product_ingredients VALUES (97, 'mg', 35, 220, '2025-05-11 21:24:04', '2025-05-11 21:24:04', 250.00);
INSERT INTO public.product_ingredients VALUES (98, 'mg', 35, 272, '2025-05-11 21:24:04', '2025-05-11 21:24:04', 150.00);
INSERT INTO public.product_ingredients VALUES (108, 'mg', 41, 209, '2025-05-14 16:25:55', '2025-05-14 16:25:55', 200.00);
INSERT INTO public.product_ingredients VALUES (109, 'g', 41, 199, '2025-05-14 16:25:55', '2025-05-14 16:25:55', 3.00);
INSERT INTO public.product_ingredients VALUES (110, 'mg', 41, 248, '2025-05-14 16:25:55', '2025-05-14 16:25:55', 150.00);
INSERT INTO public.product_ingredients VALUES (111, 'mg', 41, 205, '2025-05-14 16:25:55', '2025-05-14 16:25:55', 500.00);
INSERT INTO public.product_ingredients VALUES (112, 'mg', 41, 206, '2025-05-14 16:25:55', '2025-05-14 16:25:55', 500.00);
INSERT INTO public.product_ingredients VALUES (113, 'mg', 41, 236, '2025-05-14 16:25:55', '2025-05-14 16:25:55', 80.00);
INSERT INTO public.product_ingredients VALUES (114, 'mcg', 41, 210, '2025-05-14 16:25:55', '2025-05-14 16:25:55', 50.00);
INSERT INTO public.product_ingredients VALUES (115, 'g', 41, 198, '2025-05-14 16:25:55', '2025-05-14 16:25:55', 4.00);
INSERT INTO public.product_ingredients VALUES (116, 'g', 41, 201, '2025-05-14 16:25:55', '2025-05-14 16:25:55', 2.00);
INSERT INTO public.product_ingredients VALUES (117, 'mg', 41, 202, '2025-05-14 16:25:55', '2025-05-14 16:25:55', 750.00);
INSERT INTO public.product_ingredients VALUES (123, 'mg', 42, 230, '2025-05-14 16:31:21', '2025-05-14 16:31:21', 5.00);
INSERT INTO public.product_ingredients VALUES (124, 'mg', 42, 280, '2025-05-14 16:31:21', '2025-05-14 16:31:21', 100.00);
INSERT INTO public.product_ingredients VALUES (125, 'g', 42, 271, '2025-05-14 16:31:21', '2025-05-14 16:31:21', 2.00);
INSERT INTO public.product_ingredients VALUES (126, 'g', 42, 198, '2025-05-14 16:31:21', '2025-05-14 16:31:21', 5.00);
INSERT INTO public.product_ingredients VALUES (127, 'g', 42, 201, '2025-05-14 16:31:21', '2025-05-14 16:31:21', 2.00);
INSERT INTO public.product_ingredients VALUES (128, 'mg', 42, 225, '2025-05-14 16:31:21', '2025-05-14 16:31:21', 500.00);
INSERT INTO public.product_ingredients VALUES (129, 'mg', 43, 209, '2025-05-14 17:01:34', '2025-05-14 17:01:34', 300.00);
INSERT INTO public.product_ingredients VALUES (130, 'g', 43, 199, '2025-05-14 17:01:34', '2025-05-14 17:01:34', 1.60);
INSERT INTO public.product_ingredients VALUES (131, 'g', 43, 200, '2025-05-14 17:01:34', '2025-05-14 17:01:34', 2.50);
INSERT INTO public.product_ingredients VALUES (132, 'mg', 43, 205, '2025-05-14 17:01:34', '2025-05-14 17:01:34', 300.00);
INSERT INTO public.product_ingredients VALUES (133, 'mg', 43, 247, '2025-05-14 17:01:34', '2025-05-14 17:01:34', 50.00);
INSERT INTO public.product_ingredients VALUES (134, 'g', 43, 197, '2025-05-14 17:01:34', '2025-05-14 17:01:34', 2.50);
INSERT INTO public.product_ingredients VALUES (135, 'mcg', 43, 210, '2025-05-14 17:01:34', '2025-05-14 17:01:34', 400.00);
INSERT INTO public.product_ingredients VALUES (136, 'g', 43, 243, '2025-05-14 17:01:34', '2025-05-14 17:01:34', 1.00);
INSERT INTO public.product_ingredients VALUES (137, 'g', 43, 198, '2025-05-14 17:01:34', '2025-05-14 17:01:34', 5.00);
INSERT INTO public.product_ingredients VALUES (138, 'g', 43, 201, '2025-05-14 17:01:34', '2025-05-14 17:01:34', 2.00);
INSERT INTO public.product_ingredients VALUES (139, 'g', 43, 202, '2025-05-14 17:01:34', '2025-05-14 17:01:34', 1.00);
INSERT INTO public.product_ingredients VALUES (145, 'mg', 44, 197, '2025-05-14 17:06:21', '2025-05-14 17:06:21', 5.00);
INSERT INTO public.product_ingredients VALUES (146, 'mg', 44, 216, '2025-05-14 17:06:21', '2025-05-14 17:06:21', 50.00);
INSERT INTO public.product_ingredients VALUES (147, 'mcg', 44, 210, '2025-05-14 17:06:21', '2025-05-14 17:06:21', 400.00);
INSERT INTO public.product_ingredients VALUES (148, 'g', 44, 243, '2025-05-14 17:06:21', '2025-05-14 17:06:21', 2.00);
INSERT INTO public.product_ingredients VALUES (149, 'g', 44, 198, '2025-05-14 17:06:21', '2025-05-14 17:06:21', 8.00);
INSERT INTO public.product_ingredients VALUES (150, 'mg', 44, 244, '2025-05-14 17:06:21', '2025-05-14 17:06:21', 600.00);
INSERT INTO public.product_ingredients VALUES (151, 'mg', 44, 254, '2025-05-14 17:06:21', '2025-05-14 17:06:21', 400.00);
INSERT INTO public.product_ingredients VALUES (152, 'g', 44, 201, '2025-05-14 17:06:22', '2025-05-14 17:06:22', 2.00);
INSERT INTO public.product_ingredients VALUES (153, 'g', 44, 225, '2025-05-14 17:06:22', '2025-05-14 17:06:22', 1.00);
INSERT INTO public.product_ingredients VALUES (154, 'mg', 45, 205, '2025-05-14 22:11:33', '2025-05-14 22:11:33', 100.00);
INSERT INTO public.product_ingredients VALUES (155, 'g', 45, 197, '2025-05-14 22:11:33', '2025-05-14 22:11:33', 2.50);
INSERT INTO public.product_ingredients VALUES (156, 'mg', 45, 259, '2025-05-14 22:11:33', '2025-05-14 22:11:33', 800.00);
INSERT INTO public.product_ingredients VALUES (157, 'mg', 45, 260, '2025-05-14 22:11:33', '2025-05-14 22:11:33', 75.00);
INSERT INTO public.product_ingredients VALUES (158, 'mg', 45, 257, '2025-05-14 22:11:33', '2025-05-14 22:11:33', 25.00);
INSERT INTO public.product_ingredients VALUES (159, 'mg', 46, 209, '2025-05-14 22:17:21', '2025-05-14 22:17:21', 400.00);
INSERT INTO public.product_ingredients VALUES (160, 'g', 46, 199, '2025-05-14 22:17:21', '2025-05-14 22:17:21', 3.00);
INSERT INTO public.product_ingredients VALUES (161, 'g', 46, 200, '2025-05-14 22:17:21', '2025-05-14 22:17:21', 2.50);
INSERT INTO public.product_ingredients VALUES (162, 'mg', 46, 205, '2025-05-14 22:17:21', '2025-05-14 22:17:21', 200.00);
INSERT INTO public.product_ingredients VALUES (163, 'g', 46, 292, '2025-05-14 22:17:21', '2025-05-14 22:17:21', 1.00);
INSERT INTO public.product_ingredients VALUES (164, 'mg', 46, 293, '2025-05-14 22:17:21', '2025-05-14 22:17:21', 100.00);
INSERT INTO public.product_ingredients VALUES (165, 'g', 46, 198, '2025-05-14 22:17:21', '2025-05-14 22:17:21', 6.00);
INSERT INTO public.product_ingredients VALUES (166, 'g', 46, 201, '2025-05-14 22:17:21', '2025-05-14 22:17:21', 2.00);
INSERT INTO public.product_ingredients VALUES (167, 'mg', 46, 204, '2025-05-14 22:17:21', '2025-05-14 22:17:21', 250.00);
INSERT INTO public.product_ingredients VALUES (168, 'mg', 46, 208, '2025-05-14 22:17:21', '2025-05-14 22:17:21', 100.00);
INSERT INTO public.product_ingredients VALUES (169, 'mg', 46, 294, '2025-05-14 22:17:22', '2025-05-14 22:17:22', 100.00);
INSERT INTO public.product_ingredients VALUES (170, 'g', 47, 213, '2025-05-14 22:20:57', '2025-05-14 22:20:57', 1.25);
INSERT INTO public.product_ingredients VALUES (171, 'mg', 47, 296, '2025-05-14 22:20:57', '2025-05-14 22:20:57', 125.00);
INSERT INTO public.product_ingredients VALUES (172, 'g', 47, 200, '2025-05-14 22:20:58', '2025-05-14 22:20:58', 1.00);
INSERT INTO public.product_ingredients VALUES (173, 'mg', 47, 230, '2025-05-14 22:20:58', '2025-05-14 22:20:58', 5.00);
INSERT INTO public.product_ingredients VALUES (174, 'mg', 47, 292, '2025-05-14 22:20:58', '2025-05-14 22:20:58', 750.00);
INSERT INTO public.product_ingredients VALUES (175, 'g', 47, 295, '2025-05-14 22:20:58', '2025-05-14 22:20:58', 1.50);
INSERT INTO public.product_ingredients VALUES (176, 'g', 47, 198, '2025-05-14 22:20:58', '2025-05-14 22:20:58', 8.00);
INSERT INTO public.product_ingredients VALUES (177, 'mg', 47, 239, '2025-05-14 22:20:58', '2025-05-14 22:20:58', 75.00);
INSERT INTO public.product_ingredients VALUES (188, 'g', 50, 198, '2025-05-18 00:15:36', '2025-05-18 00:15:36', 4.00);
INSERT INTO public.product_ingredients VALUES (189, 'g', 50, 199, '2025-05-18 00:15:36', '2025-05-18 00:15:36', 3.20);
INSERT INTO public.product_ingredients VALUES (190, 'mg', 50, 242, '2025-05-18 00:15:36', '2025-05-18 00:15:36', 250.00);
INSERT INTO public.product_ingredients VALUES (191, 'mg', 50, 237, '2025-05-18 00:15:36', '2025-05-18 00:15:36', 40.00);
INSERT INTO public.product_ingredients VALUES (192, 'mg', 50, 230, '2025-05-18 00:15:36', '2025-05-18 00:15:36', 10.00);
INSERT INTO public.product_ingredients VALUES (193, 'mg', 50, 223, '2025-05-18 00:15:36', '2025-05-18 00:15:36', 5.00);
INSERT INTO public.product_ingredients VALUES (194, 'mg', 50, 228, '2025-05-18 00:15:37', '2025-05-18 00:15:37', 1.00);
INSERT INTO public.product_ingredients VALUES (195, 'g', 50, 206, '2025-05-18 00:15:37', '2025-05-18 00:15:37', 1.00);
INSERT INTO public.product_ingredients VALUES (196, 'g', 50, 202, '2025-05-18 00:15:37', '2025-05-18 00:15:37', 1.00);
INSERT INTO public.product_ingredients VALUES (197, 'mg', 50, 301, '2025-05-18 00:15:37', '2025-05-18 00:15:37', 500.00);
INSERT INTO public.product_ingredients VALUES (198, 'mg', 50, 241, '2025-05-18 00:15:37', '2025-05-18 00:15:37', 500.00);
INSERT INTO public.product_ingredients VALUES (199, 'mg', 50, 240, '2025-05-18 00:15:37', '2025-05-18 00:15:37', 400.00);
INSERT INTO public.product_ingredients VALUES (200, 'mg', 50, 205, '2025-05-18 00:15:37', '2025-05-18 00:15:37', 260.00);
INSERT INTO public.product_ingredients VALUES (201, 'mg', 50, 238, '2025-05-18 00:15:37', '2025-05-18 00:15:37', 30.00);
INSERT INTO public.product_ingredients VALUES (202, 'mg', 50, 302, '2025-05-18 00:15:37', '2025-05-18 00:15:37', 30.00);
INSERT INTO public.product_ingredients VALUES (203, 'g', 51, 198, '2025-05-18 00:18:48', '2025-05-18 00:18:48', 4.00);
INSERT INTO public.product_ingredients VALUES (204, 'g', 51, 199, '2025-05-18 00:18:48', '2025-05-18 00:18:48', 3.20);
INSERT INTO public.product_ingredients VALUES (205, 'mg', 51, 230, '2025-05-18 00:18:48', '2025-05-18 00:18:48', 10.00);
INSERT INTO public.product_ingredients VALUES (206, 'g', 51, 200, '2025-05-18 00:18:49', '2025-05-18 00:18:49', 2.50);
INSERT INTO public.product_ingredients VALUES (207, 'g', 51, 202, '2025-05-18 00:18:49', '2025-05-18 00:18:49', 1.50);
INSERT INTO public.product_ingredients VALUES (208, 'g', 51, 301, '2025-05-18 00:18:49', '2025-05-18 00:18:49', 1.00);
INSERT INTO public.product_ingredients VALUES (209, 'mg', 51, 240, '2025-05-18 00:18:49', '2025-05-18 00:18:49', 400.00);
INSERT INTO public.product_ingredients VALUES (210, 'mg', 51, 205, '2025-05-18 00:18:49', '2025-05-18 00:18:49', 275.00);
INSERT INTO public.product_ingredients VALUES (211, 'mg', 51, 238, '2025-05-18 00:18:49', '2025-05-18 00:18:49', 30.00);
INSERT INTO public.product_ingredients VALUES (212, 'mg', 51, 302, '2025-05-18 00:18:49', '2025-05-18 00:18:49', 20.00);
INSERT INTO public.product_ingredients VALUES (213, 'mg', 51, 239, '2025-05-18 00:18:49', '2025-05-18 00:18:49', 50.00);
INSERT INTO public.product_ingredients VALUES (214, 'g', 52, 198, '2025-05-18 00:21:56', '2025-05-18 00:21:56', 4.00);
INSERT INTO public.product_ingredients VALUES (215, 'g', 52, 199, '2025-05-18 00:21:56', '2025-05-18 00:21:56', 3.20);
INSERT INTO public.product_ingredients VALUES (216, 'mg', 52, 239, '2025-05-18 00:21:56', '2025-05-18 00:21:56', 50.00);
INSERT INTO public.product_ingredients VALUES (217, 'mg', 52, 210, '2025-05-18 00:21:56', '2025-05-18 00:21:56', 20.00);
INSERT INTO public.product_ingredients VALUES (218, 'mg', 52, 230, '2025-05-18 00:21:56', '2025-05-18 00:21:56', 10.00);
INSERT INTO public.product_ingredients VALUES (219, 'mg', 52, 228, '2025-05-18 00:21:56', '2025-05-18 00:21:56', 1.00);
INSERT INTO public.product_ingredients VALUES (220, 'g', 52, 200, '2025-05-18 00:21:56', '2025-05-18 00:21:56', 2.50);
INSERT INTO public.product_ingredients VALUES (221, 'g', 52, 202, '2025-05-18 00:21:56', '2025-05-18 00:21:56', 1.00);
INSERT INTO public.product_ingredients VALUES (222, 'g', 52, 301, '2025-05-18 00:21:56', '2025-05-18 00:21:56', 1.00);
INSERT INTO public.product_ingredients VALUES (223, 'mg', 52, 240, '2025-05-18 00:21:57', '2025-05-18 00:21:57', 400.00);
INSERT INTO public.product_ingredients VALUES (224, 'mg', 52, 205, '2025-05-18 00:21:57', '2025-05-18 00:21:57', 320.00);
INSERT INTO public.product_ingredients VALUES (225, 'mg', 52, 238, '2025-05-18 00:21:57', '2025-05-18 00:21:57', 35.00);
INSERT INTO public.product_ingredients VALUES (226, 'mg', 52, 302, '2025-05-18 00:21:57', '2025-05-18 00:21:57', 15.00);
INSERT INTO public.product_ingredients VALUES (227, 'mg', 52, 276, '2025-05-18 00:21:57', '2025-05-18 00:21:57', 100.00);
INSERT INTO public.product_ingredients VALUES (228, 'g', 53, 198, '2025-05-18 00:24:13', '2025-05-18 00:24:13', 8.00);
INSERT INTO public.product_ingredients VALUES (229, 'g', 53, 199, '2025-05-18 00:24:13', '2025-05-18 00:24:13', 3.50);
INSERT INTO public.product_ingredients VALUES (230, 'g', 53, 243, '2025-05-18 00:24:13', '2025-05-18 00:24:13', 3.00);
INSERT INTO public.product_ingredients VALUES (231, 'mg', 53, 244, '2025-05-18 00:24:13', '2025-05-18 00:24:13', 600.00);
INSERT INTO public.product_ingredients VALUES (232, 'mg', 53, 209, '2025-05-18 00:24:13', '2025-05-18 00:24:13', 300.00);
INSERT INTO public.product_ingredients VALUES (233, 'mg', 53, 239, '2025-05-18 00:24:13', '2025-05-18 00:24:13', 150.00);
INSERT INTO public.product_ingredients VALUES (234, 'mg', 53, 211, '2025-05-18 00:24:13', '2025-05-18 00:24:13', 50.00);
INSERT INTO public.product_ingredients VALUES (235, 'mg', 53, 210, '2025-05-18 00:24:13', '2025-05-18 00:24:13', 20.00);
INSERT INTO public.product_ingredients VALUES (236, 'g', 54, 198, '2025-05-18 00:26:36', '2025-05-18 00:26:36', 3.00);
INSERT INTO public.product_ingredients VALUES (237, 'g', 54, 197, '2025-05-18 00:26:36', '2025-05-18 00:26:36', 2.50);
INSERT INTO public.product_ingredients VALUES (238, 'g', 54, 199, '2025-05-18 00:26:36', '2025-05-18 00:26:36', 1.60);
INSERT INTO public.product_ingredients VALUES (239, 'mg', 54, 301, '2025-05-18 00:26:36', '2025-05-18 00:26:36', 500.00);
INSERT INTO public.product_ingredients VALUES (240, 'mg', 54, 205, '2025-05-18 00:26:36', '2025-05-18 00:26:36', 150.50);
INSERT INTO public.product_ingredients VALUES (241, 'mg', 54, 238, '2025-05-18 00:26:36', '2025-05-18 00:26:36', 10.00);
INSERT INTO public.product_ingredients VALUES (242, 'mg', 54, 302, '2025-05-18 00:26:36', '2025-05-18 00:26:36', 5.00);
INSERT INTO public.product_ingredients VALUES (243, 'g', 55, 198, '2025-05-18 01:51:03', '2025-05-18 01:51:03', 6.50);
INSERT INTO public.product_ingredients VALUES (244, 'g', 55, 199, '2025-05-18 01:51:03', '2025-05-18 01:51:03', 4.00);
INSERT INTO public.product_ingredients VALUES (245, 'mg', 55, 303, '2025-05-18 01:51:03', '2025-05-18 01:51:03', 300.00);
INSERT INTO public.product_ingredients VALUES (246, 'mcg', 55, 210, '2025-05-18 01:51:03', '2025-05-18 01:51:03', 300.00);
INSERT INTO public.product_ingredients VALUES (247, 'mg', 55, 304, '2025-05-18 01:51:03', '2025-05-18 01:51:03', 30.00);
INSERT INTO public.product_ingredients VALUES (248, 'g', 55, 202, '2025-05-18 01:51:03', '2025-05-18 01:51:03', 1.50);
INSERT INTO public.product_ingredients VALUES (249, 'g', 55, 200, '2025-05-18 01:51:03', '2025-05-18 01:51:03', 4.00);
INSERT INTO public.product_ingredients VALUES (250, 'g', 55, 213, '2025-05-18 01:51:03', '2025-05-18 01:51:03', 1.00);
INSERT INTO public.product_ingredients VALUES (251, 'mg', 55, 209, '2025-05-18 01:51:04', '2025-05-18 01:51:04', 600.00);
INSERT INTO public.product_ingredients VALUES (252, 'mg', 55, 205, '2025-05-18 01:51:04', '2025-05-18 01:51:04', 325.00);
INSERT INTO public.product_ingredients VALUES (253, 'mg', 55, 208, '2025-05-18 01:51:04', '2025-05-18 01:51:04', 300.00);
INSERT INTO public.product_ingredients VALUES (254, 'mg', 55, 219, '2025-05-18 01:51:04', '2025-05-18 01:51:04', 150.00);
INSERT INTO public.product_ingredients VALUES (255, 'mg', 55, 274, '2025-05-18 01:51:04', '2025-05-18 01:51:04', 125.00);
INSERT INTO public.product_ingredients VALUES (256, 'g', 56, 198, '2025-05-18 01:57:25', '2025-05-18 01:57:25', 4.00);
INSERT INTO public.product_ingredients VALUES (257, 'g', 56, 200, '2025-05-18 01:57:25', '2025-05-18 01:57:25', 2.00);
INSERT INTO public.product_ingredients VALUES (258, 'g', 56, 199, '2025-05-18 01:57:25', '2025-05-18 01:57:25', 1.50);
INSERT INTO public.product_ingredients VALUES (259, 'g', 56, 203, '2025-05-18 01:57:25', '2025-05-18 01:57:25', 1.00);
INSERT INTO public.product_ingredients VALUES (260, 'mg', 56, 225, '2025-05-18 01:57:25', '2025-05-18 01:57:25', 500.00);
INSERT INTO public.product_ingredients VALUES (261, 'mg', 56, 205, '2025-05-18 01:57:25', '2025-05-18 01:57:25', 395.00);
INSERT INTO public.product_ingredients VALUES (262, 'mg', 56, 228, '2025-05-18 01:57:25', '2025-05-18 01:57:25', 2.00);
INSERT INTO public.product_ingredients VALUES (263, 'mcg', 56, 210, '2025-05-18 01:57:25', '2025-05-18 01:57:25', 150.00);
INSERT INTO public.product_ingredients VALUES (264, 'g', 56, 305, '2025-05-18 01:57:25', '2025-05-18 01:57:25', 1.00);
INSERT INTO public.product_ingredients VALUES (265, 'g', 57, 198, '2025-05-18 02:09:53', '2025-05-18 02:09:53', 9.00);
INSERT INTO public.product_ingredients VALUES (266, 'g', 57, 199, '2025-05-18 02:09:53', '2025-05-18 02:09:53', 5.00);
INSERT INTO public.product_ingredients VALUES (267, 'mg', 57, 274, '2025-05-18 02:09:53', '2025-05-18 02:09:53', 175.00);
INSERT INTO public.product_ingredients VALUES (268, 'mg', 57, 238, '2025-05-18 02:09:53', '2025-05-18 02:09:53', 50.00);
INSERT INTO public.product_ingredients VALUES (269, 'g', 57, 200, '2025-05-18 02:09:53', '2025-05-18 02:09:53', 5.00);
INSERT INTO public.product_ingredients VALUES (270, 'g', 57, 197, '2025-05-18 02:09:53', '2025-05-18 02:09:53', 5.00);
INSERT INTO public.product_ingredients VALUES (271, 'g', 57, 209, '2025-05-18 02:09:54', '2025-05-18 02:09:54', 1.20);
INSERT INTO public.product_ingredients VALUES (272, 'g', 57, 225, '2025-05-18 02:09:54', '2025-05-18 02:09:54', 1.00);
INSERT INTO public.product_ingredients VALUES (273, 'mg', 57, 204, '2025-05-18 02:09:54', '2025-05-18 02:09:54', 500.00);
INSERT INTO public.product_ingredients VALUES (274, 'mg', 57, 245, '2025-05-18 02:09:54', '2025-05-18 02:09:54', 254.00);
INSERT INTO public.product_ingredients VALUES (275, 'mg', 57, 208, '2025-05-18 02:09:54', '2025-05-18 02:09:54', 200.00);
INSERT INTO public.product_ingredients VALUES (276, 'mg', 57, 205, '2025-05-18 02:09:54', '2025-05-18 02:09:54', 175.00);
INSERT INTO public.product_ingredients VALUES (277, 'g', 58, 198, '2025-05-18 02:12:19', '2025-05-18 02:12:19', 9.00);
INSERT INTO public.product_ingredients VALUES (278, 'g', 58, 199, '2025-05-18 02:12:19', '2025-05-18 02:12:19', 5.00);
INSERT INTO public.product_ingredients VALUES (279, 'mg', 58, 238, '2025-05-18 02:12:19', '2025-05-18 02:12:19', 25.00);
INSERT INTO public.product_ingredients VALUES (280, 'g', 58, 200, '2025-05-18 02:12:19', '2025-05-18 02:12:19', 5.00);
INSERT INTO public.product_ingredients VALUES (281, 'g', 58, 197, '2025-05-18 02:12:19', '2025-05-18 02:12:19', 5.00);
INSERT INTO public.product_ingredients VALUES (282, 'g', 58, 209, '2025-05-18 02:12:19', '2025-05-18 02:12:19', 1.20);
INSERT INTO public.product_ingredients VALUES (283, 'g', 58, 225, '2025-05-18 02:12:19', '2025-05-18 02:12:19', 1.00);
INSERT INTO public.product_ingredients VALUES (284, 'mg', 58, 204, '2025-05-18 02:12:19', '2025-05-18 02:12:19', 500.00);
INSERT INTO public.product_ingredients VALUES (285, 'mg', 58, 245, '2025-05-18 02:12:19', '2025-05-18 02:12:19', 254.00);
INSERT INTO public.product_ingredients VALUES (286, 'mg', 58, 208, '2025-05-18 02:12:20', '2025-05-18 02:12:20', 200.00);
INSERT INTO public.product_ingredients VALUES (287, 'mg', 58, 205, '2025-05-18 02:12:20', '2025-05-18 02:12:20', 200.00);
INSERT INTO public.product_ingredients VALUES (302, 'g', 60, 198, '2025-05-18 02:19:49', '2025-05-18 02:19:49', 3.00);
INSERT INTO public.product_ingredients VALUES (303, 'g', 60, 199, '2025-05-18 02:19:49', '2025-05-18 02:19:49', 3.00);
INSERT INTO public.product_ingredients VALUES (304, 'mg', 60, 224, '2025-05-18 02:19:50', '2025-05-18 02:19:50', 30.00);
INSERT INTO public.product_ingredients VALUES (305, 'mg', 60, 228, '2025-05-18 02:19:50', '2025-05-18 02:19:50', 1.00);
INSERT INTO public.product_ingredients VALUES (306, 'mg', 60, 214, '2025-05-18 02:19:50', '2025-05-18 02:19:50', 1.00);
INSERT INTO public.product_ingredients VALUES (307, 'mcg', 60, 210, '2025-05-18 02:19:50', '2025-05-18 02:19:50', 100.00);
INSERT INTO public.product_ingredients VALUES (308, 'g', 60, 200, '2025-05-18 02:19:50', '2025-05-18 02:19:50', 2.00);
INSERT INTO public.product_ingredients VALUES (309, 'g', 60, 202, '2025-05-18 02:19:50', '2025-05-18 02:19:50', 1.25);
INSERT INTO public.product_ingredients VALUES (310, 'mg', 60, 225, '2025-05-18 02:19:50', '2025-05-18 02:19:50', 750.00);
INSERT INTO public.product_ingredients VALUES (311, 'mg', 60, 204, '2025-05-18 02:19:50', '2025-05-18 02:19:50', 350.00);
INSERT INTO public.product_ingredients VALUES (312, 'mg', 60, 205, '2025-05-18 02:19:50', '2025-05-18 02:19:50', 325.00);
INSERT INTO public.product_ingredients VALUES (313, 'mg', 60, 244, '2025-05-18 02:19:50', '2025-05-18 02:19:50', 300.00);
INSERT INTO public.product_ingredients VALUES (314, 'mg', 60, 208, '2025-05-18 02:19:50', '2025-05-18 02:19:50', 150.00);
INSERT INTO public.product_ingredients VALUES (315, 'mg', 60, 216, '2025-05-18 02:19:50', '2025-05-18 02:19:50', 75.00);
INSERT INTO public.product_ingredients VALUES (316, 'g', 61, 198, '2025-05-18 02:25:17', '2025-05-18 02:25:17', 8.00);
INSERT INTO public.product_ingredients VALUES (317, 'g', 61, 199, '2025-05-18 02:25:17', '2025-05-18 02:25:17', 3.20);
INSERT INTO public.product_ingredients VALUES (318, 'mg', 61, 307, '2025-05-18 02:25:17', '2025-05-18 02:25:17', 500.00);
INSERT INTO public.product_ingredients VALUES (319, 'mg', 61, 308, '2025-05-18 02:25:17', '2025-05-18 02:25:17', 250.00);
INSERT INTO public.product_ingredients VALUES (320, 'mg', 61, 309, '2025-05-18 02:25:17', '2025-05-18 02:25:17', 60.00);
INSERT INTO public.product_ingredients VALUES (321, 'mg', 61, 223, '2025-05-18 02:25:17', '2025-05-18 02:25:17', 20.00);
INSERT INTO public.product_ingredients VALUES (322, 'mg', 61, 230, '2025-05-18 02:25:18', '2025-05-18 02:25:18', 5.00);
INSERT INTO public.product_ingredients VALUES (323, 'mg', 61, 232, '2025-05-18 02:25:18', '2025-05-18 02:25:18', 500.00);
INSERT INTO public.product_ingredients VALUES (324, 'mg', 61, 205, '2025-05-18 02:25:18', '2025-05-18 02:25:18', 350.00);
INSERT INTO public.product_ingredients VALUES (325, 'mg', 61, 206, '2025-05-18 02:25:18', '2025-05-18 02:25:18', 300.00);
INSERT INTO public.product_ingredients VALUES (326, 'mg', 61, 248, '2025-05-18 02:25:18', '2025-05-18 02:25:18', 130.00);
INSERT INTO public.product_ingredients VALUES (327, 'mg', 61, 274, '2025-05-18 02:25:18', '2025-05-18 02:25:18', 100.00);
INSERT INTO public.product_ingredients VALUES (328, 'mg', 61, 249, '2025-05-18 02:25:18', '2025-05-18 02:25:18', 100.00);
INSERT INTO public.product_ingredients VALUES (329, 'mg', 61, 222, '2025-05-18 02:25:18', '2025-05-18 02:25:18', 75.00);
INSERT INTO public.product_ingredients VALUES (330, 'g', 61, 306, '2025-05-18 02:25:18', '2025-05-18 02:25:18', 2.00);
INSERT INTO public.product_ingredients VALUES (331, 'g', 62, 198, '2025-05-18 02:27:38', '2025-05-18 02:27:38', 6.00);
INSERT INTO public.product_ingredients VALUES (332, 'g', 62, 200, '2025-05-18 02:27:38', '2025-05-18 02:27:38', 2.50);
INSERT INTO public.product_ingredients VALUES (333, 'g', 62, 271, '2025-05-18 02:27:38', '2025-05-18 02:27:38', 2.00);
INSERT INTO public.product_ingredients VALUES (334, 'mg', 62, 199, '2025-05-18 02:27:38', '2025-05-18 02:27:38', 1.50);
INSERT INTO public.product_ingredients VALUES (335, 'g', 62, 225, '2025-05-18 02:27:38', '2025-05-18 02:27:38', 1.20);
INSERT INTO public.product_ingredients VALUES (336, 'mg', 62, 213, '2025-05-18 02:27:38', '2025-05-18 02:27:38', 500.00);
INSERT INTO public.product_ingredients VALUES (337, 'mg', 62, 310, '2025-05-18 02:27:38', '2025-05-18 02:27:38', 250.00);
INSERT INTO public.product_ingredients VALUES (338, 'g', 63, 198, '2025-05-18 02:29:11', '2025-05-18 02:29:11', 4.00);
INSERT INTO public.product_ingredients VALUES (339, 'g', 63, 200, '2025-05-18 02:29:11', '2025-05-18 02:29:11', 2.00);
INSERT INTO public.product_ingredients VALUES (340, 'g', 63, 199, '2025-05-18 02:29:11', '2025-05-18 02:29:11', 1.50);
INSERT INTO public.product_ingredients VALUES (341, 'g', 63, 305, '2025-05-18 02:29:11', '2025-05-18 02:29:11', 1.00);
INSERT INTO public.product_ingredients VALUES (342, 'g', 63, 203, '2025-05-18 02:29:11', '2025-05-18 02:29:11', 1.00);
INSERT INTO public.product_ingredients VALUES (343, 'mg', 63, 225, '2025-05-18 02:29:11', '2025-05-18 02:29:11', 500.00);
INSERT INTO public.product_ingredients VALUES (344, 'g', 64, 198, '2025-05-24 18:51:36', '2025-05-24 18:51:36', 6.00);
INSERT INTO public.product_ingredients VALUES (345, 'g', 64, 199, '2025-05-24 18:51:36', '2025-05-24 18:51:36', 2.50);
INSERT INTO public.product_ingredients VALUES (346, 'mg', 64, 257, '2025-05-24 18:51:36', '2025-05-24 18:51:36', 25.00);
INSERT INTO public.product_ingredients VALUES (347, 'g', 64, 201, '2025-05-24 18:51:36', '2025-05-24 18:51:36', 1.00);
INSERT INTO public.product_ingredients VALUES (348, 'g', 64, 202, '2025-05-24 18:51:37', '2025-05-24 18:51:37', 1.00);
INSERT INTO public.product_ingredients VALUES (349, 'mg', 64, 206, '2025-05-24 18:51:37', '2025-05-24 18:51:37', 300.00);
INSERT INTO public.product_ingredients VALUES (350, 'mg', 64, 207, '2025-05-24 18:51:37', '2025-05-24 18:51:37', 50.00);
INSERT INTO public.product_ingredients VALUES (351, 'mcg', 64, 210, '2025-05-24 18:51:37', '2025-05-24 18:51:37', 100.00);
INSERT INTO public.product_ingredients VALUES (352, 'mg', 64, 205, '2025-05-24 18:51:37', '2025-05-24 18:51:37', 300.00);
INSERT INTO public.product_ingredients VALUES (353, 'mg', 64, 239, '2025-05-24 18:51:37', '2025-05-24 18:51:37', 200.00);
INSERT INTO public.product_ingredients VALUES (354, 'mg', 64, 211, '2025-05-24 18:51:37', '2025-05-24 18:51:37', 25.00);
INSERT INTO public.product_ingredients VALUES (355, 'g', 65, 198, '2025-05-24 18:55:43', '2025-05-24 18:55:43', 3.00);
INSERT INTO public.product_ingredients VALUES (356, 'mg', 65, 225, '2025-05-24 18:55:44', '2025-05-24 18:55:44', 750.00);
INSERT INTO public.product_ingredients VALUES (357, 'g', 65, 199, '2025-05-24 18:55:44', '2025-05-24 18:55:44', 1.60);
INSERT INTO public.product_ingredients VALUES (358, 'g', 65, 200, '2025-05-24 18:55:44', '2025-05-24 18:55:44', 1.25);
INSERT INTO public.product_ingredients VALUES (359, 'g', 65, 201, '2025-05-24 18:55:44', '2025-05-24 18:55:44', 1.00);
INSERT INTO public.product_ingredients VALUES (360, 'g', 65, 202, '2025-05-24 18:55:44', '2025-05-24 18:55:44', 1.00);
INSERT INTO public.product_ingredients VALUES (361, 'g', 66, 198, '2025-05-24 18:57:52', '2025-05-24 18:57:52', 6.00);
INSERT INTO public.product_ingredients VALUES (362, 'g', 66, 199, '2025-05-24 18:57:52', '2025-05-24 18:57:52', 2.00);
INSERT INTO public.product_ingredients VALUES (363, 'g', 66, 202, '2025-05-24 18:57:52', '2025-05-24 18:57:52', 1.00);
INSERT INTO public.product_ingredients VALUES (364, 'mg', 66, 205, '2025-05-24 18:57:52', '2025-05-24 18:57:52', 350.00);
INSERT INTO public.product_ingredients VALUES (365, 'g', 67, 198, '2025-05-24 19:42:10', '2025-05-24 19:42:10', 3.00);
INSERT INTO public.product_ingredients VALUES (366, 'g', 67, 254, '2025-05-24 19:42:10', '2025-05-24 19:42:10', 2.00);
INSERT INTO public.product_ingredients VALUES (367, 'g', 67, 199, '2025-05-24 19:42:10', '2025-05-24 19:42:10', 1.60);
INSERT INTO public.product_ingredients VALUES (368, 'g', 67, 200, '2025-05-24 19:42:11', '2025-05-24 19:42:11', 1.25);
INSERT INTO public.product_ingredients VALUES (369, 'g', 67, 301, '2025-05-24 19:42:11', '2025-05-24 19:42:11', 1.00);
INSERT INTO public.product_ingredients VALUES (370, 'mg', 67, 202, '2025-05-24 19:42:11', '2025-05-24 19:42:11', 750.00);
INSERT INTO public.product_ingredients VALUES (371, 'mg', 67, 251, '2025-05-24 19:42:11', '2025-05-24 19:42:11', 250.00);
INSERT INTO public.product_ingredients VALUES (372, 'mg', 67, 274, '2025-05-24 19:42:11', '2025-05-24 19:42:11', 150.00);
INSERT INTO public.product_ingredients VALUES (373, 'mg', 67, 253, '2025-05-24 19:42:11', '2025-05-24 19:42:11', 50.00);
INSERT INTO public.product_ingredients VALUES (374, 'g', 68, 198, '2025-05-24 19:44:49', '2025-05-24 19:44:49', 3.00);
INSERT INTO public.product_ingredients VALUES (375, 'g', 68, 254, '2025-05-24 19:44:49', '2025-05-24 19:44:49', 2.00);
INSERT INTO public.product_ingredients VALUES (376, 'g', 68, 199, '2025-05-24 19:44:49', '2025-05-24 19:44:49', 1.60);
INSERT INTO public.product_ingredients VALUES (377, 'g', 68, 200, '2025-05-24 19:44:49', '2025-05-24 19:44:49', 1.25);
INSERT INTO public.product_ingredients VALUES (378, 'g', 68, 301, '2025-05-24 19:44:49', '2025-05-24 19:44:49', 1.00);
INSERT INTO public.product_ingredients VALUES (379, 'mg', 68, 202, '2025-05-24 19:44:49', '2025-05-24 19:44:49', 750.00);
INSERT INTO public.product_ingredients VALUES (380, 'mg', 68, 251, '2025-05-24 19:44:49', '2025-05-24 19:44:49', 250.00);
INSERT INTO public.product_ingredients VALUES (381, 'mg', 68, 255, '2025-05-24 19:44:49', '2025-05-24 19:44:49', 200.00);
INSERT INTO public.product_ingredients VALUES (382, 'mg', 68, 253, '2025-05-24 19:44:49', '2025-05-24 19:44:49', 50.00);
INSERT INTO public.product_ingredients VALUES (383, 'g', 69, 198, '2025-05-24 19:47:45', '2025-05-24 19:47:45', 6.00);
INSERT INTO public.product_ingredients VALUES (384, 'g', 69, 199, '2025-05-24 19:47:45', '2025-05-24 19:47:45', 3.00);
INSERT INTO public.product_ingredients VALUES (385, 'mg', 69, 211, '2025-05-24 19:47:45', '2025-05-24 19:47:45', 50.00);
INSERT INTO public.product_ingredients VALUES (386, 'mcg', 69, 210, '2025-05-24 19:47:45', '2025-05-24 19:47:45', 90.00);
INSERT INTO public.product_ingredients VALUES (387, 'mg', 69, 205, '2025-05-24 19:47:45', '2025-05-24 19:47:45', 350.00);
INSERT INTO public.product_ingredients VALUES (388, 'mg', 69, 206, '2025-05-24 19:47:46', '2025-05-24 19:47:46', 250.00);
INSERT INTO public.product_ingredients VALUES (389, 'mg', 69, 202, '2025-05-24 19:47:46', '2025-05-24 19:47:46', 200.00);
INSERT INTO public.product_ingredients VALUES (390, 'mg', 69, 204, '2025-05-24 19:47:46', '2025-05-24 19:47:46', 200.00);
INSERT INTO public.product_ingredients VALUES (391, 'mg', 69, 301, '2025-05-24 19:47:46', '2025-05-24 19:47:46', 200.00);
INSERT INTO public.product_ingredients VALUES (392, 'mg', 69, 256, '2025-05-24 19:47:46', '2025-05-24 19:47:46', 140.00);
INSERT INTO public.product_ingredients VALUES (393, 'mg', 69, 276, '2025-05-24 19:47:46', '2025-05-24 19:47:46', 100.00);
INSERT INTO public.product_ingredients VALUES (394, 'mg', 69, 257, '2025-05-24 19:47:46', '2025-05-24 19:47:46', 50.00);
INSERT INTO public.product_ingredients VALUES (395, 'g', 70, 198, '2025-05-24 19:54:55', '2025-05-24 19:54:55', 5.00);
INSERT INTO public.product_ingredients VALUES (396, 'g', 70, 199, '2025-05-24 19:54:55', '2025-05-24 19:54:55', 3.20);
INSERT INTO public.product_ingredients VALUES (397, 'mg', 70, 257, '2025-05-24 19:54:55', '2025-05-24 19:54:55', 50.00);
INSERT INTO public.product_ingredients VALUES (398, 'mg', 70, 211, '2025-05-24 19:54:55', '2025-05-24 19:54:55', 25.00);
INSERT INTO public.product_ingredients VALUES (399, 'g', 70, 200, '2025-05-24 19:54:55', '2025-05-24 19:54:55', 2.50);
INSERT INTO public.product_ingredients VALUES (400, 'g', 70, 301, '2025-05-24 19:54:55', '2025-05-24 19:54:55', 1.50);
INSERT INTO public.product_ingredients VALUES (401, 'g', 70, 202, '2025-05-24 19:54:55', '2025-05-24 19:54:55', 1.50);
INSERT INTO public.product_ingredients VALUES (402, 'mg', 70, 209, '2025-05-24 19:54:55', '2025-05-24 19:54:55', 400.00);
INSERT INTO public.product_ingredients VALUES (403, 'g', 70, 311, '2025-05-24 19:54:55', '2025-05-24 19:54:55', 2.10);
INSERT INTO public.product_ingredients VALUES (404, 'mg', 70, 208, '2025-05-24 19:54:55', '2025-05-24 19:54:55', 300.00);
INSERT INTO public.product_ingredients VALUES (405, 'mg', 70, 205, '2025-05-24 19:54:55', '2025-05-24 19:54:55', 175.00);
INSERT INTO public.product_ingredients VALUES (406, 'mg', 70, 216, '2025-05-24 19:54:55', '2025-05-24 19:54:55', 100.00);
INSERT INTO public.product_ingredients VALUES (407, 'g', 71, 198, '2025-05-24 20:03:15', '2025-05-24 20:03:15', 4.00);
INSERT INTO public.product_ingredients VALUES (408, 'g', 71, 199, '2025-05-24 20:03:15', '2025-05-24 20:03:15', 1.60);
INSERT INTO public.product_ingredients VALUES (409, 'g', 71, 311, '2025-05-24 20:03:15', '2025-05-24 20:03:15', 1.50);
INSERT INTO public.product_ingredients VALUES (410, 'g', 71, 200, '2025-05-24 20:03:15', '2025-05-24 20:03:15', 1.25);
INSERT INTO public.product_ingredients VALUES (411, 'g', 71, 202, '2025-05-24 20:03:15', '2025-05-24 20:03:15', 1.00);
INSERT INTO public.product_ingredients VALUES (412, 'mg', 71, 208, '2025-05-24 20:03:15', '2025-05-24 20:03:15', 150.00);
INSERT INTO public.product_ingredients VALUES (413, 'mg', 71, 205, '2025-05-24 20:03:15', '2025-05-24 20:03:15', 137.50);
INSERT INTO public.product_ingredients VALUES (414, 'mg', 71, 251, '2025-05-24 20:03:15', '2025-05-24 20:03:15', 125.00);
INSERT INTO public.product_ingredients VALUES (415, 'mg', 71, 216, '2025-05-24 20:03:15', '2025-05-24 20:03:15', 50.00);
INSERT INTO public.product_ingredients VALUES (416, 'mg', 71, 211, '2025-05-24 20:03:15', '2025-05-24 20:03:15', 25.00);
INSERT INTO public.product_ingredients VALUES (417, 'g', 72, 198, '2025-05-24 20:09:32', '2025-05-24 20:09:32', 5.00);
INSERT INTO public.product_ingredients VALUES (418, 'g', 72, 311, '2025-05-24 20:09:32', '2025-05-24 20:09:32', 2.10);
INSERT INTO public.product_ingredients VALUES (419, 'g', 72, 199, '2025-05-24 20:09:33', '2025-05-24 20:09:33', 1.60);
INSERT INTO public.product_ingredients VALUES (420, 'g', 72, 202, '2025-05-24 20:09:33', '2025-05-24 20:09:33', 1.50);
INSERT INTO public.product_ingredients VALUES (421, 'g', 72, 200, '2025-05-24 20:09:33', '2025-05-24 20:09:33', 1.25);
INSERT INTO public.product_ingredients VALUES (422, 'mg', 72, 209, '2025-05-24 20:09:33', '2025-05-24 20:09:33', 400.00);
INSERT INTO public.product_ingredients VALUES (423, 'mg', 72, 312, '2025-05-24 20:09:33', '2025-05-24 20:09:33', 200.00);
INSERT INTO public.product_ingredients VALUES (424, 'mg', 72, 231, '2025-05-24 20:09:33', '2025-05-24 20:09:33', 50.00);
INSERT INTO public.product_ingredients VALUES (425, 'mg', 72, 211, '2025-05-24 20:09:33', '2025-05-24 20:09:33', 25.00);
INSERT INTO public.product_ingredients VALUES (426, 'g', 73, 198, '2025-05-24 20:11:32', '2025-05-24 20:11:32', 5.00);
INSERT INTO public.product_ingredients VALUES (427, 'g', 73, 311, '2025-05-24 20:11:32', '2025-05-24 20:11:32', 1.50);
INSERT INTO public.product_ingredients VALUES (428, 'g', 73, 301, '2025-05-24 20:11:32', '2025-05-24 20:11:32', 1.00);
INSERT INTO public.product_ingredients VALUES (429, 'mg', 73, 245, '2025-05-24 20:11:32', '2025-05-24 20:11:32', 508.00);
INSERT INTO public.product_ingredients VALUES (430, 'mg', 73, 312, '2025-05-24 20:11:32', '2025-05-24 20:11:32', 200.00);
INSERT INTO public.product_ingredients VALUES (431, 'mg', 73, 211, '2025-05-24 20:11:32', '2025-05-24 20:11:32', 25.00);
INSERT INTO public.product_ingredients VALUES (432, 'g', 74, 198, '2025-05-24 20:14:33', '2025-05-24 20:14:33', 10.00);
INSERT INTO public.product_ingredients VALUES (433, 'g', 74, 199, '2025-05-24 20:14:33', '2025-05-24 20:14:33', 4.00);
INSERT INTO public.product_ingredients VALUES (434, 'mcg', 74, 210, '2025-05-24 20:14:33', '2025-05-24 20:14:33', 400.00);
INSERT INTO public.product_ingredients VALUES (435, 'g', 74, 202, '2025-05-24 20:14:33', '2025-05-24 20:14:33', 3.00);
INSERT INTO public.product_ingredients VALUES (436, 'g', 74, 301, '2025-05-24 20:14:33', '2025-05-24 20:14:33', 3.00);
INSERT INTO public.product_ingredients VALUES (437, 'g', 74, 200, '2025-05-24 20:14:33', '2025-05-24 20:14:33', 3.00);
INSERT INTO public.product_ingredients VALUES (438, 'g', 74, 311, '2025-05-24 20:14:33', '2025-05-24 20:14:33', 2.00);
INSERT INTO public.product_ingredients VALUES (439, 'mg', 74, 209, '2025-05-24 20:14:34', '2025-05-24 20:14:34', 600.00);
INSERT INTO public.product_ingredients VALUES (440, 'mg', 74, 208, '2025-05-24 20:14:34', '2025-05-24 20:14:34', 400.00);
INSERT INTO public.product_ingredients VALUES (441, 'mg', 74, 205, '2025-05-24 20:14:34', '2025-05-24 20:14:34', 400.00);
INSERT INTO public.product_ingredients VALUES (442, 'mg', 74, 211, '2025-05-24 20:14:34', '2025-05-24 20:14:34', 50.00);
INSERT INTO public.product_ingredients VALUES (443, 'g', 75, 198, '2025-05-24 20:16:42', '2025-05-24 20:16:42', 6.00);
INSERT INTO public.product_ingredients VALUES (444, 'g', 75, 199, '2025-05-24 20:16:42', '2025-05-24 20:16:42', 3.20);
INSERT INTO public.product_ingredients VALUES (445, 'g', 75, 200, '2025-05-24 20:16:42', '2025-05-24 20:16:42', 2.50);
INSERT INTO public.product_ingredients VALUES (446, 'g', 75, 202, '2025-05-24 20:16:42', '2025-05-24 20:16:42', 2.00);
INSERT INTO public.product_ingredients VALUES (447, 'mg', 75, 205, '2025-05-24 20:16:42', '2025-05-24 20:16:42', 300.00);
INSERT INTO public.product_ingredients VALUES (448, 'mg', 75, 211, '2025-05-24 20:16:42', '2025-05-24 20:16:42', 50.00);
INSERT INTO public.product_ingredients VALUES (449, 'mcg', 75, 210, '2025-05-24 20:16:42', '2025-05-24 20:16:42', 400.00);


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.schema_migrations VALUES (20250430005447, '2025-04-30 00:55:16');
INSERT INTO public.schema_migrations VALUES (20250430224017, '2025-04-30 22:48:32');
INSERT INTO public.schema_migrations VALUES (20250430224035, '2025-04-30 22:48:33');
INSERT INTO public.schema_migrations VALUES (20250430224049, '2025-04-30 22:48:34');
INSERT INTO public.schema_migrations VALUES (20250430224104, '2025-04-30 22:48:35');
INSERT INTO public.schema_migrations VALUES (20250503202618, '2025-05-03 20:28:51');
INSERT INTO public.schema_migrations VALUES (20250503203004, '2025-05-03 20:30:26');
INSERT INTO public.schema_migrations VALUES (20250508222432, '2025-05-08 22:25:14');
INSERT INTO public.schema_migrations VALUES (20250511014526, '2025-05-11 01:45:53');
INSERT INTO public.schema_migrations VALUES (20250511022453, '2025-05-11 02:25:06');
INSERT INTO public.schema_migrations VALUES (20250511211558, '2025-05-11 21:16:19');
INSERT INTO public.schema_migrations VALUES (20250511211852, '2025-05-11 21:19:06');


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users VALUES (1, 'alex@alexezell.com', NULL, '2025-04-30 00:57:11', '2025-04-30 00:56:46', '2025-04-30 00:57:11');


--
-- Data for Name: users_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users_tokens VALUES (2, 1, '\x1da8fd32ce1168f3a94610b33fe5f14589593baf3991188c446e369d4c8ca869', 'session', NULL, '2025-04-30 00:57:11', '2025-04-30 00:57:11');


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

INSERT INTO realtime.schema_migrations VALUES (20211116024918, '2025-04-26 22:32:56');
INSERT INTO realtime.schema_migrations VALUES (20211116045059, '2025-04-26 22:32:59');
INSERT INTO realtime.schema_migrations VALUES (20211116050929, '2025-04-26 22:33:01');
INSERT INTO realtime.schema_migrations VALUES (20211116051442, '2025-04-26 22:33:03');
INSERT INTO realtime.schema_migrations VALUES (20211116212300, '2025-04-26 22:33:06');
INSERT INTO realtime.schema_migrations VALUES (20211116213355, '2025-04-26 22:33:08');
INSERT INTO realtime.schema_migrations VALUES (20211116213934, '2025-04-26 22:33:10');
INSERT INTO realtime.schema_migrations VALUES (20211116214523, '2025-04-26 22:33:13');
INSERT INTO realtime.schema_migrations VALUES (20211122062447, '2025-04-26 22:33:15');
INSERT INTO realtime.schema_migrations VALUES (20211124070109, '2025-04-26 22:33:17');
INSERT INTO realtime.schema_migrations VALUES (20211202204204, '2025-04-26 22:33:19');
INSERT INTO realtime.schema_migrations VALUES (20211202204605, '2025-04-26 22:33:21');
INSERT INTO realtime.schema_migrations VALUES (20211210212804, '2025-04-26 22:33:27');
INSERT INTO realtime.schema_migrations VALUES (20211228014915, '2025-04-26 22:33:29');
INSERT INTO realtime.schema_migrations VALUES (20220107221237, '2025-04-26 22:33:31');
INSERT INTO realtime.schema_migrations VALUES (20220228202821, '2025-04-26 22:33:33');
INSERT INTO realtime.schema_migrations VALUES (20220312004840, '2025-04-26 22:33:35');
INSERT INTO realtime.schema_migrations VALUES (20220603231003, '2025-04-26 22:33:38');
INSERT INTO realtime.schema_migrations VALUES (20220603232444, '2025-04-26 22:33:40');
INSERT INTO realtime.schema_migrations VALUES (20220615214548, '2025-04-26 22:33:43');
INSERT INTO realtime.schema_migrations VALUES (20220712093339, '2025-04-26 22:33:45');
INSERT INTO realtime.schema_migrations VALUES (20220908172859, '2025-04-26 22:33:47');
INSERT INTO realtime.schema_migrations VALUES (20220916233421, '2025-04-26 22:33:49');
INSERT INTO realtime.schema_migrations VALUES (20230119133233, '2025-04-26 22:33:51');
INSERT INTO realtime.schema_migrations VALUES (20230128025114, '2025-04-26 22:33:54');
INSERT INTO realtime.schema_migrations VALUES (20230128025212, '2025-04-26 22:33:56');
INSERT INTO realtime.schema_migrations VALUES (20230227211149, '2025-04-26 22:33:58');
INSERT INTO realtime.schema_migrations VALUES (20230228184745, '2025-04-26 22:34:00');
INSERT INTO realtime.schema_migrations VALUES (20230308225145, '2025-04-26 22:34:02');
INSERT INTO realtime.schema_migrations VALUES (20230328144023, '2025-04-26 22:34:04');
INSERT INTO realtime.schema_migrations VALUES (20231018144023, '2025-04-26 22:34:06');
INSERT INTO realtime.schema_migrations VALUES (20231204144023, '2025-04-26 22:34:09');
INSERT INTO realtime.schema_migrations VALUES (20231204144024, '2025-04-26 22:34:11');
INSERT INTO realtime.schema_migrations VALUES (20231204144025, '2025-04-26 22:34:14');
INSERT INTO realtime.schema_migrations VALUES (20240108234812, '2025-04-26 22:34:16');
INSERT INTO realtime.schema_migrations VALUES (20240109165339, '2025-04-26 22:34:18');
INSERT INTO realtime.schema_migrations VALUES (20240227174441, '2025-04-26 22:34:21');
INSERT INTO realtime.schema_migrations VALUES (20240311171622, '2025-04-26 22:34:24');
INSERT INTO realtime.schema_migrations VALUES (20240321100241, '2025-04-26 22:34:28');
INSERT INTO realtime.schema_migrations VALUES (20240401105812, '2025-04-26 22:34:34');
INSERT INTO realtime.schema_migrations VALUES (20240418121054, '2025-04-26 22:34:37');
INSERT INTO realtime.schema_migrations VALUES (20240523004032, '2025-04-26 22:34:44');
INSERT INTO realtime.schema_migrations VALUES (20240618124746, '2025-04-26 22:34:46');
INSERT INTO realtime.schema_migrations VALUES (20240801235015, '2025-04-26 22:34:48');
INSERT INTO realtime.schema_migrations VALUES (20240805133720, '2025-04-26 22:34:50');
INSERT INTO realtime.schema_migrations VALUES (20240827160934, '2025-04-26 22:34:52');
INSERT INTO realtime.schema_migrations VALUES (20240919163303, '2025-04-26 22:34:55');
INSERT INTO realtime.schema_migrations VALUES (20240919163305, '2025-04-26 22:34:57');
INSERT INTO realtime.schema_migrations VALUES (20241019105805, '2025-04-26 22:34:59');
INSERT INTO realtime.schema_migrations VALUES (20241030150047, '2025-04-26 22:35:07');
INSERT INTO realtime.schema_migrations VALUES (20241108114728, '2025-04-26 22:35:10');
INSERT INTO realtime.schema_migrations VALUES (20241121104152, '2025-04-26 22:35:12');
INSERT INTO realtime.schema_migrations VALUES (20241130184212, '2025-04-26 22:35:14');
INSERT INTO realtime.schema_migrations VALUES (20241220035512, '2025-04-26 22:35:16');
INSERT INTO realtime.schema_migrations VALUES (20241220123912, '2025-04-26 22:35:18');
INSERT INTO realtime.schema_migrations VALUES (20241224161212, '2025-04-26 22:35:20');
INSERT INTO realtime.schema_migrations VALUES (20250107150512, '2025-04-26 22:35:22');
INSERT INTO realtime.schema_migrations VALUES (20250110162412, '2025-04-26 22:35:24');
INSERT INTO realtime.schema_migrations VALUES (20250123174212, '2025-04-26 22:35:26');
INSERT INTO realtime.schema_migrations VALUES (20250128220012, '2025-04-26 22:35:28');
INSERT INTO realtime.schema_migrations VALUES (20250506224012, '2025-05-26 19:48:14');


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--



--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

INSERT INTO storage.migrations VALUES (0, 'create-migrations-table', 'e18db593bcde2aca2a408c4d1100f6abba2195df', '2025-04-26 22:32:53.837743');
INSERT INTO storage.migrations VALUES (1, 'initialmigration', '6ab16121fbaa08bbd11b712d05f358f9b555d777', '2025-04-26 22:32:53.843244');
INSERT INTO storage.migrations VALUES (2, 'storage-schema', '5c7968fd083fcea04050c1b7f6253c9771b99011', '2025-04-26 22:32:53.846946');
INSERT INTO storage.migrations VALUES (3, 'pathtoken-column', '2cb1b0004b817b29d5b0a971af16bafeede4b70d', '2025-04-26 22:32:53.865694');
INSERT INTO storage.migrations VALUES (4, 'add-migrations-rls', '427c5b63fe1c5937495d9c635c263ee7a5905058', '2025-04-26 22:32:53.891638');
INSERT INTO storage.migrations VALUES (5, 'add-size-functions', '79e081a1455b63666c1294a440f8ad4b1e6a7f84', '2025-04-26 22:32:53.895624');
INSERT INTO storage.migrations VALUES (6, 'change-column-name-in-get-size', 'f93f62afdf6613ee5e7e815b30d02dc990201044', '2025-04-26 22:32:53.900068');
INSERT INTO storage.migrations VALUES (7, 'add-rls-to-buckets', 'e7e7f86adbc51049f341dfe8d30256c1abca17aa', '2025-04-26 22:32:53.904479');
INSERT INTO storage.migrations VALUES (8, 'add-public-to-buckets', 'fd670db39ed65f9d08b01db09d6202503ca2bab3', '2025-04-26 22:32:53.910253');
INSERT INTO storage.migrations VALUES (9, 'fix-search-function', '3a0af29f42e35a4d101c259ed955b67e1bee6825', '2025-04-26 22:32:53.91506');
INSERT INTO storage.migrations VALUES (10, 'search-files-search-function', '68dc14822daad0ffac3746a502234f486182ef6e', '2025-04-26 22:32:53.923671');
INSERT INTO storage.migrations VALUES (11, 'add-trigger-to-auto-update-updated_at-column', '7425bdb14366d1739fa8a18c83100636d74dcaa2', '2025-04-26 22:32:53.928208');
INSERT INTO storage.migrations VALUES (12, 'add-automatic-avif-detection-flag', '8e92e1266eb29518b6a4c5313ab8f29dd0d08df9', '2025-04-26 22:32:53.936077');
INSERT INTO storage.migrations VALUES (13, 'add-bucket-custom-limits', 'cce962054138135cd9a8c4bcd531598684b25e7d', '2025-04-26 22:32:53.940395');
INSERT INTO storage.migrations VALUES (14, 'use-bytes-for-max-size', '941c41b346f9802b411f06f30e972ad4744dad27', '2025-04-26 22:32:53.945442');
INSERT INTO storage.migrations VALUES (15, 'add-can-insert-object-function', '934146bc38ead475f4ef4b555c524ee5d66799e5', '2025-04-26 22:32:53.971967');
INSERT INTO storage.migrations VALUES (16, 'add-version', '76debf38d3fd07dcfc747ca49096457d95b1221b', '2025-04-26 22:32:53.976334');
INSERT INTO storage.migrations VALUES (17, 'drop-owner-foreign-key', 'f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101', '2025-04-26 22:32:53.980726');
INSERT INTO storage.migrations VALUES (18, 'add_owner_id_column_deprecate_owner', 'e7a511b379110b08e2f214be852c35414749fe66', '2025-04-26 22:32:53.985761');
INSERT INTO storage.migrations VALUES (19, 'alter-default-value-objects-id', '02e5e22a78626187e00d173dc45f58fa66a4f043', '2025-04-26 22:32:53.993431');
INSERT INTO storage.migrations VALUES (20, 'list-objects-with-delimiter', 'cd694ae708e51ba82bf012bba00caf4f3b6393b7', '2025-04-26 22:32:53.998016');
INSERT INTO storage.migrations VALUES (21, 's3-multipart-uploads', '8c804d4a566c40cd1e4cc5b3725a664a9303657f', '2025-04-26 22:32:54.008513');
INSERT INTO storage.migrations VALUES (22, 's3-multipart-uploads-big-ints', '9737dc258d2397953c9953d9b86920b8be0cdb73', '2025-04-26 22:32:54.038287');
INSERT INTO storage.migrations VALUES (23, 'optimize-search-function', '9d7e604cddc4b56a5422dc68c9313f4a1b6f132c', '2025-04-26 22:32:54.064803');
INSERT INTO storage.migrations VALUES (24, 'operation-function', '8312e37c2bf9e76bbe841aa5fda889206d2bf8aa', '2025-04-26 22:32:54.069235');
INSERT INTO storage.migrations VALUES (25, 'custom-metadata', 'd974c6057c3db1c1f847afa0e291e6165693b990', '2025-04-26 22:32:54.073312');


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: supabase_migrations; Owner: postgres
--



--
-- Data for Name: seed_files; Type: TABLE DATA; Schema: supabase_migrations; Owner: postgres
--



--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--



--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 1, false);


--
-- Name: brands_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.brands_id_seq', 137, true);


--
-- Name: ingredients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ingredients_id_seq', 312, true);


--
-- Name: product_ingredients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.product_ingredients_id_seq', 449, true);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_id_seq', 75, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Name: users_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_tokens_id_seq', 3, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: supabase_admin
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- PostgreSQL database dump complete
--


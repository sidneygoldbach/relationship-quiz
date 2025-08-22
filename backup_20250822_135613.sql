--
-- PostgreSQL database dump
--

-- Dumped from database version 14.18 (Homebrew)
-- Dumped by pg_dump version 14.18 (Homebrew)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: advice; Type: TABLE; Schema: public; Owner: quiz_user
--

CREATE TABLE public.advice (
    id integer NOT NULL,
    personality_type_id integer,
    advice_type character varying(50) NOT NULL,
    advice_text text NOT NULL,
    advice_order integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    country character varying(5) DEFAULT 'en_US'::character varying
);


ALTER TABLE public.advice OWNER TO quiz_user;

--
-- Name: advice_id_seq; Type: SEQUENCE; Schema: public; Owner: quiz_user
--

CREATE SEQUENCE public.advice_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.advice_id_seq OWNER TO quiz_user;

--
-- Name: advice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: quiz_user
--

ALTER SEQUENCE public.advice_id_seq OWNED BY public.advice.id;


--
-- Name: answer_options; Type: TABLE; Schema: public; Owner: quiz_user
--

CREATE TABLE public.answer_options (
    id integer NOT NULL,
    question_id integer,
    option_text text NOT NULL,
    option_order integer DEFAULT 0,
    personality_weight jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    country character varying(5) DEFAULT 'en_US'::character varying
);


ALTER TABLE public.answer_options OWNER TO quiz_user;

--
-- Name: answer_options_id_seq; Type: SEQUENCE; Schema: public; Owner: quiz_user
--

CREATE SEQUENCE public.answer_options_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.answer_options_id_seq OWNER TO quiz_user;

--
-- Name: answer_options_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: quiz_user
--

ALTER SEQUENCE public.answer_options_id_seq OWNED BY public.answer_options.id;


--
-- Name: business_rules; Type: TABLE; Schema: public; Owner: quiz_user
--

CREATE TABLE public.business_rules (
    id integer NOT NULL,
    quiz_id integer,
    rule_name character varying(255) NOT NULL,
    rule_category character varying(50) NOT NULL,
    rule_config jsonb NOT NULL,
    priority integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.business_rules OWNER TO quiz_user;

--
-- Name: business_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: quiz_user
--

CREATE SEQUENCE public.business_rules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.business_rules_id_seq OWNER TO quiz_user;

--
-- Name: business_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: quiz_user
--

ALTER SEQUENCE public.business_rules_id_seq OWNED BY public.business_rules.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: quiz_user
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.categories OWNER TO quiz_user;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: quiz_user
--

CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categories_id_seq OWNER TO quiz_user;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: quiz_user
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: currencies; Type: TABLE; Schema: public; Owner: sidneygoldbach
--

CREATE TABLE public.currencies (
    id integer NOT NULL,
    locale character varying(10) NOT NULL,
    currency character varying(3) NOT NULL,
    symbol character varying(10) NOT NULL,
    conversion2us numeric(10,4) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    country character varying(100)
);


ALTER TABLE public.currencies OWNER TO sidneygoldbach;

--
-- Name: currencies_id_seq; Type: SEQUENCE; Schema: public; Owner: sidneygoldbach
--

CREATE SEQUENCE public.currencies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.currencies_id_seq OWNER TO sidneygoldbach;

--
-- Name: currencies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sidneygoldbach
--

ALTER SEQUENCE public.currencies_id_seq OWNED BY public.currencies.id;


--
-- Name: layout_locale; Type: TABLE; Schema: public; Owner: quiz_user
--

CREATE TABLE public.layout_locale (
    id integer NOT NULL,
    country character varying(5) NOT NULL,
    component_name character varying(100) NOT NULL,
    text_content text NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.layout_locale OWNER TO quiz_user;

--
-- Name: layout_locale_id_seq; Type: SEQUENCE; Schema: public; Owner: quiz_user
--

CREATE SEQUENCE public.layout_locale_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.layout_locale_id_seq OWNER TO quiz_user;

--
-- Name: layout_locale_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: quiz_user
--

ALTER SEQUENCE public.layout_locale_id_seq OWNED BY public.layout_locale.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: quiz_user
--

CREATE TABLE public.payments (
    id integer NOT NULL,
    session_id character varying(255),
    stripe_payment_id character varying(255),
    amount integer NOT NULL,
    currency character varying(3) DEFAULT 'usd'::character varying,
    status character varying(50) DEFAULT 'pending'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.payments OWNER TO quiz_user;

--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: quiz_user
--

CREATE SEQUENCE public.payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payments_id_seq OWNER TO quiz_user;

--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: quiz_user
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: personality_advice; Type: TABLE; Schema: public; Owner: quiz_user
--

CREATE TABLE public.personality_advice (
    id integer NOT NULL,
    personality_type_id integer,
    advice_type character varying(50) NOT NULL,
    advice_text text NOT NULL,
    advice_order integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.personality_advice OWNER TO quiz_user;

--
-- Name: personality_advice_id_seq; Type: SEQUENCE; Schema: public; Owner: quiz_user
--

CREATE SEQUENCE public.personality_advice_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.personality_advice_id_seq OWNER TO quiz_user;

--
-- Name: personality_advice_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: quiz_user
--

ALTER SEQUENCE public.personality_advice_id_seq OWNED BY public.personality_advice.id;


--
-- Name: personality_types; Type: TABLE; Schema: public; Owner: quiz_user
--

CREATE TABLE public.personality_types (
    id integer NOT NULL,
    quiz_id integer,
    type_name character varying(255) NOT NULL,
    type_key character varying(100) NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    country character varying(5) DEFAULT 'en_US'::character varying
);


ALTER TABLE public.personality_types OWNER TO quiz_user;

--
-- Name: personality_types_id_seq; Type: SEQUENCE; Schema: public; Owner: quiz_user
--

CREATE SEQUENCE public.personality_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.personality_types_id_seq OWNER TO quiz_user;

--
-- Name: personality_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: quiz_user
--

ALTER SEQUENCE public.personality_types_id_seq OWNED BY public.personality_types.id;


--
-- Name: question_weights; Type: TABLE; Schema: public; Owner: quiz_user
--

CREATE TABLE public.question_weights (
    id integer NOT NULL,
    quiz_id integer,
    question_id integer,
    weight_multiplier numeric(5,2) DEFAULT 1.0,
    importance_level character varying(20) DEFAULT 'normal'::character varying,
    is_required boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.question_weights OWNER TO quiz_user;

--
-- Name: question_weights_id_seq; Type: SEQUENCE; Schema: public; Owner: quiz_user
--

CREATE SEQUENCE public.question_weights_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.question_weights_id_seq OWNER TO quiz_user;

--
-- Name: question_weights_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: quiz_user
--

ALTER SEQUENCE public.question_weights_id_seq OWNED BY public.question_weights.id;


--
-- Name: questions; Type: TABLE; Schema: public; Owner: quiz_user
--

CREATE TABLE public.questions (
    id integer NOT NULL,
    quiz_id integer,
    category_id integer,
    question_text text NOT NULL,
    question_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    country character varying(5) DEFAULT 'en_US'::character varying
);


ALTER TABLE public.questions OWNER TO quiz_user;

--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: quiz_user
--

CREATE SEQUENCE public.questions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.questions_id_seq OWNER TO quiz_user;

--
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: quiz_user
--

ALTER SEQUENCE public.questions_id_seq OWNED BY public.questions.id;


--
-- Name: quiz_images; Type: TABLE; Schema: public; Owner: sidneygoldbach
--

CREATE TABLE public.quiz_images (
    id integer NOT NULL,
    quiz_id integer,
    image_url character varying(500) NOT NULL,
    image_type character varying(50) NOT NULL,
    title character varying(255),
    description text,
    display_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.quiz_images OWNER TO sidneygoldbach;

--
-- Name: quiz_images_id_seq; Type: SEQUENCE; Schema: public; Owner: sidneygoldbach
--

CREATE SEQUENCE public.quiz_images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quiz_images_id_seq OWNER TO sidneygoldbach;

--
-- Name: quiz_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sidneygoldbach
--

ALTER SEQUENCE public.quiz_images_id_seq OWNED BY public.quiz_images.id;


--
-- Name: quiz_sessions; Type: TABLE; Schema: public; Owner: quiz_user
--

CREATE TABLE public.quiz_sessions (
    id integer NOT NULL,
    session_id character varying(255) NOT NULL,
    email character varying(255),
    payment_status character varying(50) DEFAULT 'pending'::character varying,
    quiz_answers jsonb,
    result_type character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    quiz_id integer,
    personality_type_id integer,
    detailed_scores jsonb
);


ALTER TABLE public.quiz_sessions OWNER TO quiz_user;

--
-- Name: quiz_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: quiz_user
--

CREATE SEQUENCE public.quiz_sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quiz_sessions_id_seq OWNER TO quiz_user;

--
-- Name: quiz_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: quiz_user
--

ALTER SEQUENCE public.quiz_sessions_id_seq OWNED BY public.quiz_sessions.id;


--
-- Name: quizzes; Type: TABLE; Schema: public; Owner: quiz_user
--

CREATE TABLE public.quizzes (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    price integer DEFAULT 100,
    currency character varying(3) DEFAULT 'usd'::character varying,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    result_title character varying(255) DEFAULT 'Personality Type'::character varying,
    coach_type character varying(100) DEFAULT 'relationship'::character varying,
    coach_category character varying(100) DEFAULT 'personal'::character varying,
    icon_url character varying(500),
    coach_title character varying(255),
    coach_description text
);


ALTER TABLE public.quizzes OWNER TO quiz_user;

--
-- Name: quizzes_id_seq; Type: SEQUENCE; Schema: public; Owner: quiz_user
--

CREATE SEQUENCE public.quizzes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quizzes_id_seq OWNER TO quiz_user;

--
-- Name: quizzes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: quiz_user
--

ALTER SEQUENCE public.quizzes_id_seq OWNED BY public.quizzes.id;


--
-- Name: scoring_rules; Type: TABLE; Schema: public; Owner: quiz_user
--

CREATE TABLE public.scoring_rules (
    id integer NOT NULL,
    quiz_id integer,
    personality_type_id integer,
    rule_conditions jsonb NOT NULL,
    weight integer DEFAULT 1,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.scoring_rules OWNER TO quiz_user;

--
-- Name: scoring_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: quiz_user
--

CREATE SEQUENCE public.scoring_rules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.scoring_rules_id_seq OWNER TO quiz_user;

--
-- Name: scoring_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: quiz_user
--

ALTER SEQUENCE public.scoring_rules_id_seq OWNED BY public.scoring_rules.id;


--
-- Name: system_config; Type: TABLE; Schema: public; Owner: quiz_user
--

CREATE TABLE public.system_config (
    id integer NOT NULL,
    config_key character varying(255) NOT NULL,
    config_value jsonb NOT NULL,
    config_type character varying(50) NOT NULL,
    description text,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.system_config OWNER TO quiz_user;

--
-- Name: system_config_id_seq; Type: SEQUENCE; Schema: public; Owner: quiz_user
--

CREATE SEQUENCE public.system_config_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.system_config_id_seq OWNER TO quiz_user;

--
-- Name: system_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: quiz_user
--

ALTER SEQUENCE public.system_config_id_seq OWNED BY public.system_config.id;


--
-- Name: validation_rules; Type: TABLE; Schema: public; Owner: quiz_user
--

CREATE TABLE public.validation_rules (
    id integer NOT NULL,
    quiz_id integer,
    rule_name character varying(255) NOT NULL,
    rule_type character varying(50) NOT NULL,
    rule_config jsonb NOT NULL,
    error_message text,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.validation_rules OWNER TO quiz_user;

--
-- Name: validation_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: quiz_user
--

CREATE SEQUENCE public.validation_rules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.validation_rules_id_seq OWNER TO quiz_user;

--
-- Name: validation_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: quiz_user
--

ALTER SEQUENCE public.validation_rules_id_seq OWNED BY public.validation_rules.id;


--
-- Name: advice id; Type: DEFAULT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.advice ALTER COLUMN id SET DEFAULT nextval('public.advice_id_seq'::regclass);


--
-- Name: answer_options id; Type: DEFAULT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.answer_options ALTER COLUMN id SET DEFAULT nextval('public.answer_options_id_seq'::regclass);


--
-- Name: business_rules id; Type: DEFAULT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.business_rules ALTER COLUMN id SET DEFAULT nextval('public.business_rules_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: currencies id; Type: DEFAULT; Schema: public; Owner: sidneygoldbach
--

ALTER TABLE ONLY public.currencies ALTER COLUMN id SET DEFAULT nextval('public.currencies_id_seq'::regclass);


--
-- Name: layout_locale id; Type: DEFAULT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.layout_locale ALTER COLUMN id SET DEFAULT nextval('public.layout_locale_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: personality_advice id; Type: DEFAULT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.personality_advice ALTER COLUMN id SET DEFAULT nextval('public.personality_advice_id_seq'::regclass);


--
-- Name: personality_types id; Type: DEFAULT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.personality_types ALTER COLUMN id SET DEFAULT nextval('public.personality_types_id_seq'::regclass);


--
-- Name: question_weights id; Type: DEFAULT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.question_weights ALTER COLUMN id SET DEFAULT nextval('public.question_weights_id_seq'::regclass);


--
-- Name: questions id; Type: DEFAULT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.questions ALTER COLUMN id SET DEFAULT nextval('public.questions_id_seq'::regclass);


--
-- Name: quiz_images id; Type: DEFAULT; Schema: public; Owner: sidneygoldbach
--

ALTER TABLE ONLY public.quiz_images ALTER COLUMN id SET DEFAULT nextval('public.quiz_images_id_seq'::regclass);


--
-- Name: quiz_sessions id; Type: DEFAULT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.quiz_sessions ALTER COLUMN id SET DEFAULT nextval('public.quiz_sessions_id_seq'::regclass);


--
-- Name: quizzes id; Type: DEFAULT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.quizzes ALTER COLUMN id SET DEFAULT nextval('public.quizzes_id_seq'::regclass);


--
-- Name: scoring_rules id; Type: DEFAULT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.scoring_rules ALTER COLUMN id SET DEFAULT nextval('public.scoring_rules_id_seq'::regclass);


--
-- Name: system_config id; Type: DEFAULT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.system_config ALTER COLUMN id SET DEFAULT nextval('public.system_config_id_seq'::regclass);


--
-- Name: validation_rules id; Type: DEFAULT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.validation_rules ALTER COLUMN id SET DEFAULT nextval('public.validation_rules_id_seq'::regclass);


--
-- Data for Name: advice; Type: TABLE DATA; Schema: public; Owner: quiz_user
--

COPY public.advice (id, personality_type_id, advice_type, advice_text, advice_order, created_at, country) FROM stdin;
1	6	personality	Practice active listening as much as you practice speaking.	0	2025-08-16 10:55:56.244421	en_US
2	6	personality	Remember that not everyone communicates as directly as you do.	1	2025-08-16 10:55:56.246418	en_US
3	6	personality	Balance honesty with tactfulness to avoid hurting others.	2	2025-08-16 10:55:56.246867	en_US
4	6	personality	Recognize when others need processing time before discussions.	3	2025-08-16 10:55:56.247269	en_US
5	6	personality	Your clarity is a strength that builds trust in relationships.	4	2025-08-16 10:55:56.247654	en_US
6	6	relationship	Create regular check-ins with partners to maintain open communication.	0	2025-08-16 10:55:56.248046	en_US
7	6	relationship	When conflicts arise, focus on understanding before being understood.	1	2025-08-16 10:55:56.24845	en_US
8	6	relationship	Validate others' feelings even when they differ from your perspective.	2	2025-08-16 10:55:56.248785	en_US
9	6	relationship	Use 'I' statements rather than 'you' statements during difficult conversations.	3	2025-08-16 10:55:56.249184	en_US
10	6	relationship	Appreciate different communication styles in your relationships.	4	2025-08-16 10:55:56.249531	en_US
11	7	personality	Set healthy boundaries to avoid emotional burnout.	0	2025-08-16 10:55:56.250322	en_US
12	7	personality	Make self-care a priority alongside caring for others.	1	2025-08-16 10:55:56.250658	en_US
13	7	personality	Recognize when you're taking on others' emotional burdens.	2	2025-08-16 10:55:56.251069	en_US
14	7	personality	Allow yourself to receive support, not just give it.	3	2025-08-16 10:55:56.251456	en_US
15	7	personality	Your empathy is a gift that strengthens connections.	4	2025-08-16 10:55:56.252015	en_US
16	7	relationship	Communicate your own needs clearly rather than just focusing on others.	0	2025-08-16 10:55:56.252406	en_US
17	7	relationship	Seek balance between giving and receiving in relationships.	1	2025-08-16 10:55:56.252795	en_US
18	7	relationship	Find partners who appreciate your nurturing nature without taking advantage.	2	2025-08-16 10:55:56.253279	en_US
19	7	relationship	Practice saying 'no' when necessary without feeling guilty.	3	2025-08-16 10:55:56.253775	en_US
20	7	relationship	Build a support network beyond your primary relationship.	4	2025-08-16 10:55:56.254233	en_US
21	8	personality	Recognize that some conflict is healthy and necessary.	0	2025-08-16 10:55:56.255273	en_US
22	8	personality	Stand firm on your core values even when it creates tension.	1	2025-08-16 10:55:56.255763	en_US
23	8	personality	Distinguish between healthy compromise and self-sacrifice.	2	2025-08-16 10:55:56.256242	en_US
24	8	personality	Practice expressing disagreement in constructive ways.	3	2025-08-16 10:55:56.257126	en_US
25	8	personality	Your flexibility is an asset in navigating relationship challenges.	4	2025-08-16 10:55:56.258193	en_US
26	8	relationship	Ensure your desire for harmony doesn't silence your authentic voice.	0	2025-08-16 10:55:56.259196	en_US
27	8	relationship	Set clear expectations about your needs and boundaries.	1	2025-08-16 10:55:56.259639	en_US
28	8	relationship	Look for partners who value compromise as much as you do.	2	2025-08-16 10:55:56.260203	en_US
29	8	relationship	Address small issues before they become major problems.	3	2025-08-16 10:55:56.260527	en_US
30	8	relationship	Celebrate the strength in your adaptability and peacemaking skills.	4	2025-08-16 10:55:56.260846	en_US
31	9	personality	Balance independence with vulnerability for deeper connections.	0	2025-08-16 10:55:56.261797	en_US
32	9	personality	Share your internal process with trusted others.	1	2025-08-16 10:55:56.262107	en_US
33	9	personality	Recognize when self-reliance becomes a barrier to intimacy.	2	2025-08-16 10:55:56.26242	en_US
34	9	personality	Practice asking for help when needed.	3	2025-08-16 10:55:56.26272	en_US
35	9	personality	Your self-sufficiency is a strength that brings stability to relationships.	4	2025-08-16 10:55:56.263061	en_US
36	9	relationship	Communicate your need for space proactively, not reactively.	0	2025-08-16 10:55:56.263383	en_US
37	9	relationship	Create rituals of connection to balance your independence.	1	2025-08-16 10:55:56.263691	en_US
38	9	relationship	Look for partners who respect your autonomy without feeling threatened.	2	2025-08-16 10:55:56.263981	en_US
39	9	relationship	Invest in interdependence alongside independence.	3	2025-08-16 10:55:56.26427	en_US
40	9	relationship	Share your growth journey with those closest to you.	4	2025-08-16 10:55:56.264549	en_US
41	10	personality	Ensure your loyalty to others doesn't override loyalty to yourself.	0	2025-08-16 10:55:56.265215	en_US
42	10	personality	Recognize that trust can be rebuilt after small breaches.	1	2025-08-16 10:55:56.265555	en_US
43	10	personality	Balance consistency with spontaneity and growth.	2	2025-08-16 10:55:56.265853	en_US
44	10	personality	Allow yourself and others room to evolve and change.	3	2025-08-16 10:55:56.266162	en_US
45	10	personality	Your steadfastness provides valuable security in relationships.	4	2025-08-16 10:55:56.266453	en_US
46	10	relationship	Communicate your expectations clearly to avoid disappointment.	0	2025-08-16 10:55:56.266801	en_US
47	10	relationship	Practice forgiveness for minor transgressions.	1	2025-08-16 10:55:56.267229	en_US
48	10	relationship	Look for partners who value commitment as much as you do.	2	2025-08-16 10:55:56.267584	en_US
49	10	relationship	Build trust through small, consistent actions over time.	3	2025-08-16 10:55:56.26792	en_US
50	10	relationship	Create space for both security and adventure in your relationships.	4	2025-08-16 10:55:56.268229	en_US
101	16	personality	Sua habilidade de comunicação é um dom - use-a para construir pontes, não muros.	1	2025-08-16 18:56:53.711429	en_US
102	16	personality	Pratique a escuta ativa tanto quanto você pratica falar.	2	2025-08-16 18:56:53.713834	en_US
103	16	personality	Lembre-se de que nem todos processam informações da mesma forma que você.	3	2025-08-16 18:56:53.714668	en_US
104	16	personality	Sua transparência pode ser refrescante, mas considere o timing e o contexto.	4	2025-08-16 18:56:53.715125	en_US
105	16	personality	Use sua voz para elevar outros, não apenas para se expressar.	5	2025-08-16 18:56:53.715574	en_US
106	16	relationship	Crie espaços seguros onde seu parceiro se sinta confortável para se abrir.	1	2025-08-16 18:56:53.716326	en_US
107	16	relationship	Equilibre compartilhar suas próprias experiências com fazer perguntas sobre as deles.	2	2025-08-16 18:56:53.716858	en_US
108	16	relationship	Reconheça quando seu parceiro precisa de tempo para processar antes de responder.	3	2025-08-16 18:56:53.717325	en_US
109	16	relationship	Sua abertura pode inspirar intimidade, mas respeite os limites dos outros.	4	2025-08-16 18:56:53.717652	en_US
110	16	relationship	Use conflitos como oportunidades para entender melhor, não para vencer argumentos.	5	2025-08-16 18:56:53.718197	en_US
111	18	personality	Sua busca por harmonia é admirável, mas não evite todos os conflitos necessários.	1	2025-08-16 18:56:53.71897	en_US
112	18	personality	Aprenda a expressar discordância de forma construtiva e respeitosa.	2	2025-08-16 18:56:53.71929	en_US
113	18	personality	Reconheça que algum conflito pode levar a soluções melhores e relacionamentos mais fortes.	3	2025-08-16 18:56:53.719631	en_US
114	18	personality	Sua habilidade de ver múltiplas perspectivas é um superpoder - use-a sabiamente.	4	2025-08-16 18:56:53.720916	en_US
115	18	personality	Equilibre manter a paz com defender seus próprios valores e necessidades.	5	2025-08-16 18:56:53.721688	en_US
116	18	relationship	Pratique expressar suas preferências, mesmo quando diferem das do seu parceiro.	1	2025-08-16 18:56:53.722158	en_US
117	18	relationship	Reconheça que relacionamentos saudáveis incluem desacordos ocasionais.	2	2025-08-16 18:56:53.72249	en_US
118	18	relationship	Procure parceiros que valorizem sua perspectiva, não apenas sua flexibilidade.	3	2025-08-16 18:56:53.722799	en_US
119	18	relationship	Use sua habilidade de mediação para resolver conflitos, não para evitá-los.	4	2025-08-16 18:56:53.723048	en_US
120	18	relationship	Crie espaços onde ambos possam expressar necessidades sem medo de conflito.	5	2025-08-16 18:56:53.723278	en_US
121	19	personality	Sua independência é uma força, mas lembre-se de que conexão não significa perda de liberdade.	1	2025-08-16 18:56:53.72411	en_US
122	19	personality	Pratique vulnerabilidade em pequenas doses para construir intimidade.	2	2025-08-16 18:56:53.72435	en_US
123	19	personality	Reconheça que pedir ajuda às vezes pode ser um sinal de força, não fraqueza.	3	2025-08-16 18:56:53.724615	en_US
124	19	personality	Equilibre seu tempo sozinho com momentos significativos de conexão.	4	2025-08-16 18:56:53.724847	en_US
125	19	personality	Sua autossuficiência é admirável, mas não deixe que se torne isolamento.	5	2025-08-16 18:56:53.725085	en_US
126	19	relationship	Comunique suas necessidades de espaço sem fazer seu parceiro se sentir rejeitado.	1	2025-08-16 18:56:53.725322	en_US
127	19	relationship	Pratique compartilhar seus pensamentos e sentimentos regularmente.	2	2025-08-16 18:56:53.725542	en_US
128	19	relationship	Procure parceiros que respeitem sua independência enquanto valorizam a conexão.	3	2025-08-16 18:56:53.725748	en_US
129	19	relationship	Invista em interdependência junto com independência.	4	2025-08-16 18:56:53.725954	en_US
130	19	relationship	Compartilhe sua jornada de crescimento com aqueles mais próximos de você.	5	2025-08-16 18:56:53.726179	en_US
131	20	personality	Certifique-se de que sua lealdade aos outros não se sobreponha à lealdade a si mesmo.	1	2025-08-16 18:56:53.72682	en_US
132	20	personality	Reconheça que a confiança pode ser reconstruída após pequenas quebras.	2	2025-08-16 18:56:53.72711	en_US
133	20	personality	Equilibre consistência com espontaneidade e crescimento.	3	2025-08-16 18:56:53.727345	en_US
134	20	personality	Permita a si mesmo e aos outros espaço para evoluir e mudar.	4	2025-08-16 18:56:53.727559	en_US
135	20	personality	Sua constância fornece segurança valiosa nos relacionamentos.	5	2025-08-16 18:56:53.727787	en_US
136	20	relationship	Comunique suas expectativas claramente para evitar decepções.	1	2025-08-16 18:56:53.728019	en_US
137	20	relationship	Pratique o perdão para transgressões menores.	2	2025-08-16 18:56:53.728235	en_US
138	20	relationship	Procure parceiros que valorizem o compromisso tanto quanto você.	3	2025-08-16 18:56:53.728446	en_US
139	20	relationship	Construa confiança através de pequenas ações consistentes ao longo do tempo.	4	2025-08-16 18:56:53.728651	en_US
140	20	relationship	Crie espaço tanto para segurança quanto para aventura em seus relacionamentos.	5	2025-08-16 18:56:53.72889	en_US
141	17	personality	Seu cuidado pelos outros é uma força, mas não se esqueça de cuidar de si mesmo.	1	2025-08-16 18:56:53.729395	en_US
142	17	personality	Estabeleça limites saudáveis para evitar o esgotamento emocional.	2	2025-08-16 18:56:53.729626	en_US
143	17	personality	Reconheça que ajudar demais pode às vezes impedir o crescimento dos outros.	3	2025-08-16 18:56:53.729865	en_US
144	17	personality	Sua empatia é valiosa - use-a sabiamente e proteja sua energia emocional.	4	2025-08-16 18:56:53.730101	en_US
145	17	personality	Lembre-se de que você também merece o mesmo cuidado que oferece aos outros.	5	2025-08-16 18:56:53.730351	en_US
146	17	relationship	Comunique suas próprias necessidades claramente, não apenas as dos outros.	1	2025-08-16 18:56:53.730622	en_US
147	17	relationship	Permita que seu parceiro também cuide de você às vezes.	2	2025-08-16 18:56:53.730875	en_US
148	17	relationship	Evite assumir responsabilidade pelos sentimentos e problemas do seu parceiro.	3	2025-08-16 18:56:53.731104	en_US
149	17	relationship	Valorize parceiros que reconhecem e apreciam sua natureza cuidadosa.	4	2025-08-16 18:56:53.731343	en_US
150	17	relationship	Crie relacionamentos baseados em reciprocidade, não apenas em dar.	5	2025-08-16 18:56:53.731603	en_US
151	21	personality	Tu habilidad de comunicación es un don: úsala para construir puentes, no muros.	1	2025-08-16 18:57:36.65635	en_US
152	21	personality	Practica la escucha activa tanto como practicas hablar.	2	2025-08-16 18:57:36.657539	en_US
153	21	personality	Recuerda que no todos procesan la información de la misma manera que tú.	3	2025-08-16 18:57:36.657996	en_US
154	21	personality	Tu transparencia puede ser refrescante, pero considera el momento y el contexto.	4	2025-08-16 18:57:36.658357	en_US
155	21	personality	Usa tu voz para elevar a otros, no solo para expresarte.	5	2025-08-16 18:57:36.658643	en_US
156	21	relationship	Crea espacios seguros donde tu pareja se sienta cómoda abriéndose.	1	2025-08-16 18:57:36.659136	en_US
157	21	relationship	Equilibra compartir tus propias experiencias con hacer preguntas sobre las suyas.	2	2025-08-16 18:57:36.659488	en_US
158	21	relationship	Reconoce cuando tu pareja necesita tiempo para procesar antes de responder.	3	2025-08-16 18:57:36.659786	en_US
159	21	relationship	Tu apertura puede inspirar intimidad, pero respeta los límites de otros.	4	2025-08-16 18:57:36.660024	en_US
160	21	relationship	Usa los conflictos como oportunidades para entender mejor, no para ganar argumentos.	5	2025-08-16 18:57:36.660257	en_US
161	23	personality	Tu búsqueda de armonía es admirable, pero no evites todos los conflictos necesarios.	1	2025-08-16 18:57:36.66074	en_US
162	23	personality	Aprende a expresar desacuerdo de forma constructiva y respetuosa.	2	2025-08-16 18:57:36.660984	en_US
163	23	personality	Reconoce que algún conflicto puede llevar a mejores soluciones y relaciones más fuertes.	3	2025-08-16 18:57:36.661228	en_US
164	23	personality	Tu habilidad para ver múltiples perspectivas es un superpoder: úsala sabiamente.	4	2025-08-16 18:57:36.661449	en_US
165	23	personality	Equilibra mantener la paz con defender tus propios valores y necesidades.	5	2025-08-16 18:57:36.661667	en_US
166	23	relationship	Practica expresar tus preferencias, incluso cuando difieran de las de tu pareja.	1	2025-08-16 18:57:36.661885	en_US
167	23	relationship	Reconoce que las relaciones saludables incluyen desacuerdos ocasionales.	2	2025-08-16 18:57:36.662103	en_US
168	23	relationship	Busca parejas que valoren tu perspectiva, no solo tu flexibilidad.	3	2025-08-16 18:57:36.662396	en_US
169	23	relationship	Usa tu habilidad de mediación para resolver conflictos, no para evitarlos.	4	2025-08-16 18:57:36.662642	en_US
170	23	relationship	Crea espacios donde ambos puedan expresar necesidades sin miedo al conflicto.	5	2025-08-16 18:57:36.662863	en_US
171	24	personality	Tu independencia es una fortaleza, pero recuerda que conexión no significa pérdida de libertad.	1	2025-08-16 18:57:36.663299	en_US
172	24	personality	Practica vulnerabilidad en pequeñas dosis para construir intimidad.	2	2025-08-16 18:57:36.663633	en_US
173	24	personality	Reconoce que pedir ayuda a veces puede ser señal de fortaleza, no debilidad.	3	2025-08-16 18:57:36.663888	en_US
174	24	personality	Equilibra tu tiempo solo con momentos significativos de conexión.	4	2025-08-16 18:57:36.664133	en_US
175	24	personality	Tu autosuficiencia es admirable, pero no dejes que se convierta en aislamiento.	5	2025-08-16 18:57:36.664416	en_US
176	24	relationship	Comunica tus necesidades de espacio sin hacer que tu pareja se sienta rechazada.	1	2025-08-16 18:57:36.664697	en_US
177	24	relationship	Practica compartir tus pensamientos y sentimientos regularmente.	2	2025-08-16 18:57:36.664941	en_US
178	24	relationship	Busca parejas que respeten tu independencia mientras valoran la conexión.	3	2025-08-16 18:57:36.665173	en_US
179	24	relationship	Invierte en interdependencia junto con independencia.	4	2025-08-16 18:57:36.665421	en_US
180	24	relationship	Comparte tu jornada de crecimiento con aquellos más cercanos a ti.	5	2025-08-16 18:57:36.665663	en_US
181	25	personality	Asegúrate de que tu lealtad a otros no anule la lealtad a ti mismo.	1	2025-08-16 18:57:36.666141	en_US
182	25	personality	Reconoce que la confianza puede reconstruirse después de pequeñas rupturas.	2	2025-08-16 18:57:36.66639	en_US
183	25	personality	Equilibra consistencia con espontaneidad y crecimiento.	3	2025-08-16 18:57:36.666646	en_US
184	25	personality	Permítete a ti mismo y a otros espacio para evolucionar y cambiar.	4	2025-08-16 18:57:36.666904	en_US
185	25	personality	Tu constancia proporciona seguridad valiosa en las relaciones.	5	2025-08-16 18:57:36.667138	en_US
186	25	relationship	Comunica tus expectativas claramente para evitar decepciones.	1	2025-08-16 18:57:36.667402	en_US
187	25	relationship	Practica el perdón para transgresiones menores.	2	2025-08-16 18:57:36.667644	en_US
188	25	relationship	Busca parejas que valoren el compromiso tanto como tú.	3	2025-08-16 18:57:36.667885	en_US
189	25	relationship	Construye confianza a través de pequeñas acciones consistentes a lo largo del tiempo.	4	2025-08-16 18:57:36.668122	en_US
190	25	relationship	Crea espacio tanto para seguridad como para aventura en tus relaciones.	5	2025-08-16 18:57:36.668354	en_US
191	22	personality	Tu cuidado por otros es una fortaleza, pero no olvides cuidarte a ti mismo.	1	2025-08-16 18:57:36.668919	en_US
192	22	personality	Establece límites saludables para evitar el agotamiento emocional.	2	2025-08-16 18:57:36.669417	en_US
193	22	personality	Reconoce que ayudar demasiado a veces puede impedir el crecimiento de otros.	3	2025-08-16 18:57:36.669838	en_US
194	22	personality	Tu empatía es valiosa: úsala sabiamente y protege tu energía emocional.	4	2025-08-16 18:57:36.670345	en_US
195	22	personality	Recuerda que tú también mereces el mismo cuidado que ofreces a otros.	5	2025-08-16 18:57:36.670852	en_US
196	22	relationship	Comunica tus propias necesidades claramente, no solo las de otros.	1	2025-08-16 18:57:36.67129	en_US
197	22	relationship	Permite que tu pareja también te cuide a veces.	2	2025-08-16 18:57:36.67163	en_US
198	22	relationship	Evita asumir responsabilidad por los sentimientos y problemas de tu pareja.	3	2025-08-16 18:57:36.671912	en_US
199	22	relationship	Valora parejas que reconocen y aprecian tu naturaleza cuidadosa.	4	2025-08-16 18:57:36.672171	en_US
200	22	relationship	Crea relaciones basadas en reciprocidad, no solo en dar.	5	2025-08-16 18:57:36.672431	en_US
201	26	general	🔧 Conselho geral para type_a - Quiz=2 - en_US	1	2025-08-21 14:16:55.407023	en_US
202	26	relationship	🔧 Conselho de relacionamento para type_a - Quiz=2 - en_US	2	2025-08-21 14:16:55.407023	en_US
203	27	general	🔧 Conselho geral para type_b - Quiz=2 - en_US	1	2025-08-21 14:16:55.407023	en_US
204	27	relationship	🔧 Conselho de relacionamento para type_b - Quiz=2 - en_US	2	2025-08-21 14:16:55.407023	en_US
205	28	general	🔧 Conselho geral para type_c - Quiz=2 - en_US	1	2025-08-21 14:16:55.407023	en_US
206	28	relationship	🔧 Conselho de relacionamento para type_c - Quiz=2 - en_US	2	2025-08-21 14:16:55.407023	en_US
207	29	general	🔧 Conselho geral para type_a - Quiz=2 - pt_BR	1	2025-08-21 14:16:55.407023	pt_BR
208	29	relationship	🔧 Conselho de relacionamento para type_a - Quiz=2 - pt_BR	2	2025-08-21 14:16:55.407023	pt_BR
209	30	general	🔧 Conselho geral para type_b - Quiz=2 - pt_BR	1	2025-08-21 14:16:55.407023	pt_BR
210	30	relationship	🔧 Conselho de relacionamento para type_b - Quiz=2 - pt_BR	2	2025-08-21 14:16:55.407023	pt_BR
211	31	general	🔧 Conselho geral para type_c - Quiz=2 - pt_BR	1	2025-08-21 14:16:55.407023	pt_BR
212	31	relationship	🔧 Conselho de relacionamento para type_c - Quiz=2 - pt_BR	2	2025-08-21 14:16:55.407023	pt_BR
213	32	general	🔧 Conselho geral para type_a - Quiz=2 - es_ES	1	2025-08-21 14:16:55.407023	es_ES
214	32	relationship	🔧 Conselho de relacionamento para type_a - Quiz=2 - es_ES	2	2025-08-21 14:16:55.407023	es_ES
215	33	general	🔧 Conselho geral para type_b - Quiz=2 - es_ES	1	2025-08-21 14:16:55.407023	es_ES
216	33	relationship	🔧 Conselho de relacionamento para type_b - Quiz=2 - es_ES	2	2025-08-21 14:16:55.407023	es_ES
217	34	general	🔧 Conselho geral para type_c - Quiz=2 - es_ES	1	2025-08-21 14:16:55.407023	es_ES
218	34	relationship	🔧 Conselho de relacionamento para type_c - Quiz=2 - es_ES	2	2025-08-21 14:16:55.407023	es_ES
219	35	general	🔧 Conselho geral para type_a - Quiz=2 - fr_FR	1	2025-08-21 14:16:55.407023	fr_FR
220	35	relationship	🔧 Conselho de relacionamento para type_a - Quiz=2 - fr_FR	2	2025-08-21 14:16:55.407023	fr_FR
221	36	general	🔧 Conselho geral para type_b - Quiz=2 - fr_FR	1	2025-08-21 14:16:55.407023	fr_FR
222	36	relationship	🔧 Conselho de relacionamento para type_b - Quiz=2 - fr_FR	2	2025-08-21 14:16:55.407023	fr_FR
223	37	general	🔧 Conselho geral para type_c - Quiz=2 - fr_FR	1	2025-08-21 14:16:55.407023	fr_FR
224	37	relationship	🔧 Conselho de relacionamento para type_c - Quiz=2 - fr_FR	2	2025-08-21 14:16:55.407023	fr_FR
225	38	general	🔧 Conselho geral para type_a - Quiz=3 - en_US	1	2025-08-21 14:16:55.407023	en_US
226	38	relationship	🔧 Conselho de relacionamento para type_a - Quiz=3 - en_US	2	2025-08-21 14:16:55.407023	en_US
227	39	general	🔧 Conselho geral para type_b - Quiz=3 - en_US	1	2025-08-21 14:16:55.407023	en_US
228	39	relationship	🔧 Conselho de relacionamento para type_b - Quiz=3 - en_US	2	2025-08-21 14:16:55.407023	en_US
229	40	general	🔧 Conselho geral para type_c - Quiz=3 - en_US	1	2025-08-21 14:16:55.407023	en_US
230	40	relationship	🔧 Conselho de relacionamento para type_c - Quiz=3 - en_US	2	2025-08-21 14:16:55.407023	en_US
231	41	general	🔧 Conselho geral para type_a - Quiz=3 - pt_BR	1	2025-08-21 14:16:55.407023	pt_BR
232	41	relationship	🔧 Conselho de relacionamento para type_a - Quiz=3 - pt_BR	2	2025-08-21 14:16:55.407023	pt_BR
233	42	general	🔧 Conselho geral para type_b - Quiz=3 - pt_BR	1	2025-08-21 14:16:55.407023	pt_BR
234	42	relationship	🔧 Conselho de relacionamento para type_b - Quiz=3 - pt_BR	2	2025-08-21 14:16:55.407023	pt_BR
235	43	general	🔧 Conselho geral para type_c - Quiz=3 - pt_BR	1	2025-08-21 14:16:55.407023	pt_BR
236	43	relationship	🔧 Conselho de relacionamento para type_c - Quiz=3 - pt_BR	2	2025-08-21 14:16:55.407023	pt_BR
237	44	general	🔧 Conselho geral para type_a - Quiz=3 - es_ES	1	2025-08-21 14:16:55.407023	es_ES
238	44	relationship	🔧 Conselho de relacionamento para type_a - Quiz=3 - es_ES	2	2025-08-21 14:16:55.407023	es_ES
239	45	general	🔧 Conselho geral para type_b - Quiz=3 - es_ES	1	2025-08-21 14:16:55.407023	es_ES
240	45	relationship	🔧 Conselho de relacionamento para type_b - Quiz=3 - es_ES	2	2025-08-21 14:16:55.407023	es_ES
241	46	general	🔧 Conselho geral para type_c - Quiz=3 - es_ES	1	2025-08-21 14:16:55.407023	es_ES
242	46	relationship	🔧 Conselho de relacionamento para type_c - Quiz=3 - es_ES	2	2025-08-21 14:16:55.407023	es_ES
243	47	general	🔧 Conselho geral para type_a - Quiz=3 - fr_FR	1	2025-08-21 14:16:55.407023	fr_FR
244	47	relationship	🔧 Conselho de relacionamento para type_a - Quiz=3 - fr_FR	2	2025-08-21 14:16:55.407023	fr_FR
245	48	general	🔧 Conselho geral para type_b - Quiz=3 - fr_FR	1	2025-08-21 14:16:55.407023	fr_FR
246	48	relationship	🔧 Conselho de relacionamento para type_b - Quiz=3 - fr_FR	2	2025-08-21 14:16:55.407023	fr_FR
247	49	general	🔧 Conselho geral para type_c - Quiz=3 - fr_FR	1	2025-08-21 14:16:55.407023	fr_FR
248	49	relationship	🔧 Conselho de relacionamento para type_c - Quiz=3 - fr_FR	2	2025-08-21 14:16:55.407023	fr_FR
249	50	general	🔧 Conselho geral para type_a - Quiz=4 - en_US	1	2025-08-21 14:16:55.407023	en_US
250	50	relationship	🔧 Conselho de relacionamento para type_a - Quiz=4 - en_US	2	2025-08-21 14:16:55.407023	en_US
251	51	general	🔧 Conselho geral para type_b - Quiz=4 - en_US	1	2025-08-21 14:16:55.407023	en_US
252	51	relationship	🔧 Conselho de relacionamento para type_b - Quiz=4 - en_US	2	2025-08-21 14:16:55.407023	en_US
253	52	general	🔧 Conselho geral para type_c - Quiz=4 - en_US	1	2025-08-21 14:16:55.407023	en_US
254	52	relationship	🔧 Conselho de relacionamento para type_c - Quiz=4 - en_US	2	2025-08-21 14:16:55.407023	en_US
255	53	general	🔧 Conselho geral para type_a - Quiz=4 - pt_BR	1	2025-08-21 14:16:55.407023	pt_BR
256	53	relationship	🔧 Conselho de relacionamento para type_a - Quiz=4 - pt_BR	2	2025-08-21 14:16:55.407023	pt_BR
257	54	general	🔧 Conselho geral para type_b - Quiz=4 - pt_BR	1	2025-08-21 14:16:55.407023	pt_BR
258	54	relationship	🔧 Conselho de relacionamento para type_b - Quiz=4 - pt_BR	2	2025-08-21 14:16:55.407023	pt_BR
259	55	general	🔧 Conselho geral para type_c - Quiz=4 - pt_BR	1	2025-08-21 14:16:55.407023	pt_BR
260	55	relationship	🔧 Conselho de relacionamento para type_c - Quiz=4 - pt_BR	2	2025-08-21 14:16:55.407023	pt_BR
261	56	general	🔧 Conselho geral para type_a - Quiz=4 - es_ES	1	2025-08-21 14:16:55.407023	es_ES
262	56	relationship	🔧 Conselho de relacionamento para type_a - Quiz=4 - es_ES	2	2025-08-21 14:16:55.407023	es_ES
263	57	general	🔧 Conselho geral para type_b - Quiz=4 - es_ES	1	2025-08-21 14:16:55.407023	es_ES
264	57	relationship	🔧 Conselho de relacionamento para type_b - Quiz=4 - es_ES	2	2025-08-21 14:16:55.407023	es_ES
265	58	general	🔧 Conselho geral para type_c - Quiz=4 - es_ES	1	2025-08-21 14:16:55.407023	es_ES
266	58	relationship	🔧 Conselho de relacionamento para type_c - Quiz=4 - es_ES	2	2025-08-21 14:16:55.407023	es_ES
267	59	general	🔧 Conselho geral para type_a - Quiz=4 - fr_FR	1	2025-08-21 14:16:55.407023	fr_FR
268	59	relationship	🔧 Conselho de relacionamento para type_a - Quiz=4 - fr_FR	2	2025-08-21 14:16:55.407023	fr_FR
269	60	general	🔧 Conselho geral para type_b - Quiz=4 - fr_FR	1	2025-08-21 14:16:55.407023	fr_FR
270	60	relationship	🔧 Conselho de relacionamento para type_b - Quiz=4 - fr_FR	2	2025-08-21 14:16:55.407023	fr_FR
271	61	general	🔧 Conselho geral para type_c - Quiz=4 - fr_FR	1	2025-08-21 14:16:55.407023	fr_FR
272	61	relationship	🔧 Conselho de relacionamento para type_c - Quiz=4 - fr_FR	2	2025-08-21 14:16:55.407023	fr_FR
273	62	general	🔧 Conselho geral para type_a - Quiz=5 - en_US	1	2025-08-21 14:16:55.407023	en_US
274	62	relationship	🔧 Conselho de relacionamento para type_a - Quiz=5 - en_US	2	2025-08-21 14:16:55.407023	en_US
275	63	general	🔧 Conselho geral para type_b - Quiz=5 - en_US	1	2025-08-21 14:16:55.407023	en_US
276	63	relationship	🔧 Conselho de relacionamento para type_b - Quiz=5 - en_US	2	2025-08-21 14:16:55.407023	en_US
277	64	general	🔧 Conselho geral para type_c - Quiz=5 - en_US	1	2025-08-21 14:16:55.407023	en_US
278	64	relationship	🔧 Conselho de relacionamento para type_c - Quiz=5 - en_US	2	2025-08-21 14:16:55.407023	en_US
279	65	general	🔧 Conselho geral para type_a - Quiz=5 - pt_BR	1	2025-08-21 14:16:55.407023	pt_BR
280	65	relationship	🔧 Conselho de relacionamento para type_a - Quiz=5 - pt_BR	2	2025-08-21 14:16:55.407023	pt_BR
281	66	general	🔧 Conselho geral para type_b - Quiz=5 - pt_BR	1	2025-08-21 14:16:55.407023	pt_BR
282	66	relationship	🔧 Conselho de relacionamento para type_b - Quiz=5 - pt_BR	2	2025-08-21 14:16:55.407023	pt_BR
283	67	general	🔧 Conselho geral para type_c - Quiz=5 - pt_BR	1	2025-08-21 14:16:55.407023	pt_BR
284	67	relationship	🔧 Conselho de relacionamento para type_c - Quiz=5 - pt_BR	2	2025-08-21 14:16:55.407023	pt_BR
285	68	general	🔧 Conselho geral para type_a - Quiz=5 - es_ES	1	2025-08-21 14:16:55.407023	es_ES
286	68	relationship	🔧 Conselho de relacionamento para type_a - Quiz=5 - es_ES	2	2025-08-21 14:16:55.407023	es_ES
287	69	general	🔧 Conselho geral para type_b - Quiz=5 - es_ES	1	2025-08-21 14:16:55.407023	es_ES
288	69	relationship	🔧 Conselho de relacionamento para type_b - Quiz=5 - es_ES	2	2025-08-21 14:16:55.407023	es_ES
289	70	general	🔧 Conselho geral para type_c - Quiz=5 - es_ES	1	2025-08-21 14:16:55.407023	es_ES
290	70	relationship	🔧 Conselho de relacionamento para type_c - Quiz=5 - es_ES	2	2025-08-21 14:16:55.407023	es_ES
291	71	general	🔧 Conselho geral para type_a - Quiz=5 - fr_FR	1	2025-08-21 14:16:55.407023	fr_FR
292	71	relationship	🔧 Conselho de relacionamento para type_a - Quiz=5 - fr_FR	2	2025-08-21 14:16:55.407023	fr_FR
293	72	general	🔧 Conselho geral para type_b - Quiz=5 - fr_FR	1	2025-08-21 14:16:55.407023	fr_FR
294	72	relationship	🔧 Conselho de relacionamento para type_b - Quiz=5 - fr_FR	2	2025-08-21 14:16:55.407023	fr_FR
295	73	general	🔧 Conselho geral para type_c - Quiz=5 - fr_FR	1	2025-08-21 14:16:55.407023	fr_FR
296	73	relationship	🔧 Conselho de relacionamento para type_c - Quiz=5 - fr_FR	2	2025-08-21 14:16:55.407023	fr_FR
297	74	general	🔧 Conselho geral para type_a - Quiz=6 - en_US	1	2025-08-21 14:16:55.407023	en_US
298	74	relationship	🔧 Conselho de relacionamento para type_a - Quiz=6 - en_US	2	2025-08-21 14:16:55.407023	en_US
299	75	general	🔧 Conselho geral para type_b - Quiz=6 - en_US	1	2025-08-21 14:16:55.407023	en_US
300	75	relationship	🔧 Conselho de relacionamento para type_b - Quiz=6 - en_US	2	2025-08-21 14:16:55.407023	en_US
301	76	general	🔧 Conselho geral para type_c - Quiz=6 - en_US	1	2025-08-21 14:16:55.407023	en_US
302	76	relationship	🔧 Conselho de relacionamento para type_c - Quiz=6 - en_US	2	2025-08-21 14:16:55.407023	en_US
303	77	general	🔧 Conselho geral para type_a - Quiz=6 - pt_BR	1	2025-08-21 14:16:55.407023	pt_BR
304	77	relationship	🔧 Conselho de relacionamento para type_a - Quiz=6 - pt_BR	2	2025-08-21 14:16:55.407023	pt_BR
305	78	general	🔧 Conselho geral para type_b - Quiz=6 - pt_BR	1	2025-08-21 14:16:55.407023	pt_BR
306	78	relationship	🔧 Conselho de relacionamento para type_b - Quiz=6 - pt_BR	2	2025-08-21 14:16:55.407023	pt_BR
307	79	general	🔧 Conselho geral para type_c - Quiz=6 - pt_BR	1	2025-08-21 14:16:55.407023	pt_BR
308	79	relationship	🔧 Conselho de relacionamento para type_c - Quiz=6 - pt_BR	2	2025-08-21 14:16:55.407023	pt_BR
309	80	general	🔧 Conselho geral para type_a - Quiz=6 - es_ES	1	2025-08-21 14:16:55.407023	es_ES
310	80	relationship	🔧 Conselho de relacionamento para type_a - Quiz=6 - es_ES	2	2025-08-21 14:16:55.407023	es_ES
311	81	general	🔧 Conselho geral para type_b - Quiz=6 - es_ES	1	2025-08-21 14:16:55.407023	es_ES
312	81	relationship	🔧 Conselho de relacionamento para type_b - Quiz=6 - es_ES	2	2025-08-21 14:16:55.407023	es_ES
313	82	general	🔧 Conselho geral para type_c - Quiz=6 - es_ES	1	2025-08-21 14:16:55.407023	es_ES
314	82	relationship	🔧 Conselho de relacionamento para type_c - Quiz=6 - es_ES	2	2025-08-21 14:16:55.407023	es_ES
315	83	general	🔧 Conselho geral para type_a - Quiz=6 - fr_FR	1	2025-08-21 14:16:55.407023	fr_FR
316	83	relationship	🔧 Conselho de relacionamento para type_a - Quiz=6 - fr_FR	2	2025-08-21 14:16:55.407023	fr_FR
317	84	general	🔧 Conselho geral para type_b - Quiz=6 - fr_FR	1	2025-08-21 14:16:55.407023	fr_FR
318	84	relationship	🔧 Conselho de relacionamento para type_b - Quiz=6 - fr_FR	2	2025-08-21 14:16:55.407023	fr_FR
319	85	general	🔧 Conselho geral para type_c - Quiz=6 - fr_FR	1	2025-08-21 14:16:55.407023	fr_FR
320	85	relationship	🔧 Conselho de relacionamento para type_c - Quiz=6 - fr_FR	2	2025-08-21 14:16:55.407023	fr_FR
321	26	general	🔧 Conselho geral para type_a - Quiz=2 - en_US	1	2025-08-21 14:17:09.54022	en_US
322	26	relationship	🔧 Conselho de relacionamento para type_a - Quiz=2 - en_US	2	2025-08-21 14:17:09.54022	en_US
323	27	general	🔧 Conselho geral para type_b - Quiz=2 - en_US	1	2025-08-21 14:17:09.54022	en_US
324	27	relationship	🔧 Conselho de relacionamento para type_b - Quiz=2 - en_US	2	2025-08-21 14:17:09.54022	en_US
325	28	general	🔧 Conselho geral para type_c - Quiz=2 - en_US	1	2025-08-21 14:17:09.54022	en_US
326	28	relationship	🔧 Conselho de relacionamento para type_c - Quiz=2 - en_US	2	2025-08-21 14:17:09.54022	en_US
327	29	general	🔧 Conselho geral para type_a - Quiz=2 - pt_BR	1	2025-08-21 14:17:09.54022	pt_BR
328	29	relationship	🔧 Conselho de relacionamento para type_a - Quiz=2 - pt_BR	2	2025-08-21 14:17:09.54022	pt_BR
329	30	general	🔧 Conselho geral para type_b - Quiz=2 - pt_BR	1	2025-08-21 14:17:09.54022	pt_BR
330	30	relationship	🔧 Conselho de relacionamento para type_b - Quiz=2 - pt_BR	2	2025-08-21 14:17:09.54022	pt_BR
331	31	general	🔧 Conselho geral para type_c - Quiz=2 - pt_BR	1	2025-08-21 14:17:09.54022	pt_BR
332	31	relationship	🔧 Conselho de relacionamento para type_c - Quiz=2 - pt_BR	2	2025-08-21 14:17:09.54022	pt_BR
333	32	general	🔧 Conselho geral para type_a - Quiz=2 - es_ES	1	2025-08-21 14:17:09.54022	es_ES
334	32	relationship	🔧 Conselho de relacionamento para type_a - Quiz=2 - es_ES	2	2025-08-21 14:17:09.54022	es_ES
335	33	general	🔧 Conselho geral para type_b - Quiz=2 - es_ES	1	2025-08-21 14:17:09.54022	es_ES
336	33	relationship	🔧 Conselho de relacionamento para type_b - Quiz=2 - es_ES	2	2025-08-21 14:17:09.54022	es_ES
337	34	general	🔧 Conselho geral para type_c - Quiz=2 - es_ES	1	2025-08-21 14:17:09.54022	es_ES
338	34	relationship	🔧 Conselho de relacionamento para type_c - Quiz=2 - es_ES	2	2025-08-21 14:17:09.54022	es_ES
339	35	general	🔧 Conselho geral para type_a - Quiz=2 - fr_FR	1	2025-08-21 14:17:09.54022	fr_FR
340	35	relationship	🔧 Conselho de relacionamento para type_a - Quiz=2 - fr_FR	2	2025-08-21 14:17:09.54022	fr_FR
341	36	general	🔧 Conselho geral para type_b - Quiz=2 - fr_FR	1	2025-08-21 14:17:09.54022	fr_FR
342	36	relationship	🔧 Conselho de relacionamento para type_b - Quiz=2 - fr_FR	2	2025-08-21 14:17:09.54022	fr_FR
343	37	general	🔧 Conselho geral para type_c - Quiz=2 - fr_FR	1	2025-08-21 14:17:09.54022	fr_FR
344	37	relationship	🔧 Conselho de relacionamento para type_c - Quiz=2 - fr_FR	2	2025-08-21 14:17:09.54022	fr_FR
345	38	general	🔧 Conselho geral para type_a - Quiz=3 - en_US	1	2025-08-21 14:17:09.54022	en_US
346	38	relationship	🔧 Conselho de relacionamento para type_a - Quiz=3 - en_US	2	2025-08-21 14:17:09.54022	en_US
347	39	general	🔧 Conselho geral para type_b - Quiz=3 - en_US	1	2025-08-21 14:17:09.54022	en_US
348	39	relationship	🔧 Conselho de relacionamento para type_b - Quiz=3 - en_US	2	2025-08-21 14:17:09.54022	en_US
349	40	general	🔧 Conselho geral para type_c - Quiz=3 - en_US	1	2025-08-21 14:17:09.54022	en_US
350	40	relationship	🔧 Conselho de relacionamento para type_c - Quiz=3 - en_US	2	2025-08-21 14:17:09.54022	en_US
351	41	general	🔧 Conselho geral para type_a - Quiz=3 - pt_BR	1	2025-08-21 14:17:09.54022	pt_BR
352	41	relationship	🔧 Conselho de relacionamento para type_a - Quiz=3 - pt_BR	2	2025-08-21 14:17:09.54022	pt_BR
353	42	general	🔧 Conselho geral para type_b - Quiz=3 - pt_BR	1	2025-08-21 14:17:09.54022	pt_BR
354	42	relationship	🔧 Conselho de relacionamento para type_b - Quiz=3 - pt_BR	2	2025-08-21 14:17:09.54022	pt_BR
355	43	general	🔧 Conselho geral para type_c - Quiz=3 - pt_BR	1	2025-08-21 14:17:09.54022	pt_BR
356	43	relationship	🔧 Conselho de relacionamento para type_c - Quiz=3 - pt_BR	2	2025-08-21 14:17:09.54022	pt_BR
357	44	general	🔧 Conselho geral para type_a - Quiz=3 - es_ES	1	2025-08-21 14:17:09.54022	es_ES
358	44	relationship	🔧 Conselho de relacionamento para type_a - Quiz=3 - es_ES	2	2025-08-21 14:17:09.54022	es_ES
359	45	general	🔧 Conselho geral para type_b - Quiz=3 - es_ES	1	2025-08-21 14:17:09.54022	es_ES
360	45	relationship	🔧 Conselho de relacionamento para type_b - Quiz=3 - es_ES	2	2025-08-21 14:17:09.54022	es_ES
361	46	general	🔧 Conselho geral para type_c - Quiz=3 - es_ES	1	2025-08-21 14:17:09.54022	es_ES
362	46	relationship	🔧 Conselho de relacionamento para type_c - Quiz=3 - es_ES	2	2025-08-21 14:17:09.54022	es_ES
363	47	general	🔧 Conselho geral para type_a - Quiz=3 - fr_FR	1	2025-08-21 14:17:09.54022	fr_FR
364	47	relationship	🔧 Conselho de relacionamento para type_a - Quiz=3 - fr_FR	2	2025-08-21 14:17:09.54022	fr_FR
365	48	general	🔧 Conselho geral para type_b - Quiz=3 - fr_FR	1	2025-08-21 14:17:09.54022	fr_FR
366	48	relationship	🔧 Conselho de relacionamento para type_b - Quiz=3 - fr_FR	2	2025-08-21 14:17:09.54022	fr_FR
367	49	general	🔧 Conselho geral para type_c - Quiz=3 - fr_FR	1	2025-08-21 14:17:09.54022	fr_FR
368	49	relationship	🔧 Conselho de relacionamento para type_c - Quiz=3 - fr_FR	2	2025-08-21 14:17:09.54022	fr_FR
369	50	general	🔧 Conselho geral para type_a - Quiz=4 - en_US	1	2025-08-21 14:17:09.54022	en_US
370	50	relationship	🔧 Conselho de relacionamento para type_a - Quiz=4 - en_US	2	2025-08-21 14:17:09.54022	en_US
371	51	general	🔧 Conselho geral para type_b - Quiz=4 - en_US	1	2025-08-21 14:17:09.54022	en_US
372	51	relationship	🔧 Conselho de relacionamento para type_b - Quiz=4 - en_US	2	2025-08-21 14:17:09.54022	en_US
373	52	general	🔧 Conselho geral para type_c - Quiz=4 - en_US	1	2025-08-21 14:17:09.54022	en_US
374	52	relationship	🔧 Conselho de relacionamento para type_c - Quiz=4 - en_US	2	2025-08-21 14:17:09.54022	en_US
375	53	general	🔧 Conselho geral para type_a - Quiz=4 - pt_BR	1	2025-08-21 14:17:09.54022	pt_BR
376	53	relationship	🔧 Conselho de relacionamento para type_a - Quiz=4 - pt_BR	2	2025-08-21 14:17:09.54022	pt_BR
377	54	general	🔧 Conselho geral para type_b - Quiz=4 - pt_BR	1	2025-08-21 14:17:09.54022	pt_BR
378	54	relationship	🔧 Conselho de relacionamento para type_b - Quiz=4 - pt_BR	2	2025-08-21 14:17:09.54022	pt_BR
379	55	general	🔧 Conselho geral para type_c - Quiz=4 - pt_BR	1	2025-08-21 14:17:09.54022	pt_BR
380	55	relationship	🔧 Conselho de relacionamento para type_c - Quiz=4 - pt_BR	2	2025-08-21 14:17:09.54022	pt_BR
381	56	general	🔧 Conselho geral para type_a - Quiz=4 - es_ES	1	2025-08-21 14:17:09.54022	es_ES
382	56	relationship	🔧 Conselho de relacionamento para type_a - Quiz=4 - es_ES	2	2025-08-21 14:17:09.54022	es_ES
383	57	general	🔧 Conselho geral para type_b - Quiz=4 - es_ES	1	2025-08-21 14:17:09.54022	es_ES
384	57	relationship	🔧 Conselho de relacionamento para type_b - Quiz=4 - es_ES	2	2025-08-21 14:17:09.54022	es_ES
385	58	general	🔧 Conselho geral para type_c - Quiz=4 - es_ES	1	2025-08-21 14:17:09.54022	es_ES
386	58	relationship	🔧 Conselho de relacionamento para type_c - Quiz=4 - es_ES	2	2025-08-21 14:17:09.54022	es_ES
387	59	general	🔧 Conselho geral para type_a - Quiz=4 - fr_FR	1	2025-08-21 14:17:09.54022	fr_FR
388	59	relationship	🔧 Conselho de relacionamento para type_a - Quiz=4 - fr_FR	2	2025-08-21 14:17:09.54022	fr_FR
389	60	general	🔧 Conselho geral para type_b - Quiz=4 - fr_FR	1	2025-08-21 14:17:09.54022	fr_FR
390	60	relationship	🔧 Conselho de relacionamento para type_b - Quiz=4 - fr_FR	2	2025-08-21 14:17:09.54022	fr_FR
391	61	general	🔧 Conselho geral para type_c - Quiz=4 - fr_FR	1	2025-08-21 14:17:09.54022	fr_FR
392	61	relationship	🔧 Conselho de relacionamento para type_c - Quiz=4 - fr_FR	2	2025-08-21 14:17:09.54022	fr_FR
393	62	general	🔧 Conselho geral para type_a - Quiz=5 - en_US	1	2025-08-21 14:17:09.54022	en_US
394	62	relationship	🔧 Conselho de relacionamento para type_a - Quiz=5 - en_US	2	2025-08-21 14:17:09.54022	en_US
395	63	general	🔧 Conselho geral para type_b - Quiz=5 - en_US	1	2025-08-21 14:17:09.54022	en_US
396	63	relationship	🔧 Conselho de relacionamento para type_b - Quiz=5 - en_US	2	2025-08-21 14:17:09.54022	en_US
397	64	general	🔧 Conselho geral para type_c - Quiz=5 - en_US	1	2025-08-21 14:17:09.54022	en_US
398	64	relationship	🔧 Conselho de relacionamento para type_c - Quiz=5 - en_US	2	2025-08-21 14:17:09.54022	en_US
399	65	general	🔧 Conselho geral para type_a - Quiz=5 - pt_BR	1	2025-08-21 14:17:09.54022	pt_BR
400	65	relationship	🔧 Conselho de relacionamento para type_a - Quiz=5 - pt_BR	2	2025-08-21 14:17:09.54022	pt_BR
401	66	general	🔧 Conselho geral para type_b - Quiz=5 - pt_BR	1	2025-08-21 14:17:09.54022	pt_BR
402	66	relationship	🔧 Conselho de relacionamento para type_b - Quiz=5 - pt_BR	2	2025-08-21 14:17:09.54022	pt_BR
403	67	general	🔧 Conselho geral para type_c - Quiz=5 - pt_BR	1	2025-08-21 14:17:09.54022	pt_BR
404	67	relationship	🔧 Conselho de relacionamento para type_c - Quiz=5 - pt_BR	2	2025-08-21 14:17:09.54022	pt_BR
405	68	general	🔧 Conselho geral para type_a - Quiz=5 - es_ES	1	2025-08-21 14:17:09.54022	es_ES
406	68	relationship	🔧 Conselho de relacionamento para type_a - Quiz=5 - es_ES	2	2025-08-21 14:17:09.54022	es_ES
407	69	general	🔧 Conselho geral para type_b - Quiz=5 - es_ES	1	2025-08-21 14:17:09.54022	es_ES
408	69	relationship	🔧 Conselho de relacionamento para type_b - Quiz=5 - es_ES	2	2025-08-21 14:17:09.54022	es_ES
409	70	general	🔧 Conselho geral para type_c - Quiz=5 - es_ES	1	2025-08-21 14:17:09.54022	es_ES
410	70	relationship	🔧 Conselho de relacionamento para type_c - Quiz=5 - es_ES	2	2025-08-21 14:17:09.54022	es_ES
411	71	general	🔧 Conselho geral para type_a - Quiz=5 - fr_FR	1	2025-08-21 14:17:09.54022	fr_FR
412	71	relationship	🔧 Conselho de relacionamento para type_a - Quiz=5 - fr_FR	2	2025-08-21 14:17:09.54022	fr_FR
413	72	general	🔧 Conselho geral para type_b - Quiz=5 - fr_FR	1	2025-08-21 14:17:09.54022	fr_FR
414	72	relationship	🔧 Conselho de relacionamento para type_b - Quiz=5 - fr_FR	2	2025-08-21 14:17:09.54022	fr_FR
415	73	general	🔧 Conselho geral para type_c - Quiz=5 - fr_FR	1	2025-08-21 14:17:09.54022	fr_FR
416	73	relationship	🔧 Conselho de relacionamento para type_c - Quiz=5 - fr_FR	2	2025-08-21 14:17:09.54022	fr_FR
417	74	general	🔧 Conselho geral para type_a - Quiz=6 - en_US	1	2025-08-21 14:17:09.54022	en_US
418	74	relationship	🔧 Conselho de relacionamento para type_a - Quiz=6 - en_US	2	2025-08-21 14:17:09.54022	en_US
419	75	general	🔧 Conselho geral para type_b - Quiz=6 - en_US	1	2025-08-21 14:17:09.54022	en_US
420	75	relationship	🔧 Conselho de relacionamento para type_b - Quiz=6 - en_US	2	2025-08-21 14:17:09.54022	en_US
421	76	general	🔧 Conselho geral para type_c - Quiz=6 - en_US	1	2025-08-21 14:17:09.54022	en_US
422	76	relationship	🔧 Conselho de relacionamento para type_c - Quiz=6 - en_US	2	2025-08-21 14:17:09.54022	en_US
423	77	general	🔧 Conselho geral para type_a - Quiz=6 - pt_BR	1	2025-08-21 14:17:09.54022	pt_BR
424	77	relationship	🔧 Conselho de relacionamento para type_a - Quiz=6 - pt_BR	2	2025-08-21 14:17:09.54022	pt_BR
425	78	general	🔧 Conselho geral para type_b - Quiz=6 - pt_BR	1	2025-08-21 14:17:09.54022	pt_BR
426	78	relationship	🔧 Conselho de relacionamento para type_b - Quiz=6 - pt_BR	2	2025-08-21 14:17:09.54022	pt_BR
427	79	general	🔧 Conselho geral para type_c - Quiz=6 - pt_BR	1	2025-08-21 14:17:09.54022	pt_BR
428	79	relationship	🔧 Conselho de relacionamento para type_c - Quiz=6 - pt_BR	2	2025-08-21 14:17:09.54022	pt_BR
429	80	general	🔧 Conselho geral para type_a - Quiz=6 - es_ES	1	2025-08-21 14:17:09.54022	es_ES
430	80	relationship	🔧 Conselho de relacionamento para type_a - Quiz=6 - es_ES	2	2025-08-21 14:17:09.54022	es_ES
431	81	general	🔧 Conselho geral para type_b - Quiz=6 - es_ES	1	2025-08-21 14:17:09.54022	es_ES
432	81	relationship	🔧 Conselho de relacionamento para type_b - Quiz=6 - es_ES	2	2025-08-21 14:17:09.54022	es_ES
433	82	general	🔧 Conselho geral para type_c - Quiz=6 - es_ES	1	2025-08-21 14:17:09.54022	es_ES
434	82	relationship	🔧 Conselho de relacionamento para type_c - Quiz=6 - es_ES	2	2025-08-21 14:17:09.54022	es_ES
435	83	general	🔧 Conselho geral para type_a - Quiz=6 - fr_FR	1	2025-08-21 14:17:09.54022	fr_FR
436	83	relationship	🔧 Conselho de relacionamento para type_a - Quiz=6 - fr_FR	2	2025-08-21 14:17:09.54022	fr_FR
437	84	general	🔧 Conselho geral para type_b - Quiz=6 - fr_FR	1	2025-08-21 14:17:09.54022	fr_FR
438	84	relationship	🔧 Conselho de relacionamento para type_b - Quiz=6 - fr_FR	2	2025-08-21 14:17:09.54022	fr_FR
439	85	general	🔧 Conselho geral para type_c - Quiz=6 - fr_FR	1	2025-08-21 14:17:09.54022	fr_FR
440	85	relationship	🔧 Conselho de relacionamento para type_c - Quiz=6 - fr_FR	2	2025-08-21 14:17:09.54022	fr_FR
\.


--
-- Data for Name: answer_options; Type: TABLE DATA; Schema: public; Owner: quiz_user
--

COPY public.answer_options (id, question_id, option_text, option_order, personality_weight, created_at, country) FROM stdin;
132	17	Una cena romántica en casa con velas	0	{"nurturer": 2, "romantic": 3, "adventurer": 1, "communicator": 1}	2025-08-17 18:57:14.214519	es_ES
133	17	Salir a un restaurante elegante	1	{"nurturer": 1, "romantic": 2, "adventurer": 3, "communicator": 1}	2025-08-17 18:57:14.222084	es_ES
134	17	Ver una película juntos en el sofá	2	{"nurturer": 3, "romantic": 1, "adventurer": 1, "communicator": 2}	2025-08-17 18:57:14.225899	es_ES
135	17	Ir a un concierto o evento en vivo	3	{"nurturer": 1, "romantic": 1, "adventurer": 3, "communicator": 2}	2025-08-17 18:57:14.227445	es_ES
136	19	Hablo inmediatamente sobre el problema	0	{"nurturer": 1, "romantic": 1, "adventurer": 2, "communicator": 3}	2025-08-17 18:57:14.231456	es_ES
137	19	Tomo tiempo para pensar antes de hablar	1	{"nurturer": 2, "romantic": 2, "adventurer": 1, "communicator": 3}	2025-08-17 18:57:14.232933	es_ES
138	19	Trato de evitar la confrontación	2	{"nurturer": 3, "romantic": 2, "adventurer": 1, "communicator": 1}	2025-08-17 18:57:14.23459	es_ES
139	19	Busco un compromiso que funcione para ambos	3	{"nurturer": 2, "romantic": 2, "adventurer": 2, "communicator": 3}	2025-08-17 18:57:14.235401	es_ES
148	26	Su inteligencia y conversación	0	{"nurturer": 1, "romantic": 1, "adventurer": 1, "communicator": 3}	2025-08-17 18:57:14.241659	es_ES
140	21	Comunicación abierta y honesta	0	{"nurturer": 2, "romantic": 2, "adventurer": 1, "communicator": 3}	2025-08-17 18:57:14.236241	es_ES
141	21	Confianza y lealtad mutua	1	{"nurturer": 3, "romantic": 2, "adventurer": 1, "communicator": 2}	2025-08-17 18:57:14.236805	es_ES
142	21	Diversión y aventura compartida	2	{"nurturer": 1, "romantic": 1, "adventurer": 3, "communicator": 1}	2025-08-17 18:57:14.237235	es_ES
143	21	Apoyo emocional y comprensión	3	{"nurturer": 3, "romantic": 3, "adventurer": 1, "communicator": 1}	2025-08-17 18:57:14.237658	es_ES
144	23	A través de palabras de afirmación	0	{"nurturer": 1, "romantic": 3, "adventurer": 1, "communicator": 3}	2025-08-17 18:57:14.238378	es_ES
145	23	Con actos de servicio	1	{"nurturer": 3, "romantic": 1, "adventurer": 1, "communicator": 1}	2025-08-17 18:57:14.239218	es_ES
146	23	Dando regalos significativos	2	{"nurturer": 2, "romantic": 3, "adventurer": 2, "communicator": 1}	2025-08-17 18:57:14.239923	es_ES
147	23	Con contacto físico y cercanía	3	{"nurturer": 3, "romantic": 3, "adventurer": 1, "communicator": 1}	2025-08-17 18:57:14.240369	es_ES
149	26	Su sentido del humor	1	{"nurturer": 2, "romantic": 2, "adventurer": 3, "communicator": 2}	2025-08-17 18:57:14.24208	es_ES
150	26	Su estabilidad emocional	2	{"nurturer": 3, "romantic": 2, "adventurer": 1, "communicator": 2}	2025-08-17 18:57:14.242373	es_ES
151	26	Su pasión y energía	3	{"nurturer": 1, "romantic": 3, "adventurer": 3, "communicator": 1}	2025-08-17 18:57:14.242661	es_ES
161	30	🔧 Opcao 1 - Quiz=2 - en_US	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
162	30	🔧 Opcao 2 - Quiz=2 - en_US	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
163	30	🔧 Opcao 3 - Quiz=2 - en_US	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	en_US
164	30	🔧 Opcao 4 - Quiz=2 - en_US	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	en_US
165	31	🔧 Opcao 1 - Quiz=2 - en_US	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
166	31	🔧 Opcao 2 - Quiz=2 - en_US	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
167	31	🔧 Opcao 3 - Quiz=2 - en_US	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	en_US
168	31	🔧 Opcao 4 - Quiz=2 - en_US	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	en_US
169	32	🔧 Opcao 1 - Quiz=2 - en_US	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
170	32	🔧 Opcao 2 - Quiz=2 - en_US	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
171	32	🔧 Opcao 3 - Quiz=2 - en_US	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	en_US
172	32	🔧 Opcao 4 - Quiz=2 - en_US	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	en_US
173	33	🔧 Opcao 1 - Quiz=2 - en_US	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
174	33	🔧 Opcao 2 - Quiz=2 - en_US	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
175	33	🔧 Opcao 3 - Quiz=2 - en_US	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	en_US
176	33	🔧 Opcao 4 - Quiz=2 - en_US	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	en_US
177	34	🔧 Opcao 1 - Quiz=2 - en_US	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
178	34	🔧 Opcao 2 - Quiz=2 - en_US	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
179	34	🔧 Opcao 3 - Quiz=2 - en_US	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	en_US
180	34	🔧 Opcao 4 - Quiz=2 - en_US	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	en_US
181	35	🔧 Opcao 1 - Quiz=2 - pt_BR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
182	35	🔧 Opcao 2 - Quiz=2 - pt_BR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
183	35	🔧 Opcao 3 - Quiz=2 - pt_BR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	pt_BR
184	35	🔧 Opcao 4 - Quiz=2 - pt_BR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	pt_BR
185	36	🔧 Opcao 1 - Quiz=2 - pt_BR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
186	36	🔧 Opcao 2 - Quiz=2 - pt_BR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
187	36	🔧 Opcao 3 - Quiz=2 - pt_BR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	pt_BR
188	36	🔧 Opcao 4 - Quiz=2 - pt_BR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	pt_BR
189	37	🔧 Opcao 1 - Quiz=2 - pt_BR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
190	37	🔧 Opcao 2 - Quiz=2 - pt_BR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
191	37	🔧 Opcao 3 - Quiz=2 - pt_BR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	pt_BR
192	37	🔧 Opcao 4 - Quiz=2 - pt_BR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	pt_BR
193	38	🔧 Opcao 1 - Quiz=2 - pt_BR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
194	38	🔧 Opcao 2 - Quiz=2 - pt_BR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
195	38	🔧 Opcao 3 - Quiz=2 - pt_BR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	pt_BR
196	38	🔧 Opcao 4 - Quiz=2 - pt_BR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	pt_BR
197	39	🔧 Opcao 1 - Quiz=2 - pt_BR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
198	39	🔧 Opcao 2 - Quiz=2 - pt_BR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
199	39	🔧 Opcao 3 - Quiz=2 - pt_BR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	pt_BR
200	39	🔧 Opcao 4 - Quiz=2 - pt_BR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	pt_BR
201	40	🔧 Opcao 1 - Quiz=2 - es_ES	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
202	40	🔧 Opcao 2 - Quiz=2 - es_ES	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
203	40	🔧 Opcao 3 - Quiz=2 - es_ES	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	es_ES
204	40	🔧 Opcao 4 - Quiz=2 - es_ES	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	es_ES
205	41	🔧 Opcao 1 - Quiz=2 - es_ES	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
206	41	🔧 Opcao 2 - Quiz=2 - es_ES	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
207	41	🔧 Opcao 3 - Quiz=2 - es_ES	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	es_ES
208	41	🔧 Opcao 4 - Quiz=2 - es_ES	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	es_ES
209	42	🔧 Opcao 1 - Quiz=2 - es_ES	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
210	42	🔧 Opcao 2 - Quiz=2 - es_ES	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
211	42	🔧 Opcao 3 - Quiz=2 - es_ES	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	es_ES
212	42	🔧 Opcao 4 - Quiz=2 - es_ES	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	es_ES
213	43	🔧 Opcao 1 - Quiz=2 - es_ES	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
214	43	🔧 Opcao 2 - Quiz=2 - es_ES	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
215	43	🔧 Opcao 3 - Quiz=2 - es_ES	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	es_ES
216	43	🔧 Opcao 4 - Quiz=2 - es_ES	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	es_ES
217	44	🔧 Opcao 1 - Quiz=2 - es_ES	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
218	44	🔧 Opcao 2 - Quiz=2 - es_ES	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
219	44	🔧 Opcao 3 - Quiz=2 - es_ES	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	es_ES
220	44	🔧 Opcao 4 - Quiz=2 - es_ES	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	es_ES
221	45	🔧 Opcao 1 - Quiz=2 - fr_FR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
222	45	🔧 Opcao 2 - Quiz=2 - fr_FR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
223	45	🔧 Opcao 3 - Quiz=2 - fr_FR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	fr_FR
224	45	🔧 Opcao 4 - Quiz=2 - fr_FR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	fr_FR
225	46	🔧 Opcao 1 - Quiz=2 - fr_FR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
226	46	🔧 Opcao 2 - Quiz=2 - fr_FR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
227	46	🔧 Opcao 3 - Quiz=2 - fr_FR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	fr_FR
228	46	🔧 Opcao 4 - Quiz=2 - fr_FR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	fr_FR
229	47	🔧 Opcao 1 - Quiz=2 - fr_FR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
230	47	🔧 Opcao 2 - Quiz=2 - fr_FR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
231	47	🔧 Opcao 3 - Quiz=2 - fr_FR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	fr_FR
232	47	🔧 Opcao 4 - Quiz=2 - fr_FR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	fr_FR
233	48	🔧 Opcao 1 - Quiz=2 - fr_FR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
234	48	🔧 Opcao 2 - Quiz=2 - fr_FR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
235	48	🔧 Opcao 3 - Quiz=2 - fr_FR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	fr_FR
236	48	🔧 Opcao 4 - Quiz=2 - fr_FR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	fr_FR
237	49	🔧 Opcao 1 - Quiz=2 - fr_FR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
238	49	🔧 Opcao 2 - Quiz=2 - fr_FR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
239	49	🔧 Opcao 3 - Quiz=2 - fr_FR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	fr_FR
240	49	🔧 Opcao 4 - Quiz=2 - fr_FR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	fr_FR
241	50	🔧 Opcao 1 - Quiz=3 - en_US	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
242	50	🔧 Opcao 2 - Quiz=3 - en_US	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
243	50	🔧 Opcao 3 - Quiz=3 - en_US	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	en_US
244	50	🔧 Opcao 4 - Quiz=3 - en_US	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	en_US
245	51	🔧 Opcao 1 - Quiz=3 - en_US	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
246	51	🔧 Opcao 2 - Quiz=3 - en_US	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
247	51	🔧 Opcao 3 - Quiz=3 - en_US	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	en_US
248	51	🔧 Opcao 4 - Quiz=3 - en_US	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	en_US
249	52	🔧 Opcao 1 - Quiz=3 - en_US	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
250	52	🔧 Opcao 2 - Quiz=3 - en_US	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
251	52	🔧 Opcao 3 - Quiz=3 - en_US	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	en_US
252	52	🔧 Opcao 4 - Quiz=3 - en_US	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	en_US
253	53	🔧 Opcao 1 - Quiz=3 - en_US	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
254	53	🔧 Opcao 2 - Quiz=3 - en_US	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
255	53	🔧 Opcao 3 - Quiz=3 - en_US	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	en_US
256	53	🔧 Opcao 4 - Quiz=3 - en_US	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	en_US
257	54	🔧 Opcao 1 - Quiz=3 - en_US	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
258	54	🔧 Opcao 2 - Quiz=3 - en_US	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
259	54	🔧 Opcao 3 - Quiz=3 - en_US	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	en_US
260	54	🔧 Opcao 4 - Quiz=3 - en_US	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	en_US
261	55	🔧 Opcao 1 - Quiz=3 - pt_BR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
262	55	🔧 Opcao 2 - Quiz=3 - pt_BR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
263	55	🔧 Opcao 3 - Quiz=3 - pt_BR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	pt_BR
264	55	🔧 Opcao 4 - Quiz=3 - pt_BR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	pt_BR
265	56	🔧 Opcao 1 - Quiz=3 - pt_BR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
266	56	🔧 Opcao 2 - Quiz=3 - pt_BR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
267	56	🔧 Opcao 3 - Quiz=3 - pt_BR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	pt_BR
268	56	🔧 Opcao 4 - Quiz=3 - pt_BR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	pt_BR
269	57	🔧 Opcao 1 - Quiz=3 - pt_BR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
270	57	🔧 Opcao 2 - Quiz=3 - pt_BR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
271	57	🔧 Opcao 3 - Quiz=3 - pt_BR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	pt_BR
272	57	🔧 Opcao 4 - Quiz=3 - pt_BR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	pt_BR
273	58	🔧 Opcao 1 - Quiz=3 - pt_BR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
274	58	🔧 Opcao 2 - Quiz=3 - pt_BR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
275	58	🔧 Opcao 3 - Quiz=3 - pt_BR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	pt_BR
276	58	🔧 Opcao 4 - Quiz=3 - pt_BR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	pt_BR
277	59	🔧 Opcao 1 - Quiz=3 - pt_BR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
278	59	🔧 Opcao 2 - Quiz=3 - pt_BR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
279	59	🔧 Opcao 3 - Quiz=3 - pt_BR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	pt_BR
280	59	🔧 Opcao 4 - Quiz=3 - pt_BR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	pt_BR
281	60	🔧 Opcao 1 - Quiz=3 - es_ES	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
282	60	🔧 Opcao 2 - Quiz=3 - es_ES	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
283	60	🔧 Opcao 3 - Quiz=3 - es_ES	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	es_ES
284	60	🔧 Opcao 4 - Quiz=3 - es_ES	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	es_ES
285	61	🔧 Opcao 1 - Quiz=3 - es_ES	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
286	61	🔧 Opcao 2 - Quiz=3 - es_ES	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
287	61	🔧 Opcao 3 - Quiz=3 - es_ES	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	es_ES
288	61	🔧 Opcao 4 - Quiz=3 - es_ES	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	es_ES
289	62	🔧 Opcao 1 - Quiz=3 - es_ES	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
290	62	🔧 Opcao 2 - Quiz=3 - es_ES	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
291	62	🔧 Opcao 3 - Quiz=3 - es_ES	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	es_ES
292	62	🔧 Opcao 4 - Quiz=3 - es_ES	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	es_ES
293	63	🔧 Opcao 1 - Quiz=3 - es_ES	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
294	63	🔧 Opcao 2 - Quiz=3 - es_ES	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
295	63	🔧 Opcao 3 - Quiz=3 - es_ES	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	es_ES
296	63	🔧 Opcao 4 - Quiz=3 - es_ES	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	es_ES
297	64	🔧 Opcao 1 - Quiz=3 - es_ES	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
298	64	🔧 Opcao 2 - Quiz=3 - es_ES	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
299	64	🔧 Opcao 3 - Quiz=3 - es_ES	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	es_ES
300	64	🔧 Opcao 4 - Quiz=3 - es_ES	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	es_ES
301	65	🔧 Opcao 1 - Quiz=3 - fr_FR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
302	65	🔧 Opcao 2 - Quiz=3 - fr_FR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
303	65	🔧 Opcao 3 - Quiz=3 - fr_FR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	fr_FR
304	65	🔧 Opcao 4 - Quiz=3 - fr_FR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	fr_FR
305	66	🔧 Opcao 1 - Quiz=3 - fr_FR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
306	66	🔧 Opcao 2 - Quiz=3 - fr_FR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
307	66	🔧 Opcao 3 - Quiz=3 - fr_FR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	fr_FR
308	66	🔧 Opcao 4 - Quiz=3 - fr_FR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	fr_FR
309	67	🔧 Opcao 1 - Quiz=3 - fr_FR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
310	67	🔧 Opcao 2 - Quiz=3 - fr_FR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
311	67	🔧 Opcao 3 - Quiz=3 - fr_FR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	fr_FR
312	67	🔧 Opcao 4 - Quiz=3 - fr_FR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	fr_FR
313	68	🔧 Opcao 1 - Quiz=3 - fr_FR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
314	68	🔧 Opcao 2 - Quiz=3 - fr_FR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
315	68	🔧 Opcao 3 - Quiz=3 - fr_FR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	fr_FR
316	68	🔧 Opcao 4 - Quiz=3 - fr_FR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	fr_FR
317	69	🔧 Opcao 1 - Quiz=3 - fr_FR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
318	69	🔧 Opcao 2 - Quiz=3 - fr_FR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
319	69	🔧 Opcao 3 - Quiz=3 - fr_FR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	fr_FR
320	69	🔧 Opcao 4 - Quiz=3 - fr_FR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	fr_FR
321	70	🔧 Opcao 1 - Quiz=4 - en_US	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
322	70	🔧 Opcao 2 - Quiz=4 - en_US	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
323	70	🔧 Opcao 3 - Quiz=4 - en_US	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	en_US
324	70	🔧 Opcao 4 - Quiz=4 - en_US	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	en_US
325	71	🔧 Opcao 1 - Quiz=4 - en_US	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
326	71	🔧 Opcao 2 - Quiz=4 - en_US	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
327	71	🔧 Opcao 3 - Quiz=4 - en_US	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	en_US
328	71	🔧 Opcao 4 - Quiz=4 - en_US	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	en_US
329	72	🔧 Opcao 1 - Quiz=4 - en_US	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
330	72	🔧 Opcao 2 - Quiz=4 - en_US	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
331	72	🔧 Opcao 3 - Quiz=4 - en_US	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	en_US
332	72	🔧 Opcao 4 - Quiz=4 - en_US	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	en_US
333	73	🔧 Opcao 1 - Quiz=4 - en_US	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
334	73	🔧 Opcao 2 - Quiz=4 - en_US	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
335	73	🔧 Opcao 3 - Quiz=4 - en_US	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	en_US
336	73	🔧 Opcao 4 - Quiz=4 - en_US	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	en_US
337	74	🔧 Opcao 1 - Quiz=4 - en_US	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
338	74	🔧 Opcao 2 - Quiz=4 - en_US	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
339	74	🔧 Opcao 3 - Quiz=4 - en_US	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	en_US
340	74	🔧 Opcao 4 - Quiz=4 - en_US	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	en_US
341	75	🔧 Opcao 1 - Quiz=4 - pt_BR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
342	75	🔧 Opcao 2 - Quiz=4 - pt_BR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
343	75	🔧 Opcao 3 - Quiz=4 - pt_BR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	pt_BR
344	75	🔧 Opcao 4 - Quiz=4 - pt_BR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	pt_BR
345	76	🔧 Opcao 1 - Quiz=4 - pt_BR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
346	76	🔧 Opcao 2 - Quiz=4 - pt_BR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
347	76	🔧 Opcao 3 - Quiz=4 - pt_BR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	pt_BR
348	76	🔧 Opcao 4 - Quiz=4 - pt_BR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	pt_BR
349	77	🔧 Opcao 1 - Quiz=4 - pt_BR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
350	77	🔧 Opcao 2 - Quiz=4 - pt_BR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
351	77	🔧 Opcao 3 - Quiz=4 - pt_BR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	pt_BR
352	77	🔧 Opcao 4 - Quiz=4 - pt_BR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	pt_BR
353	78	🔧 Opcao 1 - Quiz=4 - pt_BR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
354	78	🔧 Opcao 2 - Quiz=4 - pt_BR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
355	78	🔧 Opcao 3 - Quiz=4 - pt_BR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	pt_BR
356	78	🔧 Opcao 4 - Quiz=4 - pt_BR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	pt_BR
357	79	🔧 Opcao 1 - Quiz=4 - pt_BR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
358	79	🔧 Opcao 2 - Quiz=4 - pt_BR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
359	79	🔧 Opcao 3 - Quiz=4 - pt_BR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	pt_BR
360	79	🔧 Opcao 4 - Quiz=4 - pt_BR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	pt_BR
361	80	🔧 Opcao 1 - Quiz=4 - es_ES	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
362	80	🔧 Opcao 2 - Quiz=4 - es_ES	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
363	80	🔧 Opcao 3 - Quiz=4 - es_ES	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	es_ES
364	80	🔧 Opcao 4 - Quiz=4 - es_ES	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	es_ES
365	81	🔧 Opcao 1 - Quiz=4 - es_ES	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
366	81	🔧 Opcao 2 - Quiz=4 - es_ES	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
367	81	🔧 Opcao 3 - Quiz=4 - es_ES	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	es_ES
368	81	🔧 Opcao 4 - Quiz=4 - es_ES	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	es_ES
369	82	🔧 Opcao 1 - Quiz=4 - es_ES	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
370	82	🔧 Opcao 2 - Quiz=4 - es_ES	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
371	82	🔧 Opcao 3 - Quiz=4 - es_ES	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	es_ES
372	82	🔧 Opcao 4 - Quiz=4 - es_ES	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	es_ES
373	83	🔧 Opcao 1 - Quiz=4 - es_ES	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
374	83	🔧 Opcao 2 - Quiz=4 - es_ES	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
375	83	🔧 Opcao 3 - Quiz=4 - es_ES	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	es_ES
376	83	🔧 Opcao 4 - Quiz=4 - es_ES	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	es_ES
377	84	🔧 Opcao 1 - Quiz=4 - es_ES	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
378	84	🔧 Opcao 2 - Quiz=4 - es_ES	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
379	84	🔧 Opcao 3 - Quiz=4 - es_ES	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	es_ES
380	84	🔧 Opcao 4 - Quiz=4 - es_ES	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	es_ES
381	85	🔧 Opcao 1 - Quiz=4 - fr_FR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
382	85	🔧 Opcao 2 - Quiz=4 - fr_FR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
383	85	🔧 Opcao 3 - Quiz=4 - fr_FR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	fr_FR
384	85	🔧 Opcao 4 - Quiz=4 - fr_FR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	fr_FR
385	86	🔧 Opcao 1 - Quiz=4 - fr_FR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
386	86	🔧 Opcao 2 - Quiz=4 - fr_FR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
387	86	🔧 Opcao 3 - Quiz=4 - fr_FR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	fr_FR
388	86	🔧 Opcao 4 - Quiz=4 - fr_FR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	fr_FR
389	87	🔧 Opcao 1 - Quiz=4 - fr_FR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
390	87	🔧 Opcao 2 - Quiz=4 - fr_FR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
391	87	🔧 Opcao 3 - Quiz=4 - fr_FR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	fr_FR
392	87	🔧 Opcao 4 - Quiz=4 - fr_FR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	fr_FR
393	88	🔧 Opcao 1 - Quiz=4 - fr_FR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
394	88	🔧 Opcao 2 - Quiz=4 - fr_FR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
395	88	🔧 Opcao 3 - Quiz=4 - fr_FR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	fr_FR
396	88	🔧 Opcao 4 - Quiz=4 - fr_FR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	fr_FR
397	89	🔧 Opcao 1 - Quiz=4 - fr_FR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
398	89	🔧 Opcao 2 - Quiz=4 - fr_FR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
399	89	🔧 Opcao 3 - Quiz=4 - fr_FR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	fr_FR
400	89	🔧 Opcao 4 - Quiz=4 - fr_FR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	fr_FR
401	90	🔧 Opcao 1 - Quiz=5 - en_US	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
402	90	🔧 Opcao 2 - Quiz=5 - en_US	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
403	90	🔧 Opcao 3 - Quiz=5 - en_US	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	en_US
404	90	🔧 Opcao 4 - Quiz=5 - en_US	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	en_US
405	91	🔧 Opcao 1 - Quiz=5 - en_US	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
406	91	🔧 Opcao 2 - Quiz=5 - en_US	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
407	91	🔧 Opcao 3 - Quiz=5 - en_US	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	en_US
408	91	🔧 Opcao 4 - Quiz=5 - en_US	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	en_US
409	92	🔧 Opcao 1 - Quiz=5 - en_US	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
410	92	🔧 Opcao 2 - Quiz=5 - en_US	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
411	92	🔧 Opcao 3 - Quiz=5 - en_US	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	en_US
412	92	🔧 Opcao 4 - Quiz=5 - en_US	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	en_US
413	93	🔧 Opcao 1 - Quiz=5 - en_US	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
414	93	🔧 Opcao 2 - Quiz=5 - en_US	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
415	93	🔧 Opcao 3 - Quiz=5 - en_US	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	en_US
416	93	🔧 Opcao 4 - Quiz=5 - en_US	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	en_US
417	94	🔧 Opcao 1 - Quiz=5 - en_US	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
418	94	🔧 Opcao 2 - Quiz=5 - en_US	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
419	94	🔧 Opcao 3 - Quiz=5 - en_US	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	en_US
420	94	🔧 Opcao 4 - Quiz=5 - en_US	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	en_US
421	95	🔧 Opcao 1 - Quiz=5 - pt_BR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
422	95	🔧 Opcao 2 - Quiz=5 - pt_BR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
423	95	🔧 Opcao 3 - Quiz=5 - pt_BR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	pt_BR
424	95	🔧 Opcao 4 - Quiz=5 - pt_BR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	pt_BR
425	96	🔧 Opcao 1 - Quiz=5 - pt_BR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
426	96	🔧 Opcao 2 - Quiz=5 - pt_BR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
427	96	🔧 Opcao 3 - Quiz=5 - pt_BR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	pt_BR
428	96	🔧 Opcao 4 - Quiz=5 - pt_BR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	pt_BR
429	97	🔧 Opcao 1 - Quiz=5 - pt_BR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
430	97	🔧 Opcao 2 - Quiz=5 - pt_BR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
431	97	🔧 Opcao 3 - Quiz=5 - pt_BR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	pt_BR
432	97	🔧 Opcao 4 - Quiz=5 - pt_BR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	pt_BR
433	98	🔧 Opcao 1 - Quiz=5 - pt_BR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
434	98	🔧 Opcao 2 - Quiz=5 - pt_BR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
435	98	🔧 Opcao 3 - Quiz=5 - pt_BR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	pt_BR
436	98	🔧 Opcao 4 - Quiz=5 - pt_BR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	pt_BR
437	99	🔧 Opcao 1 - Quiz=5 - pt_BR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
438	99	🔧 Opcao 2 - Quiz=5 - pt_BR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
439	99	🔧 Opcao 3 - Quiz=5 - pt_BR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	pt_BR
440	99	🔧 Opcao 4 - Quiz=5 - pt_BR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	pt_BR
441	100	🔧 Opcao 1 - Quiz=5 - es_ES	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
442	100	🔧 Opcao 2 - Quiz=5 - es_ES	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
443	100	🔧 Opcao 3 - Quiz=5 - es_ES	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	es_ES
444	100	🔧 Opcao 4 - Quiz=5 - es_ES	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	es_ES
445	101	🔧 Opcao 1 - Quiz=5 - es_ES	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
446	101	🔧 Opcao 2 - Quiz=5 - es_ES	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
447	101	🔧 Opcao 3 - Quiz=5 - es_ES	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	es_ES
448	101	🔧 Opcao 4 - Quiz=5 - es_ES	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	es_ES
449	102	🔧 Opcao 1 - Quiz=5 - es_ES	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
450	102	🔧 Opcao 2 - Quiz=5 - es_ES	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
451	102	🔧 Opcao 3 - Quiz=5 - es_ES	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	es_ES
452	102	🔧 Opcao 4 - Quiz=5 - es_ES	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	es_ES
453	103	🔧 Opcao 1 - Quiz=5 - es_ES	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
454	103	🔧 Opcao 2 - Quiz=5 - es_ES	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
455	103	🔧 Opcao 3 - Quiz=5 - es_ES	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	es_ES
456	103	🔧 Opcao 4 - Quiz=5 - es_ES	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	es_ES
457	104	🔧 Opcao 1 - Quiz=5 - es_ES	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
458	104	🔧 Opcao 2 - Quiz=5 - es_ES	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
459	104	🔧 Opcao 3 - Quiz=5 - es_ES	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	es_ES
460	104	🔧 Opcao 4 - Quiz=5 - es_ES	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	es_ES
461	105	🔧 Opcao 1 - Quiz=5 - fr_FR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
462	105	🔧 Opcao 2 - Quiz=5 - fr_FR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
463	105	🔧 Opcao 3 - Quiz=5 - fr_FR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	fr_FR
464	105	🔧 Opcao 4 - Quiz=5 - fr_FR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	fr_FR
465	106	🔧 Opcao 1 - Quiz=5 - fr_FR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
466	106	🔧 Opcao 2 - Quiz=5 - fr_FR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
467	106	🔧 Opcao 3 - Quiz=5 - fr_FR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	fr_FR
468	106	🔧 Opcao 4 - Quiz=5 - fr_FR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	fr_FR
469	107	🔧 Opcao 1 - Quiz=5 - fr_FR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
470	107	🔧 Opcao 2 - Quiz=5 - fr_FR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
471	107	🔧 Opcao 3 - Quiz=5 - fr_FR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	fr_FR
472	107	🔧 Opcao 4 - Quiz=5 - fr_FR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	fr_FR
473	108	🔧 Opcao 1 - Quiz=5 - fr_FR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
474	108	🔧 Opcao 2 - Quiz=5 - fr_FR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
475	108	🔧 Opcao 3 - Quiz=5 - fr_FR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	fr_FR
476	108	🔧 Opcao 4 - Quiz=5 - fr_FR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	fr_FR
477	109	🔧 Opcao 1 - Quiz=5 - fr_FR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
478	109	🔧 Opcao 2 - Quiz=5 - fr_FR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
479	109	🔧 Opcao 3 - Quiz=5 - fr_FR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	fr_FR
480	109	🔧 Opcao 4 - Quiz=5 - fr_FR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	fr_FR
481	110	🔧 Opcao 1 - Quiz=6 - en_US	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
482	110	🔧 Opcao 2 - Quiz=6 - en_US	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
483	110	🔧 Opcao 3 - Quiz=6 - en_US	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	en_US
484	110	🔧 Opcao 4 - Quiz=6 - en_US	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	en_US
485	111	🔧 Opcao 1 - Quiz=6 - en_US	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
486	111	🔧 Opcao 2 - Quiz=6 - en_US	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
487	111	🔧 Opcao 3 - Quiz=6 - en_US	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	en_US
488	111	🔧 Opcao 4 - Quiz=6 - en_US	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	en_US
489	112	🔧 Opcao 1 - Quiz=6 - en_US	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
490	112	🔧 Opcao 2 - Quiz=6 - en_US	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
491	112	🔧 Opcao 3 - Quiz=6 - en_US	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	en_US
492	112	🔧 Opcao 4 - Quiz=6 - en_US	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	en_US
493	113	🔧 Opcao 1 - Quiz=6 - en_US	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
494	113	🔧 Opcao 2 - Quiz=6 - en_US	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
495	113	🔧 Opcao 3 - Quiz=6 - en_US	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	en_US
496	113	🔧 Opcao 4 - Quiz=6 - en_US	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	en_US
497	114	🔧 Opcao 1 - Quiz=6 - en_US	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
498	114	🔧 Opcao 2 - Quiz=6 - en_US	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	en_US
499	114	🔧 Opcao 3 - Quiz=6 - en_US	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	en_US
500	114	🔧 Opcao 4 - Quiz=6 - en_US	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	en_US
501	115	🔧 Opcao 1 - Quiz=6 - pt_BR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
502	115	🔧 Opcao 2 - Quiz=6 - pt_BR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
503	115	🔧 Opcao 3 - Quiz=6 - pt_BR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	pt_BR
504	115	🔧 Opcao 4 - Quiz=6 - pt_BR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	pt_BR
505	116	🔧 Opcao 1 - Quiz=6 - pt_BR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
506	116	🔧 Opcao 2 - Quiz=6 - pt_BR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
507	116	🔧 Opcao 3 - Quiz=6 - pt_BR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	pt_BR
508	116	🔧 Opcao 4 - Quiz=6 - pt_BR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	pt_BR
509	117	🔧 Opcao 1 - Quiz=6 - pt_BR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
510	117	🔧 Opcao 2 - Quiz=6 - pt_BR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
511	117	🔧 Opcao 3 - Quiz=6 - pt_BR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	pt_BR
512	117	🔧 Opcao 4 - Quiz=6 - pt_BR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	pt_BR
513	118	🔧 Opcao 1 - Quiz=6 - pt_BR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
514	118	🔧 Opcao 2 - Quiz=6 - pt_BR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
515	118	🔧 Opcao 3 - Quiz=6 - pt_BR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	pt_BR
516	118	🔧 Opcao 4 - Quiz=6 - pt_BR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	pt_BR
517	119	🔧 Opcao 1 - Quiz=6 - pt_BR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
518	119	🔧 Opcao 2 - Quiz=6 - pt_BR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	pt_BR
519	119	🔧 Opcao 3 - Quiz=6 - pt_BR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	pt_BR
520	119	🔧 Opcao 4 - Quiz=6 - pt_BR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	pt_BR
521	120	🔧 Opcao 1 - Quiz=6 - es_ES	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
522	120	🔧 Opcao 2 - Quiz=6 - es_ES	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
523	120	🔧 Opcao 3 - Quiz=6 - es_ES	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	es_ES
524	120	🔧 Opcao 4 - Quiz=6 - es_ES	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	es_ES
525	121	🔧 Opcao 1 - Quiz=6 - es_ES	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
526	121	🔧 Opcao 2 - Quiz=6 - es_ES	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
527	121	🔧 Opcao 3 - Quiz=6 - es_ES	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	es_ES
528	121	🔧 Opcao 4 - Quiz=6 - es_ES	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	es_ES
529	122	🔧 Opcao 1 - Quiz=6 - es_ES	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
530	122	🔧 Opcao 2 - Quiz=6 - es_ES	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
531	122	🔧 Opcao 3 - Quiz=6 - es_ES	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	es_ES
532	122	🔧 Opcao 4 - Quiz=6 - es_ES	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	es_ES
533	123	🔧 Opcao 1 - Quiz=6 - es_ES	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
534	123	🔧 Opcao 2 - Quiz=6 - es_ES	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
535	123	🔧 Opcao 3 - Quiz=6 - es_ES	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	es_ES
536	123	🔧 Opcao 4 - Quiz=6 - es_ES	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	es_ES
537	124	🔧 Opcao 1 - Quiz=6 - es_ES	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
538	124	🔧 Opcao 2 - Quiz=6 - es_ES	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	es_ES
539	124	🔧 Opcao 3 - Quiz=6 - es_ES	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	es_ES
540	124	🔧 Opcao 4 - Quiz=6 - es_ES	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	es_ES
541	125	🔧 Opcao 1 - Quiz=6 - fr_FR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
542	125	🔧 Opcao 2 - Quiz=6 - fr_FR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
543	125	🔧 Opcao 3 - Quiz=6 - fr_FR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	fr_FR
544	125	🔧 Opcao 4 - Quiz=6 - fr_FR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	fr_FR
545	126	🔧 Opcao 1 - Quiz=6 - fr_FR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
546	126	🔧 Opcao 2 - Quiz=6 - fr_FR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
547	126	🔧 Opcao 3 - Quiz=6 - fr_FR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	fr_FR
548	126	🔧 Opcao 4 - Quiz=6 - fr_FR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	fr_FR
549	127	🔧 Opcao 1 - Quiz=6 - fr_FR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
550	127	🔧 Opcao 2 - Quiz=6 - fr_FR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
551	127	🔧 Opcao 3 - Quiz=6 - fr_FR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	fr_FR
552	127	🔧 Opcao 4 - Quiz=6 - fr_FR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	fr_FR
553	128	🔧 Opcao 1 - Quiz=6 - fr_FR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
554	128	🔧 Opcao 2 - Quiz=6 - fr_FR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
555	128	🔧 Opcao 3 - Quiz=6 - fr_FR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	fr_FR
556	128	🔧 Opcao 4 - Quiz=6 - fr_FR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	fr_FR
557	129	🔧 Opcao 1 - Quiz=6 - fr_FR	1	{"type_a": 3, "type_b": 1, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
558	129	🔧 Opcao 2 - Quiz=6 - fr_FR	2	{"type_a": 1, "type_b": 3, "type_c": 0}	2025-08-21 14:17:09.514245	fr_FR
559	129	🔧 Opcao 3 - Quiz=6 - fr_FR	3	{"type_a": 0, "type_b": 1, "type_c": 3}	2025-08-21 14:17:09.514245	fr_FR
560	129	🔧 Opcao 4 - Quiz=6 - fr_FR	4	{"type_a": 0, "type_b": 0, "type_c": 1}	2025-08-21 14:17:09.514245	fr_FR
562	130	I prefer to address issues immediately and directly	0	{"independent": 1, "communicator": 3}	2025-08-21 16:32:27.994792	en_US
564	130	I need time to process before discussing	1	{"loyalist": 1, "independent": 3}	2025-08-21 16:32:28.001976	en_US
566	130	I try to find a compromise that works for everyone	2	{"nurturer": 1, "harmonizer": 3}	2025-08-21 16:32:28.002995	en_US
568	130	I sometimes avoid confrontation to keep the peace	3	{"nurturer": 2, "harmonizer": 2}	2025-08-21 16:32:28.003436	en_US
570	131	Open and honest communication	0	{"loyalist": 1, "communicator": 3}	2025-08-21 16:32:28.0038	en_US
572	131	Trust and mutual loyalty	1	{"loyalist": 3, "nurturer": 1}	2025-08-21 16:32:28.004506	en_US
574	131	Emotional support and understanding	2	{"nurturer": 3, "harmonizer": 1}	2025-08-21 16:32:28.00482	en_US
576	131	Respect for individual independence	3	{"independent": 3, "communicator": 1}	2025-08-21 16:32:28.005181	en_US
578	132	Through physical touch and closeness	0	{"nurturer": 3, "harmonizer": 1}	2025-08-21 16:32:28.005547	en_US
580	132	By giving gifts or doing thoughtful acts of service	1	{"loyalist": 1, "nurturer": 3}	2025-08-21 16:32:28.006159	en_US
582	132	With words of affirmation and praise	2	{"nurturer": 1, "communicator": 3}	2025-08-21 16:32:28.006497	en_US
584	132	By spending quality time together	3	{"loyalist": 1, "harmonizer": 3}	2025-08-21 16:32:28.006797	en_US
586	133	Take the lead and make decisions confidently	0	{"independent": 3, "communicator": 1}	2025-08-21 16:32:28.00714	en_US
588	133	Discuss all options thoroughly before deciding together	1	{"harmonizer": 1, "communicator": 3}	2025-08-21 16:32:28.0075	en_US
590	133	Consider your partner needs first	2	{"nurturer": 3, "harmonizer": 1}	2025-08-21 16:32:28.007822	en_US
592	133	Be flexible and go with the flow	3	{"harmonizer": 3, "independent": 1}	2025-08-21 16:32:28.008122	en_US
593	134	Express my feelings immediately and directly	0	{"independent": 1, "communicator": 3}	2025-08-21 16:32:28.008429	en_US
595	134	Withdraw and process my emotions privately	1	{"loyalist": 1, "independent": 3}	2025-08-21 16:32:28.011976	en_US
597	134	Seek comfort and support from my partner	2	{"nurturer": 3, "harmonizer": 1}	2025-08-21 16:32:28.012537	en_US
599	134	Try to understand their perspective first	3	{"loyalist": 1, "harmonizer": 3}	2025-08-21 16:32:28.012946	en_US
605	135	Prefiro abordar questões imediatamente e diretamente	0	{"independent": 1, "communicator": 3}	2025-08-21 20:37:12.695865	pt_BR
606	135	Preciso de tempo para processar antes de discutir	1	{"loyalist": 1, "independent": 3}	2025-08-21 20:37:12.695865	pt_BR
607	135	Tento encontrar um compromisso que funcione para todos	2	{"nurturer": 1, "harmonizer": 3}	2025-08-21 20:37:12.695865	pt_BR
608	135	Às vezes evito confrontos para manter a paz	3	{"nurturer": 2, "harmonizer": 2}	2025-08-21 20:37:12.695865	pt_BR
601	136	Comunicação aberta e honesta.	0	{"loyalist": 1, "communicator": 3}	2025-08-21 20:36:45.321426	pt_BR
602	136	Confiança e lealdade.	1	{"loyalist": 3, "communicator": 1}	2025-08-21 20:36:45.321426	pt_BR
603	136	Apoio emocional e compreensão.	2	{"nurturer": 3, "harmonizer": 1}	2025-08-21 20:36:45.321426	pt_BR
604	136	Crescimento e experiências compartilhadas.	3	{"independent": 3, "communicator": 1}	2025-08-21 20:36:45.321426	pt_BR
609	137	Através de palavras de afirmação e elogios	0	{"nurturer": 1, "communicator": 3}	2025-08-21 20:37:12.698061	pt_BR
610	137	Através de atos de serviço e ajuda prática	1	{"loyalist": 3, "nurturer": 2}	2025-08-21 20:37:12.698061	pt_BR
611	137	Através de toque físico e proximidade	2	{"nurturer": 2, "harmonizer": 3}	2025-08-21 20:37:12.698061	pt_BR
612	137	Através de presentes e gestos especiais	3	{"harmonizer": 2, "independent": 2}	2025-08-21 20:37:12.698061	pt_BR
613	138	Discutir todas as opções em detalhes juntos	0	{"harmonizer": 1, "communicator": 3}	2025-08-21 20:37:12.698918	pt_BR
614	138	Confiar na intuição e sentimentos mútuos	1	{"nurturer": 3, "harmonizer": 2}	2025-08-21 20:37:12.698918	pt_BR
615	138	Analisar os prós e contras logicamente	2	{"loyalist": 1, "independent": 3}	2025-08-21 20:37:12.698918	pt_BR
616	138	Seguir o que funcionou no passado	3	{"loyalist": 3, "independent": 1}	2025-08-21 20:37:12.698918	pt_BR
617	139	Expresso meus sentimentos imediatamente	0	{"independent": 2, "communicator": 3}	2025-08-21 20:37:12.699392	pt_BR
618	139	Preciso de tempo sozinho para processar	1	{"loyalist": 1, "independent": 3}	2025-08-21 20:37:12.699392	pt_BR
619	139	Busco conforto e apoio de outros	2	{"nurturer": 3, "harmonizer": 2}	2025-08-21 20:37:12.699392	pt_BR
620	139	Tento entender a perspectiva da outra pessoa	3	{"nurturer": 1, "harmonizer": 3}	2025-08-21 20:37:12.699392	pt_BR
621	145	Je préfère aborder les problèmes immédiatement et directement	0	{"steady": 1, "dominant": 3, "influential": 2, "conscientious": 2}	2025-08-22 12:40:37.783095	fr_FR
622	145	J'ai besoin de temps pour réfléchir avant de discuter	1	{"steady": 2, "dominant": 1, "influential": 1, "conscientious": 3}	2025-08-22 12:40:37.783095	fr_FR
623	145	J'essaie de trouver un compromis qui fonctionne pour tout le monde	2	{"steady": 3, "dominant": 1, "influential": 3, "conscientious": 2}	2025-08-22 12:40:37.783095	fr_FR
624	145	J'évite parfois la confrontation pour préserver la paix	3	{"steady": 3, "dominant": 1, "influential": 2, "conscientious": 1}	2025-08-22 12:40:37.783095	fr_FR
625	146	Communication ouverte et honnête	0	{"steady": 2, "dominant": 3, "influential": 3, "conscientious": 2}	2025-08-22 12:40:37.783095	fr_FR
626	146	Confiance et loyauté mutuelle	1	{"steady": 3, "dominant": 2, "influential": 2, "conscientious": 3}	2025-08-22 12:40:37.783095	fr_FR
627	146	Soutien émotionnel et compréhension	2	{"steady": 3, "dominant": 1, "influential": 2, "conscientious": 2}	2025-08-22 12:40:37.783095	fr_FR
628	146	Respect de l'indépendance individuelle	3	{"steady": 1, "dominant": 2, "influential": 1, "conscientious": 3}	2025-08-22 12:40:37.783095	fr_FR
629	147	Par le contact physique et la proximité	0	{"steady": 3, "dominant": 2, "influential": 3, "conscientious": 1}	2025-08-22 12:40:50.549682	fr_FR
630	147	En offrant des cadeaux ou en rendant des services attentionnés	1	{"steady": 2, "dominant": 2, "influential": 2, "conscientious": 3}	2025-08-22 12:40:50.549682	fr_FR
631	147	Avec des mots d'affirmation et des compliments	2	{"steady": 2, "dominant": 3, "influential": 3, "conscientious": 2}	2025-08-22 12:40:50.549682	fr_FR
632	147	En passant du temps de qualité ensemble	3	{"steady": 3, "dominant": 1, "influential": 2, "conscientious": 2}	2025-08-22 12:40:50.549682	fr_FR
633	148	Prendre les devants et décider avec confiance	0	{"steady": 1, "dominant": 3, "influential": 2, "conscientious": 2}	2025-08-22 12:40:50.549682	fr_FR
634	148	Discuter de toutes les options avant de décider ensemble	1	{"steady": 2, "dominant": 2, "influential": 3, "conscientious": 3}	2025-08-22 12:40:50.549682	fr_FR
635	148	Considérer d'abord les besoins de votre partenaire	2	{"steady": 3, "dominant": 1, "influential": 2, "conscientious": 2}	2025-08-22 12:40:50.549682	fr_FR
636	148	Être flexible et suivre le courant	3	{"steady": 2, "dominant": 1, "influential": 3, "conscientious": 1}	2025-08-22 12:40:50.549682	fr_FR
637	149	J'exprime mes sentiments immédiatement et directement	0	{"steady": 1, "dominant": 3, "influential": 3, "conscientious": 2}	2025-08-22 12:40:59.292868	fr_FR
638	149	Je me retire et traite mes émotions en privé	1	{"steady": 2, "dominant": 2, "influential": 1, "conscientious": 3}	2025-08-22 12:40:59.292868	fr_FR
639	149	Je cherche du réconfort et du soutien auprès de mon partenaire	2	{"steady": 3, "dominant": 1, "influential": 2, "conscientious": 2}	2025-08-22 12:40:59.292868	fr_FR
640	149	J'essaie d'abord de comprendre leur perspective	3	{"steady": 2, "dominant": 2, "influential": 2, "conscientious": 3}	2025-08-22 12:40:59.292868	fr_FR
\.


--
-- Data for Name: business_rules; Type: TABLE DATA; Schema: public; Owner: quiz_user
--

COPY public.business_rules (id, quiz_id, rule_name, rule_category, rule_config, priority, is_active, created_at) FROM stdin;
1	1	Simple Addition Scoring	scoring	{"algorithm": "simple_addition", "description": "Add personality weights from all answers", "implementation": "sum_all_weights"}	10	t	2025-08-15 18:48:52.277573
2	1	Highest Score Wins	scoring	{"algorithm": "highest_score_wins", "description": "Personality type with highest total score wins", "tie_breaking": "first_found"}	9	t	2025-08-15 18:48:52.280434
3	1	Score Initialization	scoring	{"description": "Initialize all personality type scores to 0", "initial_score": 0}	8	t	2025-08-15 18:48:52.281341
4	1	Complete All Questions Required	completion	{"description": "All questions must be answered", "allow_partial": false, "completion_rate": 100}	10	t	2025-08-15 18:48:52.282241
5	1	Result Display Format	result_display	{"sort_by_score": true, "include_scores": true, "include_percentages": true, "include_calculation_details": true}	5	t	2025-08-15 18:48:52.283449
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: quiz_user
--

COPY public.categories (id, name, description, created_at) FROM stdin;
1	conflict handling	Questions related to conflict handling	2025-08-15 17:17:27.113751
2	relationship priorities	Questions related to relationship priorities	2025-08-15 17:17:27.115041
3	affection expression	Questions related to affection expression	2025-08-15 17:17:27.11561
4	decision-making	Questions related to decision-making	2025-08-15 17:17:27.115946
5	emotional reactions	Questions related to emotional reactions	2025-08-15 17:17:27.116267
6	conflict handling	Questions related to conflict handling	2025-08-16 10:55:56.235932
7	relationship priorities	Questions related to relationship priorities	2025-08-16 10:55:56.237436
8	affection expression	Questions related to affection expression	2025-08-16 10:55:56.238165
9	decision-making	Questions related to decision-making	2025-08-16 10:55:56.238682
10	emotional reactions	Questions related to emotional reactions	2025-08-16 10:55:56.239641
11	conflict handling	Questions related to conflict handling	2025-08-16 11:41:45.926154
12	relationship priorities	Questions related to relationship priorities	2025-08-16 11:41:45.927203
13	affection expression	Questions related to affection expression	2025-08-16 11:41:45.927755
14	decision-making	Questions related to decision-making	2025-08-16 11:41:45.92817
15	emotional reactions	Questions related to emotional reactions	2025-08-16 11:41:45.928531
\.


--
-- Data for Name: currencies; Type: TABLE DATA; Schema: public; Owner: sidneygoldbach
--

COPY public.currencies (id, locale, currency, symbol, conversion2us, created_at, updated_at, country) FROM stdin;
1	en_US	USD	$	1.0000	2025-08-19 17:32:52.327701	2025-08-19 17:32:52.327701	English 🇺🇸
2	pt_BR	BRL	R$	5.0000	2025-08-19 17:32:52.327701	2025-08-19 17:32:52.327701	Português Brasil 🇧🇷
3	es_ES	EUR	€	0.9100	2025-08-19 17:32:52.327701	2025-08-19 17:32:52.327701	Español 🇪🇸
4	fr_FR	EUR	€	0.9100	2025-08-22 12:29:58.74554	2025-08-22 12:29:58.74554	Français 🇫🇷
\.


--
-- Data for Name: layout_locale; Type: TABLE DATA; Schema: public; Owner: quiz_user
--

COPY public.layout_locale (id, country, component_name, text_content, description, created_at) FROM stdin;
4	en_US	common.continue	Continue	\N	2025-08-16 13:57:20.558179
5	en_US	common.back	Back	\N	2025-08-16 13:57:20.558449
6	en_US	common.next	Next	\N	2025-08-16 13:57:20.558715
7	en_US	common.submit	Submit	\N	2025-08-16 13:57:20.559031
8	en_US	common.cancel	Cancel	\N	2025-08-16 13:57:20.55931
9	en_US	common.close	Close	\N	2025-08-16 13:57:20.559624
10	en_US	common.save	Save	\N	2025-08-16 13:57:20.559886
11	en_US	common.delete	Delete	\N	2025-08-16 13:57:20.560132
12	en_US	common.edit	Edit	\N	2025-08-16 13:57:20.560383
13	en_US	common.add	Add	\N	2025-08-16 13:57:20.560638
15	en_US	common.no	No	\N	2025-08-16 13:57:20.561283
16	en_US	quiz.title	Relationship Personality Quiz	\N	2025-08-16 13:57:20.561522
17	en_US	quiz.subtitle	Discover Your Relationship Style	\N	2025-08-16 13:57:20.561753
19	en_US	quiz.startButton	Start Quiz	\N	2025-08-16 13:57:20.562235
20	en_US	quiz.question	Question	\N	2025-08-16 13:57:20.562462
21	en_US	quiz.of	of	\N	2025-08-16 13:57:20.562694
22	en_US	quiz.previousQuestion	Previous Question	\N	2025-08-16 13:57:20.562926
23	en_US	quiz.nextQuestion	Next Question	\N	2025-08-16 13:57:20.563157
24	en_US	quiz.calculateResults	Calculate Results	\N	2025-08-16 13:57:20.563411
25	en_US	quiz.retakeQuiz	Take Quiz Again	\N	2025-08-16 13:57:20.563672
26	en_US	quiz.shareResults	Share Results	\N	2025-08-16 13:57:20.563936
27	en_US	results.title	Your Relationship Personality Results	\N	2025-08-16 13:57:20.56419
28	en_US	results.personalityInsights	Personality Insights	\N	2025-08-16 13:57:20.564459
29	en_US	results.relationshipTips	Relationship Improvement Tips	\N	2025-08-16 13:57:20.564776
30	en_US	results.shareOnFacebook	Share on Facebook	\N	2025-08-16 13:57:20.565026
31	en_US	results.takeQuizAgain	Take Quiz Again	\N	2025-08-16 13:57:20.565258
32	en_US	results.yourType	Your Type	\N	2025-08-16 13:57:20.565516
33	en_US	results.score	Score	\N	2025-08-16 13:57:20.565753
34	en_US	results.maxScore	Max Score	\N	2025-08-16 13:57:20.566002
35	en_US	results.percentage	Percentage	\N	2025-08-16 13:57:20.566711
36	en_US	payment.title	Complete Your Purchase	\N	2025-08-16 13:57:20.567087
37	en_US	payment.description	Secure payment to unlock your personalized relationship insights	\N	2025-08-16 13:57:20.56739
38	en_US	payment.amount	Amount	\N	2025-08-16 13:57:20.567697
39	en_US	payment.processing	Processing...	\N	2025-08-16 13:57:20.567945
40	en_US	payment.processing_message	Payment is processing. Please wait...	\N	2025-08-16 13:57:20.568206
41	en_US	payment.failed	Payment failed	\N	2025-08-16 13:57:20.568459
42	en_US	payment.button_pay	Pay	\N	2025-08-16 13:57:20.568689
43	en_US	payment.success	Payment successful! Your results are being prepared...	\N	2025-08-16 13:57:20.568952
44	en_US	payment.save_success	Your quiz results have been saved successfully!	\N	2025-08-16 13:57:20.569181
45	en_US	payment.save_warning	Payment successful, but there was an issue saving your results. Please contact support if needed.	\N	2025-08-16 13:57:20.569411
46	en_US	questions.q1	How do you typically handle conflicts in relationships?	\N	2025-08-16 13:57:20.56964
47	en_US	questions.q1_option_1	I prefer to address issues immediately and directly.	\N	2025-08-16 13:57:20.569944
48	en_US	questions.q1_option_2	I need time to process before discussing the problem.	\N	2025-08-16 13:57:20.570244
49	en_US	questions.q1_option_3	I try to find a compromise that works for everyone.	\N	2025-08-16 13:57:20.570528
50	en_US	questions.q1_option_4	I sometimes avoid confrontation to keep the peace.	\N	2025-08-16 13:57:20.570845
51	en_US	questions.q2	What's most important to you in a relationship?	\N	2025-08-16 13:57:20.571127
52	en_US	questions.q2_option_1	Open and honest communication.	\N	2025-08-16 13:57:20.571392
53	en_US	questions.q2_option_2	Trust and loyalty.	\N	2025-08-16 13:57:20.571619
54	en_US	questions.q2_option_3	Emotional support and understanding.	\N	2025-08-16 13:57:20.571852
55	en_US	questions.q2_option_4	Growth and shared experiences.	\N	2025-08-16 13:57:20.572121
56	en_US	questions.q3	How do you express affection to your partner?	\N	2025-08-16 13:57:20.57238
57	en_US	questions.q3_option_1	Through physical touch and closeness.	\N	2025-08-16 13:57:20.572617
58	en_US	questions.q3_option_2	By giving gifts or doing thoughtful acts of service.	\N	2025-08-16 13:57:20.57285
59	en_US	questions.q3_option_3	With words of affirmation and compliments.	\N	2025-08-16 13:57:20.57308
60	en_US	questions.q3_option_4	By spending quality time together.	\N	2025-08-16 13:57:20.573313
61	en_US	questions.q4	When making important decisions with a partner, you prefer to:	\N	2025-08-16 13:57:20.573537
62	en_US	questions.q4_option_1	Take the lead and make decisions confidently.	\N	2025-08-16 13:57:20.573775
63	en_US	questions.q4_option_2	Discuss all options thoroughly before deciding together.	\N	2025-08-16 13:57:20.574004
64	en_US	questions.q4_option_3	Consider your partner's needs first.	\N	2025-08-16 13:57:20.574205
65	en_US	questions.q4_option_4	Be flexible and go with the flow.	\N	2025-08-16 13:57:20.574471
67	en_US	questions.q5_option_1	Express my feelings immediately and directly.	\N	2025-08-16 13:57:20.574984
68	en_US	questions.q5_option_2	Withdraw and process my emotions privately.	\N	2025-08-16 13:57:20.575367
69	en_US	questions.q5_option_3	Try to understand their perspective before reacting.	\N	2025-08-16 13:57:20.575592
70	en_US	questions.q5_option_4	Tend to forgive quickly and move forward.	\N	2025-08-16 13:57:20.575796
71	en_US	personality_types.communicator.title	The Communicator	\N	2025-08-16 13:57:20.576003
73	en_US	personality_types.communicator.personality_advice_1	Practice active listening to balance your directness with empathy.	\N	2025-08-16 13:57:20.576443
74	en_US	personality_types.communicator.personality_advice_2	Remember that not everyone processes emotions as quickly as you do.	\N	2025-08-16 13:57:20.576636
75	en_US	personality_types.communicator.personality_advice_3	Your honesty is a gift, but timing and delivery matter.	\N	2025-08-16 13:57:20.576846
76	en_US	personality_types.communicator.personality_advice_4	Create safe spaces for others to share their thoughts without judgment.	\N	2025-08-16 13:57:20.577043
77	en_US	personality_types.communicator.personality_advice_5	Use your communication skills to build bridges, not walls.	\N	2025-08-16 13:57:20.57742
78	en_US	personality_types.communicator.relationship_advice_1	Ask open-ended questions to encourage deeper conversations.	\N	2025-08-16 13:57:20.577606
2	en_US	common.error	Error	\N	2025-08-16 13:57:20.557411
3	en_US	common.success	Success	\N	2025-08-16 13:57:20.557824
83	en_US	personality_types.harmonizer.title	The Harmonizer	\N	2025-08-16 13:57:20.578834
84	en_US	personality_types.harmonizer.description	You excel at creating balance and peace in relationships. Your ability to see multiple perspectives makes you a natural mediator and supportive partner.	\N	2025-08-16 13:57:20.57903
85	en_US	personality_types.harmonizer.personality_advice_1	Don't sacrifice your own needs for the sake of keeping peace.	\N	2025-08-16 13:57:20.579223
86	en_US	personality_types.harmonizer.personality_advice_2	Practice expressing your preferences, even when they might create minor conflict.	\N	2025-08-16 13:57:20.579405
87	en_US	personality_types.harmonizer.personality_advice_3	Your empathy is a strength, but remember to set healthy boundaries.	\N	2025-08-16 13:57:20.579602
88	en_US	personality_types.harmonizer.personality_advice_4	Trust that healthy relationships can handle some disagreement.	\N	2025-08-16 13:57:20.579855
89	en_US	personality_types.harmonizer.personality_advice_5	Value your peacemaking abilities while honoring your authentic self.	\N	2025-08-16 13:57:20.580044
90	en_US	personality_types.harmonizer.relationship_advice_1	Communicate your needs clearly, even if it feels uncomfortable at first.	\N	2025-08-16 13:57:20.580234
91	en_US	personality_types.harmonizer.relationship_advice_2	Practice saying 'no' when requests don't align with your values or capacity.	\N	2025-08-16 13:57:20.580418
92	en_US	personality_types.harmonizer.relationship_advice_3	Look for partners who value compromise as much as you do.	\N	2025-08-16 13:57:20.580621
93	en_US	personality_types.harmonizer.relationship_advice_4	Address small issues before they become major problems.	\N	2025-08-16 13:57:20.580812
94	en_US	personality_types.harmonizer.relationship_advice_5	Celebrate the strength in your adaptability and peacemaking skills.	\N	2025-08-16 13:57:20.581004
95	en_US	personality_types.independent.title	The Independent	\N	2025-08-16 13:57:20.581214
96	en_US	personality_types.independent.description	You value autonomy and personal growth in relationships. You bring a strong sense of self and clear boundaries to your connections.	\N	2025-08-16 13:57:20.581408
97	en_US	personality_types.independent.personality_advice_1	Balance independence with vulnerability for deeper connections.	\N	2025-08-16 13:57:20.581596
98	en_US	personality_types.independent.personality_advice_2	Share your internal process with trusted others.	\N	2025-08-16 13:57:20.58178
99	en_US	personality_types.independent.personality_advice_3	Recognize when self-reliance becomes a barrier to intimacy.	\N	2025-08-16 13:57:20.581972
100	en_US	personality_types.independent.personality_advice_4	Practice asking for help when needed.	\N	2025-08-16 13:57:20.582164
101	en_US	personality_types.independent.personality_advice_5	Your self-sufficiency is a strength that brings stability to relationships.	\N	2025-08-16 13:57:20.582342
102	en_US	personality_types.independent.relationship_advice_1	Communicate your need for space proactively, not reactively.	\N	2025-08-16 13:57:20.582531
103	en_US	personality_types.independent.relationship_advice_2	Create rituals of connection to balance your independence.	\N	2025-08-16 13:57:20.582702
104	en_US	personality_types.independent.relationship_advice_3	Look for partners who respect your autonomy without feeling threatened.	\N	2025-08-16 13:57:20.582892
105	en_US	personality_types.independent.relationship_advice_4	Invest in interdependence alongside independence.	\N	2025-08-16 13:57:20.583094
106	en_US	personality_types.independent.relationship_advice_5	Share your growth journey with those closest to you.	\N	2025-08-16 13:57:20.583314
107	en_US	personality_types.loyalist.title	The Loyalist	\N	2025-08-16 13:57:20.58358
108	en_US	personality_types.loyalist.description	You prioritize trust and commitment in relationships. Your reliability and dedication create a secure foundation for deep connections.	\N	2025-08-16 13:57:20.583784
109	en_US	personality_types.loyalist.personality_advice_1	Ensure your loyalty to others doesn't override loyalty to yourself.	\N	2025-08-16 13:57:20.58398
110	en_US	personality_types.loyalist.personality_advice_2	Recognize that trust can be rebuilt after small breaches.	\N	2025-08-16 13:57:20.584168
111	en_US	personality_types.loyalist.personality_advice_3	Balance consistency with spontaneity and growth.	\N	2025-08-16 13:57:20.584376
112	en_US	personality_types.loyalist.personality_advice_4	Allow yourself and others room to evolve and change.	\N	2025-08-16 13:57:20.584732
113	en_US	personality_types.loyalist.personality_advice_5	Your steadfastness provides valuable security in relationships.	\N	2025-08-16 13:57:20.58492
114	en_US	personality_types.loyalist.relationship_advice_1	Communicate your expectations clearly to avoid disappointment.	\N	2025-08-16 13:57:20.58512
115	en_US	personality_types.loyalist.relationship_advice_2	Practice forgiveness for minor transgressions.	\N	2025-08-16 13:57:20.585306
116	en_US	personality_types.loyalist.relationship_advice_3	Look for partners who value commitment as much as you do.	\N	2025-08-16 13:57:20.585497
117	en_US	personality_types.loyalist.relationship_advice_4	Build trust through small, consistent actions over time.	\N	2025-08-16 13:57:20.585679
118	en_US	personality_types.loyalist.relationship_advice_5	Create space for both security and adventure in your relationships.	\N	2025-08-16 13:57:20.585858
119	en_US	admin.title	Admin Dashboard	\N	2025-08-16 13:57:20.586158
120	en_US	admin.stats	Statistics	\N	2025-08-16 13:57:20.586357
121	en_US	admin.users	Users	\N	2025-08-16 13:57:20.586553
122	en_US	admin.quizzes	Quizzes	\N	2025-08-16 13:57:20.586728
123	en_US	admin.results	Results	\N	2025-08-16 13:57:20.586895
124	en_US	admin.payments	Payments	\N	2025-08-16 13:57:20.587066
125	en_US	errors.generic	Something went wrong. Please try again.	\N	2025-08-16 13:57:20.587244
126	en_US	errors.network	Network error. Please check your connection.	\N	2025-08-16 13:57:20.587431
127	en_US	errors.validation	Please fill in all required fields.	\N	2025-08-16 13:57:20.587615
128	en_US	errors.payment	Payment processing failed. Please try again.	\N	2025-08-16 13:57:20.587808
129	en_US	errors.quiz	Failed to calculate quiz results. Please try again.	\N	2025-08-16 13:57:20.588
130	pt_BR	common.loading	Carregando...	\N	2025-08-16 13:57:20.588399
131	pt_BR	common.error	Erro	\N	2025-08-16 13:57:20.588593
132	pt_BR	common.success	Sucesso	\N	2025-08-16 13:57:20.588768
133	pt_BR	common.continue	Continuar	\N	2025-08-16 13:57:20.58895
134	pt_BR	common.back	Voltar	\N	2025-08-16 13:57:20.589127
135	pt_BR	common.next	Próximo	\N	2025-08-16 13:57:20.589306
136	pt_BR	common.submit	Enviar	\N	2025-08-16 13:57:20.589478
137	pt_BR	common.cancel	Cancelar	\N	2025-08-16 13:57:20.589675
138	pt_BR	common.close	Fechar	\N	2025-08-16 13:57:20.589855
82	en_US	personality_types.communicator.relationship_advice_5	Use 'I' statements to express your needs without making others defensive.	\N	2025-08-16 13:57:20.57864
142	pt_BR	common.add	Adicionar	\N	2025-08-16 13:57:20.5906
143	pt_BR	common.yes	Sim	\N	2025-08-16 13:57:20.590767
144	pt_BR	common.no	Não	\N	2025-08-16 13:57:20.590947
146	pt_BR	quiz.subtitle	Descubra Seu Estilo de Relacionamento	\N	2025-08-16 13:57:20.591307
148	pt_BR	quiz.startButton	Iniciar Quiz	\N	2025-08-16 13:57:20.591675
149	pt_BR	quiz.question	Pergunta	\N	2025-08-16 13:57:20.591856
150	pt_BR	quiz.of	de	\N	2025-08-16 13:57:20.592039
151	pt_BR	quiz.previousQuestion	Pergunta Anterior	\N	2025-08-16 13:57:20.592208
152	pt_BR	quiz.nextQuestion	Próxima Pergunta	\N	2025-08-16 13:57:20.592379
153	pt_BR	quiz.calculateResults	Calcular Resultados	\N	2025-08-16 13:57:20.592559
154	pt_BR	quiz.retakeQuiz	Refazer Quiz	\N	2025-08-16 13:57:20.592745
155	pt_BR	quiz.shareResults	Compartilhar Resultados	\N	2025-08-16 13:57:20.592928
156	pt_BR	results.title	Seus Resultados de Personalidade para Relacionamentos	\N	2025-08-16 13:57:20.593121
157	pt_BR	results.personalityInsights	Insights de Personalidade	\N	2025-08-16 13:57:20.59352
158	pt_BR	results.relationshipTips	Dicas para Melhorar Relacionamentos	\N	2025-08-16 13:57:20.593701
159	pt_BR	results.shareOnFacebook	Compartilhar no Facebook	\N	2025-08-16 13:57:20.593864
160	pt_BR	results.takeQuizAgain	Refazer Quiz	\N	2025-08-16 13:57:20.594017
161	pt_BR	results.yourType	Seu Tipo	\N	2025-08-16 13:57:20.594203
162	pt_BR	results.score	Pontuação	\N	2025-08-16 13:57:20.594441
163	pt_BR	results.maxScore	Pontuação Máxima	\N	2025-08-16 13:57:20.594618
164	pt_BR	results.percentage	Porcentagem	\N	2025-08-16 13:57:20.594831
165	pt_BR	payment.title	Complete Sua Compra	\N	2025-08-16 13:57:20.595007
166	pt_BR	payment.description	Pagamento seguro para desbloquear seus insights personalizados de relacionamento	\N	2025-08-16 13:57:20.595181
167	pt_BR	payment.amount	Valor	\N	2025-08-16 13:57:20.595357
170	pt_BR	payment.failed	Pagamento falhou	\N	2025-08-16 13:57:20.596065
169	pt_BR	payment.processing_message	O pagamento está sendo processado. Aguarde...	\N	2025-08-16 13:57:20.595813
264	es_ES	quiz.submit_button	Enviar	\N	2025-08-16 13:57:20.642515
168	pt_BR	payment.processing	Processando...	\N	2025-08-16 13:57:20.59553
172	pt_BR	payment.success	Pagamento realizado com sucesso! Seus resultados estão sendo preparados...	\N	2025-08-16 13:57:20.596655
173	pt_BR	payment.save_success	Seus resultados do quiz foram salvos com sucesso!	\N	2025-08-16 13:57:20.596876
174	pt_BR	payment.save_warning	Pagamento realizado com sucesso, mas houve um problema ao salvar seus resultados. Entre em contato com o suporte se necessário.	\N	2025-08-16 13:57:20.59711
175	pt_BR	questions.q1	Como você normalmente lida com conflitos em relacionamentos?	\N	2025-08-16 13:57:20.597334
176	pt_BR	questions.q1_option_1	Prefiro abordar questões imediatamente e diretamente.	\N	2025-08-16 13:57:20.597527
177	pt_BR	questions.q1_option_2	Preciso de tempo para processar antes de discutir o problema.	\N	2025-08-16 13:57:20.59775
178	pt_BR	questions.q1_option_3	Tento encontrar um compromisso que funcione para todos.	\N	2025-08-16 13:57:20.59796
179	pt_BR	questions.q1_option_4	Às vezes evito confrontos para manter a paz.	\N	2025-08-16 13:57:20.598166
180	pt_BR	questions.q2	O que é mais importante para você em um relacionamento?	\N	2025-08-16 13:57:20.598363
181	pt_BR	questions.q2_option_1	Comunicação aberta e honesta.	\N	2025-08-16 13:57:20.598549
182	pt_BR	questions.q2_option_2	Confiança e lealdade.	\N	2025-08-16 13:57:20.598757
183	pt_BR	questions.q2_option_3	Apoio emocional e compreensão.	\N	2025-08-16 13:57:20.59895
184	pt_BR	questions.q2_option_4	Crescimento e experiências compartilhadas.	\N	2025-08-16 13:57:20.599146
185	pt_BR	questions.q3	Como você expressa afeto ao seu parceiro?	\N	2025-08-16 13:57:20.599347
186	pt_BR	questions.q3_option_1	Através de toque físico e proximidade.	\N	2025-08-16 13:57:20.599546
187	pt_BR	questions.q3_option_2	Dando presentes ou fazendo atos de serviço atenciosos.	\N	2025-08-16 13:57:20.599735
188	pt_BR	questions.q3_option_3	Com palavras de afirmação e elogios.	\N	2025-08-16 13:57:20.599938
189	pt_BR	questions.q3_option_4	Passando tempo de qualidade juntos.	\N	2025-08-16 13:57:20.600125
190	pt_BR	questions.q4	Ao tomar decisões importantes com um parceiro, você prefere:	\N	2025-08-16 13:57:20.600309
191	pt_BR	questions.q4_option_1	Assumir a liderança e tomar decisões com confiança.	\N	2025-08-16 13:57:20.60051
192	pt_BR	questions.q4_option_2	Discutir todas as opções minuciosamente antes de decidir juntos.	\N	2025-08-16 13:57:20.600716
193	pt_BR	questions.q4_option_3	Considerar as necessidades do seu parceiro primeiro.	\N	2025-08-16 13:57:20.600899
194	pt_BR	questions.q4_option_4	Ser flexível e seguir o fluxo.	\N	2025-08-16 13:57:20.601071
195	pt_BR	questions.q5	Como você reage quando se sente emocionalmente ferido por alguém próximo?	\N	2025-08-16 13:57:20.601258
196	pt_BR	questions.q5_option_1	Expresso meus sentimentos imediatamente e diretamente.	\N	2025-08-16 13:57:20.601424
197	pt_BR	questions.q5_option_2	Me retiro e processo minhas emoções privadamente.	\N	2025-08-16 13:57:20.601747
198	pt_BR	questions.q5_option_3	Tento entender a perspectiva deles antes de reagir.	\N	2025-08-16 13:57:20.601955
199	pt_BR	questions.q5_option_4	Tendo a perdoar rapidamente e seguir em frente.	\N	2025-08-16 13:57:20.602122
200	pt_BR	personality_types.communicator.title	O Comunicador	\N	2025-08-16 13:57:20.602297
202	pt_BR	personality_types.communicator.personality_advice_1	Pratique escuta ativa para equilibrar sua franqueza com empatia.	\N	2025-08-16 13:57:20.602638
203	pt_BR	personality_types.communicator.personality_advice_2	Lembre-se de que nem todos processam emoções tão rapidamente quanto você.	\N	2025-08-16 13:57:20.602823
204	pt_BR	personality_types.communicator.personality_advice_3	Sua honestidade é um presente, mas o momento e a forma de entrega importam.	\N	2025-08-16 13:57:20.602996
205	pt_BR	personality_types.communicator.personality_advice_4	Crie espaços seguros para outros compartilharem seus pensamentos sem julgamento.	\N	2025-08-16 13:57:20.603165
206	pt_BR	personality_types.communicator.personality_advice_5	Use suas habilidades de comunicação para construir pontes, não muros.	\N	2025-08-16 13:57:20.603353
207	pt_BR	personality_types.communicator.relationship_advice_1	Faça perguntas abertas para encorajar conversas mais profundas.	\N	2025-08-16 13:57:20.60353
208	pt_BR	personality_types.communicator.relationship_advice_2	Pratique paciência quando outros precisam de tempo para articular seus sentimentos.	\N	2025-08-16 13:57:20.603732
265	es_ES	quiz.loading	Cargando...	\N	2025-08-16 13:57:20.643135
171	pt_BR	payment.button_pay	Pagar	\N	2025-08-16 13:57:20.596306
140	pt_BR	common.delete	Excluir	\N	2025-08-16 13:57:20.590234
141	pt_BR	common.edit	Editar	\N	2025-08-16 13:57:20.59043
212	pt_BR	personality_types.harmonizer.title	O Harmonizador	\N	2025-08-16 13:57:20.607508
214	pt_BR	personality_types.harmonizer.personality_advice_1	Não sacrifique suas próprias necessidades em prol de manter a paz.	\N	2025-08-16 13:57:20.60929
215	pt_BR	personality_types.harmonizer.personality_advice_2	Pratique expressar suas preferências, mesmo quando podem criar pequenos conflitos.	\N	2025-08-16 13:57:20.609869
216	pt_BR	personality_types.harmonizer.personality_advice_3	Sua empatia é uma força, mas lembre-se de estabelecer limites saudáveis.	\N	2025-08-16 13:57:20.610317
217	pt_BR	personality_types.harmonizer.personality_advice_4	Confie que relacionamentos saudáveis podem lidar com algum desentendimento.	\N	2025-08-16 13:57:20.610939
218	pt_BR	personality_types.harmonizer.personality_advice_5	Valorize suas habilidades de pacificação enquanto honra seu eu autêntico.	\N	2025-08-16 13:57:20.61139
219	pt_BR	personality_types.harmonizer.relationship_advice_1	Comunique suas necessidades claramente, mesmo se parecer desconfortável no início.	\N	2025-08-16 13:57:20.611829
220	pt_BR	personality_types.harmonizer.relationship_advice_2	Pratique dizer 'não' quando pedidos não se alinham com seus valores ou capacidade.	\N	2025-08-16 13:57:20.612379
221	pt_BR	personality_types.harmonizer.relationship_advice_3	Procure parceiros que valorizem compromisso tanto quanto você.	\N	2025-08-16 13:57:20.613934
222	pt_BR	personality_types.harmonizer.relationship_advice_4	Aborde pequenas questões antes que se tornem problemas maiores.	\N	2025-08-16 13:57:20.615121
290	es_ES	quiz.questions.q5_option_4	Su pasión y energía	\N	2025-08-16 13:57:20.650166
223	pt_BR	personality_types.harmonizer.relationship_advice_5	Celebre a força em sua adaptabilidade e habilidades de pacificação.	\N	2025-08-16 13:57:20.615604
224	pt_BR	personality_types.independent.title	O Independente	\N	2025-08-16 13:57:20.616329
225	pt_BR	personality_types.independent.description	Você valoriza autonomia e crescimento pessoal em relacionamentos. Você traz um forte senso de si mesmo e limites claros para suas conexões.	\N	2025-08-16 13:57:20.616964
226	pt_BR	personality_types.independent.personality_advice_1	Equilibre independência com vulnerabilidade para conexões mais profundas.	\N	2025-08-16 13:57:20.617562
227	pt_BR	personality_types.independent.personality_advice_2	Compartilhe seu processo interno com pessoas de confiança.	\N	2025-08-16 13:57:20.61825
228	pt_BR	personality_types.independent.personality_advice_3	Reconheça quando a autossuficiência se torna uma barreira para a intimidade.	\N	2025-08-16 13:57:20.618806
229	pt_BR	personality_types.independent.personality_advice_4	Pratique pedir ajuda quando necessário.	\N	2025-08-16 13:57:20.619236
230	pt_BR	personality_types.independent.personality_advice_5	Sua autossuficiência é uma força que traz estabilidade aos relacionamentos.	\N	2025-08-16 13:57:20.619632
231	pt_BR	personality_types.independent.relationship_advice_1	Comunique sua necessidade de espaço proativamente, não reativamente.	\N	2025-08-16 13:57:20.620093
232	pt_BR	personality_types.independent.relationship_advice_2	Crie rituais de conexão para equilibrar sua independência.	\N	2025-08-16 13:57:20.620818
233	pt_BR	personality_types.independent.relationship_advice_3	Procure parceiros que respeitem sua autonomia sem se sentirem ameaçados.	\N	2025-08-16 13:57:20.621296
234	pt_BR	personality_types.independent.relationship_advice_4	Invista em interdependência junto com independência.	\N	2025-08-16 13:57:20.621833
235	pt_BR	personality_types.independent.relationship_advice_5	Compartilhe sua jornada de crescimento com aqueles mais próximos de você.	\N	2025-08-16 13:57:20.622895
236	pt_BR	personality_types.loyalist.title	O Leal	\N	2025-08-16 13:57:20.623434
237	pt_BR	personality_types.loyalist.description	Você prioriza confiança e compromisso em relacionamentos. Sua confiabilidade e dedicação criam uma base segura para conexões profundas.	\N	2025-08-16 13:57:20.623798
238	pt_BR	personality_types.loyalist.personality_advice_1	Certifique-se de que sua lealdade aos outros não substitua a lealdade a si mesmo.	\N	2025-08-16 13:57:20.624246
239	pt_BR	personality_types.loyalist.personality_advice_2	Reconheça que a confiança pode ser reconstruída após pequenas violações.	\N	2025-08-16 13:57:20.62518
240	pt_BR	personality_types.loyalist.personality_advice_3	Equilibre consistência com espontaneidade e crescimento.	\N	2025-08-16 13:57:20.625951
241	pt_BR	personality_types.loyalist.personality_advice_4	Permita a si mesmo e aos outros espaço para evoluir e mudar.	\N	2025-08-16 13:57:20.627136
242	pt_BR	personality_types.loyalist.personality_advice_5	Sua firmeza fornece segurança valiosa em relacionamentos.	\N	2025-08-16 13:57:20.627553
243	pt_BR	personality_types.loyalist.relationship_advice_1	Comunique suas expectativas claramente para evitar decepções.	\N	2025-08-16 13:57:20.627907
244	pt_BR	personality_types.loyalist.relationship_advice_2	Pratique perdão para pequenas transgressões.	\N	2025-08-16 13:57:20.628265
245	pt_BR	personality_types.loyalist.relationship_advice_3	Procure parceiros que valorizem compromisso tanto quanto você.	\N	2025-08-16 13:57:20.628579
246	pt_BR	personality_types.loyalist.relationship_advice_4	Construa confiança através de pequenas ações consistentes ao longo do tempo.	\N	2025-08-16 13:57:20.628899
247	pt_BR	personality_types.loyalist.relationship_advice_5	Crie espaço tanto para segurança quanto para aventura em seus relacionamentos.	\N	2025-08-16 13:57:20.629603
248	pt_BR	admin.title	Painel Administrativo	\N	2025-08-16 13:57:20.630322
249	pt_BR	admin.stats	Estatísticas	\N	2025-08-16 13:57:20.631251
250	pt_BR	admin.users	Usuários	\N	2025-08-16 13:57:20.63195
251	pt_BR	admin.quizzes	Quizzes	\N	2025-08-16 13:57:20.632403
252	pt_BR	admin.results	Resultados	\N	2025-08-16 13:57:20.633136
253	pt_BR	admin.payments	Pagamentos	\N	2025-08-16 13:57:20.633718
254	pt_BR	errors.generic	Algo deu errado. Tente novamente.	\N	2025-08-16 13:57:20.63446
255	pt_BR	errors.network	Erro de rede. Verifique sua conexão.	\N	2025-08-16 13:57:20.635244
256	pt_BR	errors.validation	Por favor, preencha todos os campos obrigatórios.	\N	2025-08-16 13:57:20.636245
257	pt_BR	errors.payment	Falha no processamento do pagamento. Tente novamente.	\N	2025-08-16 13:57:20.636687
258	pt_BR	errors.quiz	Falha ao calcular resultados do quiz. Tente novamente.	\N	2025-08-16 13:57:20.637213
259	es_ES	quiz.title	Quiz de Personalidad en Relaciones	\N	2025-08-16 13:57:20.638932
260	es_ES	quiz.description	Descubre tu tipo de personalidad en las relaciones	\N	2025-08-16 13:57:20.639662
263	es_ES	quiz.previous_button	Anterior	\N	2025-08-16 13:57:20.641982
261	es_ES	quiz.start_button	Comenzar Quiz	\N	2025-08-16 13:57:20.640503
262	es_ES	quiz.next_button	Siguiente	\N	2025-08-16 13:57:20.641359
210	pt_BR	personality_types.communicator.relationship_advice_4	Equilibre falar com ouvir em seus relacionamentos.	\N	2025-08-16 13:57:20.604133
211	pt_BR	personality_types.communicator.relationship_advice_5	Use declarações em primeira pessoa para expressar suas necessidades sem deixar outros na defensiva.	\N	2025-08-16 13:57:20.604692
270	es_ES	quiz.questions.q1_option_4	Ir a un concierto o evento en vivo	\N	2025-08-16 13:57:20.64556
271	es_ES	quiz.questions.q2	¿Cómo manejas los conflictos en tu relación?	\N	2025-08-16 13:57:20.646222
272	es_ES	quiz.questions.q2_option_1	Hablo inmediatamente sobre el problema	\N	2025-08-16 13:57:20.646569
273	es_ES	quiz.questions.q2_option_2	Tomo tiempo para pensar antes de hablar	\N	2025-08-16 13:57:20.646895
274	es_ES	quiz.questions.q2_option_3	Trato de evitar la confrontación	\N	2025-08-16 13:57:20.647142
275	es_ES	quiz.questions.q2_option_4	Busco un compromiso que funcione para ambos	\N	2025-08-16 13:57:20.647364
276	es_ES	quiz.questions.q3	¿Qué es lo más importante para ti en una relación?	\N	2025-08-16 13:57:20.647557
277	es_ES	quiz.questions.q3_option_1	Comunicación abierta y honesta	\N	2025-08-16 13:57:20.647732
278	es_ES	quiz.questions.q3_option_2	Confianza y lealtad mutua	\N	2025-08-16 13:57:20.647898
279	es_ES	quiz.questions.q3_option_3	Diversión y aventura compartida	\N	2025-08-16 13:57:20.648056
280	es_ES	quiz.questions.q3_option_4	Apoyo emocional y comprensión	\N	2025-08-16 13:57:20.648229
281	es_ES	quiz.questions.q4	¿Cómo expresas tu amor?	\N	2025-08-16 13:57:20.648404
282	es_ES	quiz.questions.q4_option_1	A través de palabras de afirmación	\N	2025-08-16 13:57:20.648624
283	es_ES	quiz.questions.q4_option_2	Con actos de servicio	\N	2025-08-16 13:57:20.648867
284	es_ES	quiz.questions.q4_option_3	Dando regalos significativos	\N	2025-08-16 13:57:20.649032
285	es_ES	quiz.questions.q4_option_4	Con contacto físico y cercanía	\N	2025-08-16 13:57:20.649193
286	es_ES	quiz.questions.q5	¿Qué te atrae más de una persona?	\N	2025-08-16 13:57:20.649348
287	es_ES	quiz.questions.q5_option_1	Su inteligencia y conversación	\N	2025-08-16 13:57:20.649529
288	es_ES	quiz.questions.q5_option_2	Su sentido del humor	\N	2025-08-16 13:57:20.649706
289	es_ES	quiz.questions.q5_option_3	Su estabilidad emocional	\N	2025-08-16 13:57:20.649937
291	es_ES	personality_types.romantic.title	El Romántico	\N	2025-08-16 13:57:20.650386
293	es_ES	personality_types.romantic.advice	Mantén el equilibrio entre romance y realidad. Comunica tus necesidades emocionales claramente y aprecia los pequeños gestos de amor en la vida cotidiana.	\N	2025-08-16 13:57:20.650839
294	es_ES	personality_types.adventurer.title	El Aventurero	\N	2025-08-16 13:57:20.651021
295	es_ES	personality_types.adventurer.description	Eres espontáneo y buscas emoción en tu relación. Valoras la libertad, la aventura y las nuevas experiencias compartidas con tu pareja.	\N	2025-08-16 13:57:20.651248
296	es_ES	personality_types.adventurer.advice	Encuentra una pareja que comparta tu amor por la aventura, pero también aprende a valorar los momentos tranquilos juntos. La estabilidad puede coexistir con la emoción.	\N	2025-08-16 13:57:20.651552
297	es_ES	personality_types.nurturer.title	El Cuidador	\N	2025-08-16 13:57:20.651765
298	es_ES	personality_types.nurturer.description	Eres naturalmente cariñoso y te enfocas en cuidar y apoyar a tu pareja. Tu felicidad viene de hacer felices a otros y crear un ambiente amoroso.	\N	2025-08-16 13:57:20.65196
299	es_ES	personality_types.nurturer.advice	Recuerda cuidarte a ti mismo también. Establece límites saludables y asegúrate de que tus propias necesidades también sean atendidas en la relación.	\N	2025-08-16 13:57:20.652159
300	es_ES	personality_types.communicator.title	El Comunicador	\N	2025-08-16 13:57:20.652346
301	es_ES	personality_types.communicator.description	Valoras la comunicación abierta y honesta por encima de todo. Crees que los problemas se pueden resolver hablando y buscas una conexión intelectual profunda.	\N	2025-08-16 13:57:20.652541
302	es_ES	personality_types.communicator.advice	Continúa priorizando la comunicación, pero también aprende a escuchar sin juzgar. A veces tu pareja necesita ser escuchada más que aconsejada.	\N	2025-08-16 13:57:20.652955
303	es_ES	payment.title	Obtén tu Resultado Completo	\N	2025-08-16 13:57:20.653224
304	es_ES	payment.description	Desbloquea tu análisis detallado de personalidad y consejos personalizados	\N	2025-08-16 13:57:20.653438
305	es_ES	payment.price	Solo $4.99	\N	2025-08-16 13:57:20.653617
306	es_ES	payment.features.detailed_analysis	Análisis detallado de personalidad	\N	2025-08-16 13:57:20.653828
307	es_ES	payment.features.personalized_advice	Consejos personalizados para relaciones	\N	2025-08-16 13:57:20.654012
308	es_ES	payment.features.compatibility_guide	Guía de compatibilidad	\N	2025-08-16 13:57:20.6542
309	es_ES	payment.features.relationship_tips	Consejos para mejorar tu relación	\N	2025-08-16 13:57:20.654394
310	es_ES	payment.pay_button	Pagar Ahora	\N	2025-08-16 13:57:20.65457
311	es_ES	payment.processing	Procesando pago...	\N	2025-08-16 13:57:20.654749
312	es_ES	payment.success	¡Pago exitoso! Redirigiendo a tus resultados...	\N	2025-08-16 13:57:20.654931
313	es_ES	payment.error	Error en el pago. Por favor, inténtalo de nuevo.	\N	2025-08-16 13:57:20.655117
314	es_ES	common.loading	Cargando...	\N	2025-08-16 13:57:20.655426
315	es_ES	common.error	Error	\N	2025-08-16 13:57:20.655755
316	es_ES	common.success	Éxito	\N	2025-08-16 13:57:20.65605
317	es_ES	common.cancel	Cancelar	\N	2025-08-16 13:57:20.65626
318	es_ES	common.confirm	Confirmar	\N	2025-08-16 13:57:20.656707
319	es_ES	common.close	Cerrar	\N	2025-08-16 13:57:20.657347
320	es_ES	common.save	Guardar	\N	2025-08-16 13:57:20.657691
321	es_ES	common.edit	Editar	\N	2025-08-16 13:57:20.657974
322	es_ES	common.delete	Eliminar	\N	2025-08-16 13:57:20.65822
324	es_ES	common.continue	Continuar	\N	2025-08-16 13:57:20.658636
325	es_ES	common.finish	Finalizar	\N	2025-08-16 13:57:20.658966
326	es_ES	common.email_placeholder	Ingresa tu email	\N	2025-08-16 13:57:20.659223
327	es_ES	common.required_field	Este campo es obligatorio	\N	2025-08-16 13:57:20.659432
328	es_ES	common.invalid_email	Email inválido	\N	2025-08-16 13:57:20.65963
323	es_ES	common.back	Anterior	\N	2025-08-16 13:57:20.658445
1	en_US	common.loading	Loading...	\N	2025-08-16 13:57:20.556379
14	en_US	common.yes	Yes	\N	2025-08-16 13:57:20.561039
18	en_US	quiz.description	Take our comprehensive quiz to understand your relationship personality and get personalized advice for building stronger connections.	\N	2025-08-16 13:57:20.562001
66	en_US	questions.q5	How do you react when you feel emotionally hurt by someone close to you?	\N	2025-08-16 13:57:20.57473
267	es_ES	quiz.questions.q1_option_1	Una cena romántica en casa con velas	\N	2025-08-16 13:57:20.644145
268	es_ES	quiz.questions.q1_option_2	Salir a un restaurante elegante	\N	2025-08-16 13:57:20.644523
1313	en_US	quiz.finish_quiz	Finish Quiz	\N	2025-08-18 12:41:05.766781
1314	pt_BR	quiz.finish_quiz	Finalizar Quiz	\N	2025-08-18 12:41:05.766781
1315	es_ES	quiz.finish_quiz	Finalizar Quiz	\N	2025-08-18 12:41:05.766781
72	en_US	personality_types.communicator.description	You value open and honest communication in relationships. You're direct about your needs and feelings, which helps prevent misunderstandings.	\N	2025-08-16 13:57:20.576197
79	en_US	personality_types.communicator.relationship_advice_2	Practice patience when others need time to articulate their feelings.	\N	2025-08-16 13:57:20.577787
80	en_US	personality_types.communicator.relationship_advice_3	Look for partners who appreciate your directness and can match your communication style.	\N	2025-08-16 13:57:20.578254
81	en_US	personality_types.communicator.relationship_advice_4	Balance talking with listening in your relationships.	\N	2025-08-16 13:57:20.578442
139	pt_BR	common.save	Salvar	\N	2025-08-16 13:57:20.590025
145	pt_BR	quiz.title	Quiz de Personalidade para Relacionamentos	\N	2025-08-16 13:57:20.591116
147	pt_BR	quiz.description	Faça nosso quiz abrangente para entender sua personalidade em relacionamentos e receba conselhos personalizados para construir conexões mais fortes.	\N	2025-08-16 13:57:20.59149
201	pt_BR	personality_types.communicator.description	Você valoriza comunicação aberta e honesta em relacionamentos. Você é direto sobre suas necessidades e sentimentos, o que ajuda a prevenir mal-entendidos.	\N	2025-08-16 13:57:20.602464
209	pt_BR	personality_types.communicator.relationship_advice_3	Procure parceiros que apreciem sua franqueza e possam corresponder ao seu estilo de comunicação.	\N	2025-08-16 13:57:20.603915
213	pt_BR	personality_types.harmonizer.description	Você se destaca em criar equilíbrio e paz em relacionamentos. Sua capacidade de ver múltiplas perspectivas faz de você um mediador natural e parceiro solidário.	\N	2025-08-16 13:57:20.6085
266	es_ES	quiz.questions.q1	¿Cómo prefieres pasar una noche perfecta con tu pareja?	\N	2025-08-16 13:57:20.643601
269	es_ES	quiz.questions.q1_option_3	Ver una película juntos en el sofá	\N	2025-08-16 13:57:20.64483
292	es_ES	personality_types.romantic.description	Eres una persona que valora profundamente la conexión emocional y los gestos románticos. Buscas una relación llena de amor, comprensión y momentos especiales.	\N	2025-08-16 13:57:20.650582
1316	en_US	common.reload_page	Reload Page	\N	2025-08-18 12:41:25.73165
1317	pt_BR	common.reload_page	Recarregar Página	\N	2025-08-18 12:41:25.73165
1318	es_ES	common.reload_page	Recargar Página	\N	2025-08-18 12:41:25.73165
1319	en_US	errors.quiz_not_loaded	Quiz data not loaded. Please refresh the page.	\N	2025-08-18 12:41:25.73165
1320	pt_BR	errors.quiz_not_loaded	Dados do quiz não carregados. Por favor, atualize a página.	\N	2025-08-18 12:41:25.73165
1321	es_ES	errors.quiz_not_loaded	Datos del quiz no cargados. Por favor, actualiza la página.	\N	2025-08-18 12:41:25.73165
1322	en_US	errors.payment_init_failed	Failed to initialize payment system. Please refresh the page.	\N	2025-08-18 12:41:25.73165
1323	pt_BR	errors.payment_init_failed	Falha ao inicializar sistema de pagamento. Por favor, atualize a página.	\N	2025-08-18 12:41:25.73165
1324	es_ES	errors.payment_init_failed	Error al inicializar sistema de pago. Por favor, actualiza la página.	\N	2025-08-18 12:41:25.73165
1325	en_US	payment.processing_wait	Payment is processing. Please wait...	\N	2025-08-18 12:41:34.600051
1327	es_ES	payment.processing_wait	Pago procesándose. Por favor, espera...	\N	2025-08-18 12:41:34.600051
1328	en_US	payment.success_saving	Payment successful! Saving your results...	\N	2025-08-18 12:41:34.600051
1330	es_ES	payment.success_saving	¡Pago exitoso! Guardando tus resultados...	\N	2025-08-18 12:41:34.600051
1331	en_US	payment.success_save_failed	Payment successful, but failed to save results. Please contact support.	\N	2025-08-18 12:41:34.600051
1332	pt_BR	payment.success_save_failed	Pagamento realizado, mas falha ao salvar resultados. Entre em contato com o suporte.	\N	2025-08-18 12:41:34.600051
1333	es_ES	payment.success_save_failed	Pago exitoso, pero error al guardar resultados. Contacta soporte.	\N	2025-08-18 12:41:34.600051
1334	en_US	payment.pay	Pay	\N	2025-08-18 12:41:41.280276
1335	pt_BR	payment.pay	Pagar	\N	2025-08-18 12:41:41.280276
1336	es_ES	payment.pay	Pagar	\N	2025-08-18 12:41:41.280276
1337	en_US	payment.payButton	Pay	\N	2025-08-18 12:41:41.280276
1339	es_ES	payment.payButton	Pagar	\N	2025-08-18 12:41:41.280276
1338	pt_BR	payment.payButton	Pagar	\N	2025-08-18 12:41:41.280276
1326	pt_BR	payment.processing_wait	Pagamento sendo processado. Por favor, aguarde...	\N	2025-08-18 12:41:34.600051
1329	pt_BR	payment.success_saving	Pagamento realizado com sucesso! Salvando seus resultados...	\N	2025-08-18 12:41:34.600051
1341	es_ES	common.next	Siguiente	\N	2025-08-18 14:26:41.88828
1347	es_ES	common.previous	Anterior	\N	2025-08-18 15:44:34.967893
1340	es_ES	payment.button_pay	Pagar Ahora	\N	2025-08-18 14:26:41.886584
1354	es_ES	payment.submit_button	Procesar Pago	\N	2025-08-18 15:44:34.972391
1355	es_ES	common.submit	Enviar	\N	2025-08-18 15:44:34.972774
1358	es_ES	admin.payments	Payments	\N	2025-08-18 15:54:33.513757
1359	es_ES	admin.quizzes	Quizzes	\N	2025-08-18 15:54:33.515663
1360	es_ES	admin.results	Results	\N	2025-08-18 15:54:33.516302
1361	es_ES	admin.stats	Statistics	\N	2025-08-18 15:54:33.51663
1362	es_ES	admin.title	Admin Dashboard	\N	2025-08-18 15:54:33.517024
1363	es_ES	admin.users	Users	\N	2025-08-18 15:54:33.517601
1364	es_ES	common.add	Add	\N	2025-08-18 15:54:33.518163
1365	es_ES	common.no	No	\N	2025-08-18 15:54:33.518621
1366	es_ES	common.yes	Yes	\N	2025-08-18 15:54:33.519047
1367	es_ES	errors.generic	Something went wrong. Please try again.	\N	2025-08-18 15:54:33.519431
1368	es_ES	errors.network	Network Error. Please check your connection.	\N	2025-08-18 15:54:33.519662
1369	es_ES	errors.payment	Payment processing failed. Please try again.	\N	2025-08-18 15:54:33.519907
1370	es_ES	errors.quiz	Failed to calculate quiz results. Please try again.	\N	2025-08-18 15:54:33.520156
1371	es_ES	errors.validation	Please fill in all required fields.	\N	2025-08-18 15:54:33.521422
1372	es_ES	payment.amount	Amount	\N	2025-08-18 15:54:33.521673
1373	es_ES	payment.failed	Payment failed	\N	2025-08-18 15:54:33.521935
1374	es_ES	payment.processing_message	Payment is processing. Please wait...	\N	2025-08-18 15:54:33.522189
1375	es_ES	payment.save_success	Your quiz results have been saved successfully!	\N	2025-08-18 15:54:33.522515
1376	es_ES	payment.save_warning	Payment successful, but there was an issue saving your results. Please contact support if needed.	\N	2025-08-18 15:54:33.522763
1377	es_ES	personality_types.communicator.personality_advice_1	Practice active listening to balance your directness with empathy.	\N	2025-08-18 15:54:33.523007
1378	es_ES	personality_types.communicator.personality_advice_2	Remember that not everyone processes emotions as quickly as you do.	\N	2025-08-18 15:54:33.523225
1379	es_ES	personality_types.communicator.personality_advice_3	Your honesty is a gift, but timing and delivery matter.	\N	2025-08-18 15:54:33.523452
1380	es_ES	personality_types.communicator.personality_advice_4	Create safe spaces for others to share their thoughts without judgment.	\N	2025-08-18 15:54:33.523671
1381	es_ES	personality_types.communicator.personality_advice_5	Use your communication skills to build bridges, not walls.	\N	2025-08-18 15:54:33.523911
1382	es_ES	personality_types.communicator.relationship_advice_1	Ask open-ended questions to encourage deeper conversations.	\N	2025-08-18 15:54:33.524191
1383	es_ES	personality_types.communicator.relationship_advice_2	Practice patience when others need time to articulate their feelings.	\N	2025-08-18 15:54:33.524404
1384	es_ES	personality_types.communicator.relationship_advice_3	Look for partners who appreciate your directness and can match your communication style.	\N	2025-08-18 15:54:33.524615
1385	es_ES	personality_types.communicator.relationship_advice_4	Balance talking with listening in your relationships.	\N	2025-08-18 15:54:33.524824
1386	es_ES	personality_types.communicator.relationship_advice_5	Use 'I' statements to express your needs without making others defensive.	\N	2025-08-18 15:54:33.525045
1387	es_ES	personality_types.harmonizer.description	You excel at creating balance and peace in relationships. Your ability to see multiple perspectives makes you a natural mediator and supportive partner.	\N	2025-08-18 15:54:33.525278
1388	es_ES	personality_types.harmonizer.personality_advice_1	Don't sacrifice your own needs for the sake of keeping peace.	\N	2025-08-18 15:54:33.525538
1389	es_ES	personality_types.harmonizer.personality_advice_2	Practice expressing your preferences, even when they might create minor conflict.	\N	2025-08-18 15:54:33.525754
1390	es_ES	personality_types.harmonizer.personality_advice_3	Your empathy is a strength, but remember to set healthy boundaries.	\N	2025-08-18 15:54:33.525987
1391	es_ES	personality_types.harmonizer.personality_advice_4	Trust that healthy relationships can handle some disagreement.	\N	2025-08-18 15:54:33.526227
1392	es_ES	personality_types.harmonizer.personality_advice_5	Value your peacemaking abilities while honoring your authentic self.	\N	2025-08-18 15:54:33.5265
1393	es_ES	personality_types.harmonizer.relationship_advice_1	Communicate your needs clearly, even if it feels uncomfortable at first.	\N	2025-08-18 15:54:33.528138
1394	es_ES	personality_types.harmonizer.relationship_advice_2	Practice saying 'no' when requests don't align with your values or capacity.	\N	2025-08-18 15:54:33.528716
1395	es_ES	personality_types.harmonizer.relationship_advice_3	Look for partners who value compromise as much as you do.	\N	2025-08-18 15:54:33.529077
1396	es_ES	personality_types.harmonizer.relationship_advice_4	Address small issues before they become major problems.	\N	2025-08-18 15:54:33.529349
1397	es_ES	personality_types.harmonizer.relationship_advice_5	Celebrate the strength in your adaptability and peacemaking skills.	\N	2025-08-18 15:54:33.5297
1398	es_ES	personality_types.harmonizer.title	The Harmonizer	\N	2025-08-18 15:54:33.530019
1399	es_ES	personality_types.independent.description	You value autonomy and personal growth in relationships. You bring a strong sense of self and clear boundaries to your connections.	\N	2025-08-18 15:54:33.530377
1400	es_ES	personality_types.independent.personality_advice_1	Balance independence with vulnerability for deeper connections.	\N	2025-08-18 15:54:33.530669
1401	es_ES	personality_types.independent.personality_advice_2	Share your internal process with trusted others.	\N	2025-08-18 15:54:33.530993
1402	es_ES	personality_types.independent.personality_advice_3	Recognize when self-reliance becomes a barrier to intimacy.	\N	2025-08-18 15:54:33.531648
1403	es_ES	personality_types.independent.personality_advice_4	Practice asking for help when needed.	\N	2025-08-18 15:54:33.531886
1404	es_ES	personality_types.independent.personality_advice_5	Your self-sufficiency is a strength that brings stability to relationships.	\N	2025-08-18 15:54:33.532103
1405	es_ES	personality_types.independent.relationship_advice_1	Communicate your need for space proactively, not reactively.	\N	2025-08-18 15:54:33.53236
1406	es_ES	personality_types.independent.relationship_advice_2	Create rituals of connection to balance your independence.	\N	2025-08-18 15:54:33.532579
1407	es_ES	personality_types.independent.relationship_advice_3	Look for partners who respect your autonomy without feeling threatened.	\N	2025-08-18 15:54:33.532787
1408	es_ES	personality_types.independent.relationship_advice_4	Invest in interdependence alongside independence.	\N	2025-08-18 15:54:33.532985
1409	es_ES	personality_types.independent.relationship_advice_5	Share your growth journey with those closest to you.	\N	2025-08-18 15:54:33.533188
1410	es_ES	personality_types.independent.title	The Independent	\N	2025-08-18 15:54:33.533376
1411	es_ES	personality_types.loyalist.description	You prioritize trust and commitment in relationships. Your reliability and dedication create a secure foundation for deep connections.	\N	2025-08-18 15:54:33.533569
1412	es_ES	personality_types.loyalist.personality_advice_1	Ensure your loyalty to others doesn't override loyalty to yourself.	\N	2025-08-18 15:54:33.533759
1413	es_ES	personality_types.loyalist.personality_advice_2	Recognize that trust can be rebuilt after small breaches.	\N	2025-08-18 15:54:33.534016
1414	es_ES	personality_types.loyalist.personality_advice_3	Balance consistency with spontaneity and growth.	\N	2025-08-18 15:54:33.53432
1415	es_ES	personality_types.loyalist.personality_advice_4	Allow yourself and others room to evolve and change.	\N	2025-08-18 15:54:33.534559
1416	es_ES	personality_types.loyalist.personality_advice_5	Your steadfastness provides valuable security in relationships.	\N	2025-08-18 15:54:33.53477
1417	es_ES	personality_types.loyalist.relationship_advice_1	Communicate your expectations clearly to avoid disappointment.	\N	2025-08-18 15:54:33.534984
1418	es_ES	personality_types.loyalist.relationship_advice_2	Practice forgiveness for minor transgressions.	\N	2025-08-18 15:54:33.535179
1419	es_ES	personality_types.loyalist.relationship_advice_3	Look for partners who value commitment as much as you do.	\N	2025-08-18 15:54:33.535371
1420	es_ES	personality_types.loyalist.relationship_advice_4	Build trust through small, consistent actions over time.	\N	2025-08-18 15:54:33.535562
1421	es_ES	personality_types.loyalist.relationship_advice_5	Create space for both security and adventure in your relationships.	\N	2025-08-18 15:54:33.535748
1422	es_ES	personality_types.loyalist.title	The Loyalist	\N	2025-08-18 15:54:33.535935
1423	es_ES	questions.q1	How do you typically handle conflicts in relationships?	\N	2025-08-18 15:54:33.536131
1424	es_ES	questions.q1_option_1	I prefer to address issues immediately and directly.	\N	2025-08-18 15:54:33.536365
1425	es_ES	questions.q1_option_2	I need time to process before discussing the problem.	\N	2025-08-18 15:54:33.536742
1426	es_ES	questions.q1_option_3	I try to find a compromise that works for everyone.	\N	2025-08-18 15:54:33.536984
1427	es_ES	questions.q1_option_4	I sometimes avoid confrontation to keep the peace.	\N	2025-08-18 15:54:33.537249
1428	es_ES	questions.q2	What's most important to you in a relationship?	\N	2025-08-18 15:54:33.537477
1429	es_ES	questions.q2_option_1	Open and honest communication.	\N	2025-08-18 15:54:33.537718
1430	es_ES	questions.q2_option_2	Trust and loyalty.	\N	2025-08-18 15:54:33.537943
1431	es_ES	questions.q2_option_3	Emotional support and understanding.	\N	2025-08-18 15:54:33.538175
1432	es_ES	questions.q2_option_4	Growth and shared experiences.	\N	2025-08-18 15:54:33.5386
1433	es_ES	questions.q3	How do you express affection to your partner?	\N	2025-08-18 15:54:33.538832
1434	es_ES	questions.q3_option_1	Through physical touch and closeness.	\N	2025-08-18 15:54:33.53905
1435	es_ES	questions.q3_option_2	By giving gifts or doing thoughtful acts of service.	\N	2025-08-18 15:54:33.539271
1436	es_ES	questions.q3_option_3	With words of affirmation and compliments.	\N	2025-08-18 15:54:33.539492
1437	es_ES	questions.q3_option_4	By spending quality time together.	\N	2025-08-18 15:54:33.539709
1438	es_ES	questions.q4	When making important decisions with a partner, you prefer to:	\N	2025-08-18 15:54:33.540052
1439	es_ES	questions.q4_option_1	Take the lead and make decisions confidently.	\N	2025-08-18 15:54:33.540262
1440	es_ES	questions.q4_option_2	Discuss all options thoroughly before deciding together.	\N	2025-08-18 15:54:33.540481
1441	es_ES	questions.q4_option_3	Consider your partner's needs first.	\N	2025-08-18 15:54:33.540702
1442	es_ES	questions.q4_option_4	Be flexible and go with the flow.	\N	2025-08-18 15:54:33.540919
1443	es_ES	questions.q5	How do you react when you feel emotionally hurt by someone close to you?	\N	2025-08-18 15:54:33.541119
1444	es_ES	questions.q5_option_1	Express my feelings immediately and directly.	\N	2025-08-18 15:54:33.541315
1445	es_ES	questions.q5_option_2	Withdraw and process my emotions privately.	\N	2025-08-18 15:54:33.541522
1446	es_ES	questions.q5_option_3	Try to understand their perspective before reacting.	\N	2025-08-18 15:54:33.541728
1447	es_ES	questions.q5_option_4	Tend to forgive quickly and move forward.	\N	2025-08-18 15:54:33.541933
1448	es_ES	quiz.calculateResults	Calculate Results	\N	2025-08-18 15:54:33.542183
1449	es_ES	quiz.nextQuestion	Siguiente Question	\N	2025-08-18 15:54:33.542718
1450	es_ES	quiz.of	of	\N	2025-08-18 15:54:33.543726
1451	es_ES	quiz.previousQuestion	Anterior Question	\N	2025-08-18 15:54:33.544067
1452	es_ES	quiz.question	Question	\N	2025-08-18 15:54:33.5444
1453	es_ES	quiz.retakeQuiz	Take Quiz Again	\N	2025-08-18 15:54:33.544657
1454	es_ES	quiz.shareResults	Share Results	\N	2025-08-18 15:54:33.544861
1455	es_ES	quiz.startButton	Start Quiz	\N	2025-08-18 15:54:33.54503
1456	es_ES	quiz.subtitle	Discover Your Relationship Style	\N	2025-08-18 15:54:33.545217
1457	es_ES	results.maxScore	Max Score	\N	2025-08-18 15:54:33.545458
1458	es_ES	results.percentage	Percentage	\N	2025-08-18 15:54:33.545675
1459	es_ES	results.personalityInsights	Personality Insights	\N	2025-08-18 15:54:33.545871
1460	es_ES	results.relationshipTips	Relationship Improvement Tips	\N	2025-08-18 15:54:33.546048
1461	es_ES	results.score	Score	\N	2025-08-18 15:54:33.546226
1462	es_ES	results.shareOnFacebook	Share on Facebook	\N	2025-08-18 15:54:33.546388
1463	es_ES	results.takeQuizAgain	Take Quiz Again	\N	2025-08-18 15:54:33.546548
1464	es_ES	results.title	Your Relationship Personality Results	\N	2025-08-18 15:54:33.546718
1465	es_ES	results.yourType	Your Type	\N	2025-08-18 15:54:33.546896
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: quiz_user
--

COPY public.payments (id, session_id, stripe_payment_id, amount, currency, status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: personality_advice; Type: TABLE DATA; Schema: public; Owner: quiz_user
--

COPY public.personality_advice (id, personality_type_id, advice_type, advice_text, advice_order, created_at) FROM stdin;
51	6	personality	You excel at expressing yourself clearly and listening actively. Use these skills to build deeper connections with others.	1	2025-08-21 15:02:20.960572
52	7	personality	Your caring nature is a gift. Remember to also nurture yourself while supporting others in their growth.	1	2025-08-21 15:02:20.960572
53	8	personality	You bring peace and balance to relationships. Your ability to see all sides helps resolve conflicts effectively.	1	2025-08-21 15:02:20.960572
54	9	personality	Your self-reliance is admirable. Balance your independence with openness to support and connection from others.	1	2025-08-21 15:02:20.960572
55	10	personality	Your loyalty and commitment create strong, lasting bonds. Trust in your ability to build meaningful relationships.	1	2025-08-21 15:02:20.960572
56	16	personality	Você se destaca em se expressar claramente e ouvir ativamente. Use essas habilidades para construir conexões mais profundas com outros.	1	2025-08-21 15:02:20.960572
57	17	personality	Sua natureza cuidadosa é um presente. Lembre-se de também cuidar de si mesmo enquanto apoia outros em seu crescimento.	1	2025-08-21 15:02:20.960572
58	18	personality	Você traz paz e equilíbrio aos relacionamentos. Sua capacidade de ver todos os lados ajuda a resolver conflitos efetivamente.	1	2025-08-21 15:02:20.960572
59	19	personality	Sua autossuficiência é admirável. Equilibre sua independência com abertura ao apoio e conexão de outros.	1	2025-08-21 15:02:20.960572
60	20	personality	Sua lealdade e compromisso criam vínculos fortes e duradouros. Confie em sua capacidade de construir relacionamentos significativos.	1	2025-08-21 15:02:20.960572
61	21	personality	Sobresales expresándote claramente y escuchando activamente. Usa estas habilidades para construir conexiones más profundas con otros.	1	2025-08-21 15:02:20.960572
62	22	personality	Tu naturaleza cariñosa es un regalo. Recuerda también cuidarte a ti mismo mientras apoyas a otros en su crecimiento.	1	2025-08-21 15:02:20.960572
63	23	personality	Abraza tus cualidades únicas y úsalas para construir conexiones auténticas con otros.	1	2025-08-21 15:02:20.960572
64	24	personality	Abraza tus cualidades únicas y úsalas para construir conexiones auténticas con otros.	1	2025-08-21 15:02:20.960572
65	25	personality	Tu lealtad y compromiso crean vínculos fuertes y duraderos. Confía en tu capacidad de construir relaciones significativas.	1	2025-08-21 15:02:20.960572
66	26	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:02:20.973251
67	27	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:02:20.973251
68	28	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:02:20.973251
69	29	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:02:20.973251
70	30	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:02:20.973251
71	31	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:02:20.973251
72	32	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:02:20.973251
73	33	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:02:20.973251
74	34	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:02:20.973251
75	35	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:02:20.973251
76	36	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:02:20.973251
77	37	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:02:20.973251
78	38	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:02:20.973251
79	39	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:02:20.973251
80	40	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:02:20.973251
81	41	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:02:20.973251
82	42	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:02:20.973251
83	43	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:02:20.973251
84	44	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:02:20.973251
85	45	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:02:20.973251
86	46	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:02:20.973251
87	47	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:02:20.973251
88	48	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:02:20.973251
89	49	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:02:20.973251
90	50	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:02:20.973251
91	51	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:02:20.973251
92	52	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:02:20.973251
93	53	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:02:20.973251
94	54	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:02:20.973251
95	55	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:02:20.973251
96	56	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:02:20.973251
97	57	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:02:20.973251
98	58	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:02:20.973251
99	59	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:02:20.973251
100	60	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:02:20.973251
101	61	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:02:20.973251
102	62	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:02:20.973251
103	63	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:02:20.973251
104	64	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:02:20.973251
105	65	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:02:20.973251
106	66	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:02:20.973251
107	67	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:02:20.973251
108	68	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:02:20.973251
109	69	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:02:20.973251
110	70	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:02:20.973251
111	71	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:02:20.973251
112	72	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:02:20.973251
113	73	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:02:20.973251
114	74	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:02:20.973251
115	75	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:02:20.973251
116	76	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:02:20.973251
117	77	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:02:20.973251
118	78	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:02:20.973251
119	79	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:02:20.973251
120	80	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:02:20.973251
121	81	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:02:20.973251
122	82	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:02:20.973251
123	83	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:02:20.973251
124	84	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:02:20.973251
125	85	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:02:20.973251
126	6	personality	You excel at expressing yourself clearly and listening actively. Use these skills to build deeper connections with others.	1	2025-08-21 15:02:34.11985
127	7	personality	Your caring nature is a gift. Remember to also nurture yourself while supporting others in their growth.	1	2025-08-21 15:02:34.11985
128	8	personality	You bring peace and balance to relationships. Your ability to see all sides helps resolve conflicts effectively.	1	2025-08-21 15:02:34.11985
129	9	personality	Your self-reliance is admirable. Balance your independence with openness to support and connection from others.	1	2025-08-21 15:02:34.11985
130	10	personality	Your loyalty and commitment create strong, lasting bonds. Trust in your ability to build meaningful relationships.	1	2025-08-21 15:02:34.11985
131	16	personality	Você se destaca em se expressar claramente e ouvir ativamente. Use essas habilidades para construir conexões mais profundas com outros.	1	2025-08-21 15:02:34.11985
132	17	personality	Sua natureza cuidadosa é um presente. Lembre-se de também cuidar de si mesmo enquanto apoia outros em seu crescimento.	1	2025-08-21 15:02:34.11985
133	18	personality	Você traz paz e equilíbrio aos relacionamentos. Sua capacidade de ver todos os lados ajuda a resolver conflitos efetivamente.	1	2025-08-21 15:02:34.11985
134	19	personality	Sua autossuficiência é admirável. Equilibre sua independência com abertura ao apoio e conexão de outros.	1	2025-08-21 15:02:34.11985
135	20	personality	Sua lealdade e compromisso criam vínculos fortes e duradouros. Confie em sua capacidade de construir relacionamentos significativos.	1	2025-08-21 15:02:34.11985
136	21	personality	Sobresales expresándote claramente y escuchando activamente. Usa estas habilidades para construir conexiones más profundas con otros.	1	2025-08-21 15:02:34.11985
137	22	personality	Tu naturaleza cariñosa es un regalo. Recuerda también cuidarte a ti mismo mientras apoyas a otros en su crecimiento.	1	2025-08-21 15:02:34.11985
138	23	personality	Abraza tus cualidades únicas y úsalas para construir conexiones auténticas con otros.	1	2025-08-21 15:02:34.11985
139	24	personality	Abraza tus cualidades únicas y úsalas para construir conexiones auténticas con otros.	1	2025-08-21 15:02:34.11985
140	25	personality	Tu lealtad y compromiso crean vínculos fuertes y duraderos. Confía en tu capacidad de construir relaciones significativas.	1	2025-08-21 15:02:34.11985
141	26	coaching	Focus on developing your strengths while being open to growth opportunities. Every challenge is a chance to learn and improve.	1	2025-08-21 15:02:34.124923
142	27	coaching	Focus on developing your strengths while being open to growth opportunities. Every challenge is a chance to learn and improve.	1	2025-08-21 15:02:34.124923
143	28	coaching	Focus on developing your strengths while being open to growth opportunities. Every challenge is a chance to learn and improve.	1	2025-08-21 15:02:34.124923
144	29	coaching	Concentre-se em desenvolver seus pontos fortes enquanto permanece aberto a oportunidades de crescimento. Cada desafio é uma chance de aprender e melhorar.	1	2025-08-21 15:02:34.124923
145	30	coaching	Concentre-se em desenvolver seus pontos fortes enquanto permanece aberto a oportunidades de crescimento. Cada desafio é uma chance de aprender e melhorar.	1	2025-08-21 15:02:34.124923
146	31	coaching	Concentre-se em desenvolver seus pontos fortes enquanto permanece aberto a oportunidades de crescimento. Cada desafio é uma chance de aprender e melhorar.	1	2025-08-21 15:02:34.124923
147	32	coaching	Enfócate en desarrollar tus fortalezas mientras te mantienes abierto a oportunidades de crecimiento. Cada desafío es una oportunidad de aprender y mejorar.	1	2025-08-21 15:02:34.124923
148	33	coaching	Enfócate en desarrollar tus fortalezas mientras te mantienes abierto a oportunidades de crecimiento. Cada desafío es una oportunidad de aprender y mejorar.	1	2025-08-21 15:02:34.124923
149	34	coaching	Enfócate en desarrollar tus fortalezas mientras te mantienes abierto a oportunidades de crecimiento. Cada desafío es una oportunidad de aprender y mejorar.	1	2025-08-21 15:02:34.124923
150	35	coaching	Concentrez-vous sur le développement de vos forces tout en restant ouvert aux opportunités de croissance. Chaque défi est une chance d'apprendre et de s'améliorer.	1	2025-08-21 15:02:34.124923
151	36	coaching	Concentrez-vous sur le développement de vos forces tout en restant ouvert aux opportunités de croissance. Chaque défi est une chance d'apprendre et de s'améliorer.	1	2025-08-21 15:02:34.124923
152	37	coaching	Concentrez-vous sur le développement de vos forces tout en restant ouvert aux opportunités de croissance. Chaque défi est une chance d'apprendre et de s'améliorer.	1	2025-08-21 15:02:34.124923
153	38	coaching	Focus on developing your strengths while being open to growth opportunities. Every challenge is a chance to learn and improve.	1	2025-08-21 15:02:34.124923
154	39	coaching	Focus on developing your strengths while being open to growth opportunities. Every challenge is a chance to learn and improve.	1	2025-08-21 15:02:34.124923
155	40	coaching	Focus on developing your strengths while being open to growth opportunities. Every challenge is a chance to learn and improve.	1	2025-08-21 15:02:34.124923
156	41	coaching	Concentre-se em desenvolver seus pontos fortes enquanto permanece aberto a oportunidades de crescimento. Cada desafio é uma chance de aprender e melhorar.	1	2025-08-21 15:02:34.124923
157	42	coaching	Concentre-se em desenvolver seus pontos fortes enquanto permanece aberto a oportunidades de crescimento. Cada desafio é uma chance de aprender e melhorar.	1	2025-08-21 15:02:34.124923
158	43	coaching	Concentre-se em desenvolver seus pontos fortes enquanto permanece aberto a oportunidades de crescimento. Cada desafio é uma chance de aprender e melhorar.	1	2025-08-21 15:02:34.124923
159	44	coaching	Enfócate en desarrollar tus fortalezas mientras te mantienes abierto a oportunidades de crecimiento. Cada desafío es una oportunidad de aprender y mejorar.	1	2025-08-21 15:02:34.124923
160	45	coaching	Enfócate en desarrollar tus fortalezas mientras te mantienes abierto a oportunidades de crecimiento. Cada desafío es una oportunidad de aprender y mejorar.	1	2025-08-21 15:02:34.124923
161	46	coaching	Enfócate en desarrollar tus fortalezas mientras te mantienes abierto a oportunidades de crecimiento. Cada desafío es una oportunidad de aprender y mejorar.	1	2025-08-21 15:02:34.124923
162	47	coaching	Concentrez-vous sur le développement de vos forces tout en restant ouvert aux opportunités de croissance. Chaque défi est une chance d'apprendre et de s'améliorer.	1	2025-08-21 15:02:34.124923
163	48	coaching	Concentrez-vous sur le développement de vos forces tout en restant ouvert aux opportunités de croissance. Chaque défi est une chance d'apprendre et de s'améliorer.	1	2025-08-21 15:02:34.124923
164	49	coaching	Concentrez-vous sur le développement de vos forces tout en restant ouvert aux opportunités de croissance. Chaque défi est une chance d'apprendre et de s'améliorer.	1	2025-08-21 15:02:34.124923
165	50	coaching	Focus on developing your strengths while being open to growth opportunities. Every challenge is a chance to learn and improve.	1	2025-08-21 15:02:34.124923
166	51	coaching	Focus on developing your strengths while being open to growth opportunities. Every challenge is a chance to learn and improve.	1	2025-08-21 15:02:34.124923
167	52	coaching	Focus on developing your strengths while being open to growth opportunities. Every challenge is a chance to learn and improve.	1	2025-08-21 15:02:34.124923
168	53	coaching	Concentre-se em desenvolver seus pontos fortes enquanto permanece aberto a oportunidades de crescimento. Cada desafio é uma chance de aprender e melhorar.	1	2025-08-21 15:02:34.124923
169	54	coaching	Concentre-se em desenvolver seus pontos fortes enquanto permanece aberto a oportunidades de crescimento. Cada desafio é uma chance de aprender e melhorar.	1	2025-08-21 15:02:34.124923
170	55	coaching	Concentre-se em desenvolver seus pontos fortes enquanto permanece aberto a oportunidades de crescimento. Cada desafio é uma chance de aprender e melhorar.	1	2025-08-21 15:02:34.124923
171	56	coaching	Enfócate en desarrollar tus fortalezas mientras te mantienes abierto a oportunidades de crecimiento. Cada desafío es una oportunidad de aprender y mejorar.	1	2025-08-21 15:02:34.124923
172	57	coaching	Enfócate en desarrollar tus fortalezas mientras te mantienes abierto a oportunidades de crecimiento. Cada desafío es una oportunidad de aprender y mejorar.	1	2025-08-21 15:02:34.124923
173	58	coaching	Enfócate en desarrollar tus fortalezas mientras te mantienes abierto a oportunidades de crecimiento. Cada desafío es una oportunidad de aprender y mejorar.	1	2025-08-21 15:02:34.124923
174	59	coaching	Concentrez-vous sur le développement de vos forces tout en restant ouvert aux opportunités de croissance. Chaque défi est une chance d'apprendre et de s'améliorer.	1	2025-08-21 15:02:34.124923
175	60	coaching	Concentrez-vous sur le développement de vos forces tout en restant ouvert aux opportunités de croissance. Chaque défi est une chance d'apprendre et de s'améliorer.	1	2025-08-21 15:02:34.124923
176	61	coaching	Concentrez-vous sur le développement de vos forces tout en restant ouvert aux opportunités de croissance. Chaque défi est une chance d'apprendre et de s'améliorer.	1	2025-08-21 15:02:34.124923
177	62	coaching	Focus on developing your strengths while being open to growth opportunities. Every challenge is a chance to learn and improve.	1	2025-08-21 15:02:34.124923
178	63	coaching	Focus on developing your strengths while being open to growth opportunities. Every challenge is a chance to learn and improve.	1	2025-08-21 15:02:34.124923
179	64	coaching	Focus on developing your strengths while being open to growth opportunities. Every challenge is a chance to learn and improve.	1	2025-08-21 15:02:34.124923
180	65	coaching	Concentre-se em desenvolver seus pontos fortes enquanto permanece aberto a oportunidades de crescimento. Cada desafio é uma chance de aprender e melhorar.	1	2025-08-21 15:02:34.124923
181	66	coaching	Concentre-se em desenvolver seus pontos fortes enquanto permanece aberto a oportunidades de crescimento. Cada desafio é uma chance de aprender e melhorar.	1	2025-08-21 15:02:34.124923
182	67	coaching	Concentre-se em desenvolver seus pontos fortes enquanto permanece aberto a oportunidades de crescimento. Cada desafio é uma chance de aprender e melhorar.	1	2025-08-21 15:02:34.124923
183	68	coaching	Enfócate en desarrollar tus fortalezas mientras te mantienes abierto a oportunidades de crecimiento. Cada desafío es una oportunidad de aprender y mejorar.	1	2025-08-21 15:02:34.124923
184	69	coaching	Enfócate en desarrollar tus fortalezas mientras te mantienes abierto a oportunidades de crecimiento. Cada desafío es una oportunidad de aprender y mejorar.	1	2025-08-21 15:02:34.124923
185	70	coaching	Enfócate en desarrollar tus fortalezas mientras te mantienes abierto a oportunidades de crecimiento. Cada desafío es una oportunidad de aprender y mejorar.	1	2025-08-21 15:02:34.124923
186	71	coaching	Concentrez-vous sur le développement de vos forces tout en restant ouvert aux opportunités de croissance. Chaque défi est une chance d'apprendre et de s'améliorer.	1	2025-08-21 15:02:34.124923
187	72	coaching	Concentrez-vous sur le développement de vos forces tout en restant ouvert aux opportunités de croissance. Chaque défi est une chance d'apprendre et de s'améliorer.	1	2025-08-21 15:02:34.124923
188	73	coaching	Concentrez-vous sur le développement de vos forces tout en restant ouvert aux opportunités de croissance. Chaque défi est une chance d'apprendre et de s'améliorer.	1	2025-08-21 15:02:34.124923
189	74	coaching	Focus on developing your strengths while being open to growth opportunities. Every challenge is a chance to learn and improve.	1	2025-08-21 15:02:34.124923
190	75	coaching	Focus on developing your strengths while being open to growth opportunities. Every challenge is a chance to learn and improve.	1	2025-08-21 15:02:34.124923
191	76	coaching	Focus on developing your strengths while being open to growth opportunities. Every challenge is a chance to learn and improve.	1	2025-08-21 15:02:34.124923
192	77	coaching	Concentre-se em desenvolver seus pontos fortes enquanto permanece aberto a oportunidades de crescimento. Cada desafio é uma chance de aprender e melhorar.	1	2025-08-21 15:02:34.124923
193	78	coaching	Concentre-se em desenvolver seus pontos fortes enquanto permanece aberto a oportunidades de crescimento. Cada desafio é uma chance de aprender e melhorar.	1	2025-08-21 15:02:34.124923
194	79	coaching	Concentre-se em desenvolver seus pontos fortes enquanto permanece aberto a oportunidades de crescimento. Cada desafio é uma chance de aprender e melhorar.	1	2025-08-21 15:02:34.124923
195	80	coaching	Enfócate en desarrollar tus fortalezas mientras te mantienes abierto a oportunidades de crecimiento. Cada desafío es una oportunidad de aprender y mejorar.	1	2025-08-21 15:02:34.124923
196	81	coaching	Enfócate en desarrollar tus fortalezas mientras te mantienes abierto a oportunidades de crecimiento. Cada desafío es una oportunidad de aprender y mejorar.	1	2025-08-21 15:02:34.124923
197	82	coaching	Enfócate en desarrollar tus fortalezas mientras te mantienes abierto a oportunidades de crecimiento. Cada desafío es una oportunidad de aprender y mejorar.	1	2025-08-21 15:02:34.124923
198	83	coaching	Concentrez-vous sur le développement de vos forces tout en restant ouvert aux opportunités de croissance. Chaque défi est une chance d'apprendre et de s'améliorer.	1	2025-08-21 15:02:34.124923
199	84	coaching	Concentrez-vous sur le développement de vos forces tout en restant ouvert aux opportunités de croissance. Chaque défi est une chance d'apprendre et de s'améliorer.	1	2025-08-21 15:02:34.124923
200	85	coaching	Concentrez-vous sur le développement de vos forces tout en restant ouvert aux opportunités de croissance. Chaque défi est une chance d'apprendre et de s'améliorer.	1	2025-08-21 15:02:34.124923
201	26	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:02:34.126204
202	27	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:02:34.126204
203	28	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:02:34.126204
204	29	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:02:34.126204
205	30	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:02:34.126204
206	31	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:02:34.126204
207	32	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:02:34.126204
208	33	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:02:34.126204
209	34	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:02:34.126204
210	35	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:02:34.126204
211	36	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:02:34.126204
212	37	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:02:34.126204
213	38	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:02:34.126204
214	39	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:02:34.126204
215	40	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:02:34.126204
216	41	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:02:34.126204
217	42	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:02:34.126204
218	43	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:02:34.126204
219	44	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:02:34.126204
220	45	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:02:34.126204
221	46	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:02:34.126204
222	47	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:02:34.126204
223	48	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:02:34.126204
224	49	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:02:34.126204
225	50	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:02:34.126204
226	51	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:02:34.126204
227	52	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:02:34.126204
228	53	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:02:34.126204
229	54	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:02:34.126204
230	55	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:02:34.126204
231	56	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:02:34.126204
232	57	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:02:34.126204
233	58	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:02:34.126204
234	59	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:02:34.126204
235	60	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:02:34.126204
236	61	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:02:34.126204
237	62	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:02:34.126204
238	63	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:02:34.126204
239	64	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:02:34.126204
240	65	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:02:34.126204
241	66	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:02:34.126204
242	67	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:02:34.126204
243	68	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:02:34.126204
244	69	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:02:34.126204
245	70	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:02:34.126204
246	71	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:02:34.126204
247	72	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:02:34.126204
248	73	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:02:34.126204
249	74	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:02:34.126204
250	75	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:02:34.126204
251	76	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:02:34.126204
252	77	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:02:34.126204
253	78	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:02:34.126204
254	79	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:02:34.126204
255	80	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:02:34.126204
256	81	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:02:34.126204
257	82	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:02:34.126204
258	83	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:02:34.126204
259	84	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:02:34.126204
260	85	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:02:34.126204
261	6	personality	You excel at expressing yourself clearly and listening actively. Use these skills to build deeper connections with others.	1	2025-08-21 15:03:18.915219
262	7	personality	Your caring nature is a gift. Remember to also nurture yourself while supporting others in their growth.	1	2025-08-21 15:03:18.915219
263	8	personality	You bring peace and balance to relationships. Your ability to see all sides helps resolve conflicts effectively.	1	2025-08-21 15:03:18.915219
264	9	personality	Your self-reliance is admirable. Balance your independence with openness to support and connection from others.	1	2025-08-21 15:03:18.915219
265	10	personality	Your loyalty and commitment create strong, lasting bonds. Trust in your ability to build meaningful relationships.	1	2025-08-21 15:03:18.915219
266	16	personality	Você se destaca em se expressar claramente e ouvir ativamente. Use essas habilidades para construir conexões mais profundas com outros.	1	2025-08-21 15:03:18.915219
267	17	personality	Sua natureza cuidadosa é um presente. Lembre-se de também cuidar de si mesmo enquanto apoia outros em seu crescimento.	1	2025-08-21 15:03:18.915219
268	18	personality	Você traz paz e equilíbrio aos relacionamentos. Sua capacidade de ver todos os lados ajuda a resolver conflitos efetivamente.	1	2025-08-21 15:03:18.915219
269	19	personality	Sua autossuficiência é admirável. Equilibre sua independência com abertura ao apoio e conexão de outros.	1	2025-08-21 15:03:18.915219
270	20	personality	Sua lealdade e compromisso criam vínculos fortes e duradouros. Confie em sua capacidade de construir relacionamentos significativos.	1	2025-08-21 15:03:18.915219
271	21	personality	Sobresales expresándote claramente y escuchando activamente. Usa estas habilidades para construir conexiones más profundas con otros.	1	2025-08-21 15:03:18.915219
272	22	personality	Tu naturaleza cariñosa es un regalo. Recuerda también cuidarte a ti mismo mientras apoyas a otros en su crecimiento.	1	2025-08-21 15:03:18.915219
273	23	personality	Abraza tus cualidades únicas y úsalas para construir conexiones auténticas con otros.	1	2025-08-21 15:03:18.915219
274	24	personality	Abraza tus cualidades únicas y úsalas para construir conexiones auténticas con otros.	1	2025-08-21 15:03:18.915219
275	25	personality	Tu lealtad y compromiso crean vínculos fuertes y duraderos. Confía en tu capacidad de construir relaciones significativas.	1	2025-08-21 15:03:18.915219
276	6	relationship	In relationships, practice patience and give others time to process. Not everyone communicates at your pace.	2	2025-08-21 15:03:18.915219
277	7	relationship	Set healthy boundaries in relationships. Your giving nature is beautiful, but remember your needs matter too.	2	2025-08-21 15:03:18.915219
278	8	relationship	While avoiding conflict is natural for you, sometimes addressing issues directly strengthens relationships.	2	2025-08-21 15:03:18.915219
279	9	relationship	Allow yourself to be vulnerable in close relationships. Interdependence can coexist with your independence.	2	2025-08-21 15:03:18.915219
280	10	relationship	Your loyalty is precious. Ensure it is reciprocated and that you are valued for who you are, not just what you give.	2	2025-08-21 15:03:18.915219
281	16	relationship	Nos relacionamentos, pratique paciência e dê tempo aos outros para processar. Nem todos se comunicam no seu ritmo.	2	2025-08-21 15:03:18.915219
282	17	relationship	Estabeleça limites saudáveis nos relacionamentos. Sua natureza generosa é linda, mas lembre-se que suas necessidades também importam.	2	2025-08-21 15:03:18.915219
283	18	relationship	Embora evitar conflitos seja natural para você, às vezes abordar questões diretamente fortalece os relacionamentos.	2	2025-08-21 15:03:18.915219
284	19	relationship	Permita-se ser vulnerável em relacionamentos próximos. A interdependência pode coexistir com sua independência.	2	2025-08-21 15:03:18.915219
285	20	relationship	Sua lealdade é preciosa. Certifique-se de que seja recíproca e que você seja valorizado por quem é, não apenas pelo que dá.	2	2025-08-21 15:03:18.915219
286	21	relationship	En las relaciones, practica la paciencia y da tiempo a otros para procesar. No todos se comunican a tu ritmo.	2	2025-08-21 15:03:18.915219
287	22	relationship	Establece límites saludables en las relaciones. Tu naturaleza generosa es hermosa, pero recuerda que tus necesidades también importan.	2	2025-08-21 15:03:18.915219
288	23	relationship	Enfócate en construir relaciones basadas en respeto mutuo, comprensión y valores compartidos.	2	2025-08-21 15:03:18.915219
289	24	relationship	Enfócate en construir relaciones basadas en respeto mutuo, comprensión y valores compartidos.	2	2025-08-21 15:03:18.915219
290	25	relationship	Tu lealtad es preciosa. Asegúrate de que sea recíproca y que seas valorado por quien eres, no solo por lo que das.	2	2025-08-21 15:03:18.915219
291	26	coaching	Focus on developing your strengths while being open to growth opportunities. Every challenge is a chance to learn and improve.	1	2025-08-21 15:03:18.915219
292	27	coaching	Focus on developing your strengths while being open to growth opportunities. Every challenge is a chance to learn and improve.	1	2025-08-21 15:03:18.915219
293	28	coaching	Focus on developing your strengths while being open to growth opportunities. Every challenge is a chance to learn and improve.	1	2025-08-21 15:03:18.915219
294	29	coaching	Concentre-se em desenvolver seus pontos fortes enquanto permanece aberto a oportunidades de crescimento. Cada desafio é uma chance de aprender e melhorar.	1	2025-08-21 15:03:18.915219
295	30	coaching	Concentre-se em desenvolver seus pontos fortes enquanto permanece aberto a oportunidades de crescimento. Cada desafio é uma chance de aprender e melhorar.	1	2025-08-21 15:03:18.915219
296	31	coaching	Concentre-se em desenvolver seus pontos fortes enquanto permanece aberto a oportunidades de crescimento. Cada desafio é uma chance de aprender e melhorar.	1	2025-08-21 15:03:18.915219
297	32	coaching	Enfócate en desarrollar tus fortalezas mientras te mantienes abierto a oportunidades de crecimiento. Cada desafío es una oportunidad de aprender y mejorar.	1	2025-08-21 15:03:18.915219
298	33	coaching	Enfócate en desarrollar tus fortalezas mientras te mantienes abierto a oportunidades de crecimiento. Cada desafío es una oportunidad de aprender y mejorar.	1	2025-08-21 15:03:18.915219
299	34	coaching	Enfócate en desarrollar tus fortalezas mientras te mantienes abierto a oportunidades de crecimiento. Cada desafío es una oportunidad de aprender y mejorar.	1	2025-08-21 15:03:18.915219
300	35	coaching	Concentrez-vous sur le développement de vos forces tout en restant ouvert aux opportunités de croissance. Chaque défi est une chance pour apprendre et améliorer.	1	2025-08-21 15:03:18.915219
301	36	coaching	Concentrez-vous sur le développement de vos forces tout en restant ouvert aux opportunités de croissance. Chaque défi est une chance pour apprendre et améliorer.	1	2025-08-21 15:03:18.915219
302	37	coaching	Concentrez-vous sur le développement de vos forces tout en restant ouvert aux opportunités de croissance. Chaque défi est une chance pour apprendre et améliorer.	1	2025-08-21 15:03:18.915219
303	38	coaching	Focus on developing your strengths while being open to growth opportunities. Every challenge is a chance to learn and improve.	1	2025-08-21 15:03:18.915219
304	39	coaching	Focus on developing your strengths while being open to growth opportunities. Every challenge is a chance to learn and improve.	1	2025-08-21 15:03:18.915219
305	40	coaching	Focus on developing your strengths while being open to growth opportunities. Every challenge is a chance to learn and improve.	1	2025-08-21 15:03:18.915219
306	41	coaching	Concentre-se em desenvolver seus pontos fortes enquanto permanece aberto a oportunidades de crescimento. Cada desafio é uma chance de aprender e melhorar.	1	2025-08-21 15:03:18.915219
307	42	coaching	Concentre-se em desenvolver seus pontos fortes enquanto permanece aberto a oportunidades de crescimento. Cada desafio é uma chance de aprender e melhorar.	1	2025-08-21 15:03:18.915219
308	43	coaching	Concentre-se em desenvolver seus pontos fortes enquanto permanece aberto a oportunidades de crescimento. Cada desafio é uma chance de aprender e melhorar.	1	2025-08-21 15:03:18.915219
309	44	coaching	Enfócate en desarrollar tus fortalezas mientras te mantienes abierto a oportunidades de crecimiento. Cada desafío es una oportunidad de aprender y mejorar.	1	2025-08-21 15:03:18.915219
310	45	coaching	Enfócate en desarrollar tus fortalezas mientras te mantienes abierto a oportunidades de crecimiento. Cada desafío es una oportunidad de aprender y mejorar.	1	2025-08-21 15:03:18.915219
311	46	coaching	Enfócate en desarrollar tus fortalezas mientras te mantienes abierto a oportunidades de crecimiento. Cada desafío es una oportunidad de aprender y mejorar.	1	2025-08-21 15:03:18.915219
312	47	coaching	Concentrez-vous sur le développement de vos forces tout en restant ouvert aux opportunités de croissance. Chaque défi est une chance pour apprendre et améliorer.	1	2025-08-21 15:03:18.915219
313	48	coaching	Concentrez-vous sur le développement de vos forces tout en restant ouvert aux opportunités de croissance. Chaque défi est une chance pour apprendre et améliorer.	1	2025-08-21 15:03:18.915219
314	49	coaching	Concentrez-vous sur le développement de vos forces tout en restant ouvert aux opportunités de croissance. Chaque défi est une chance pour apprendre et améliorer.	1	2025-08-21 15:03:18.915219
315	50	coaching	Focus on developing your strengths while being open to growth opportunities. Every challenge is a chance to learn and improve.	1	2025-08-21 15:03:18.915219
316	51	coaching	Focus on developing your strengths while being open to growth opportunities. Every challenge is a chance to learn and improve.	1	2025-08-21 15:03:18.915219
317	52	coaching	Focus on developing your strengths while being open to growth opportunities. Every challenge is a chance to learn and improve.	1	2025-08-21 15:03:18.915219
318	53	coaching	Concentre-se em desenvolver seus pontos fortes enquanto permanece aberto a oportunidades de crescimento. Cada desafio é uma chance de aprender e melhorar.	1	2025-08-21 15:03:18.915219
319	54	coaching	Concentre-se em desenvolver seus pontos fortes enquanto permanece aberto a oportunidades de crescimento. Cada desafio é uma chance de aprender e melhorar.	1	2025-08-21 15:03:18.915219
320	55	coaching	Concentre-se em desenvolver seus pontos fortes enquanto permanece aberto a oportunidades de crescimento. Cada desafio é uma chance de aprender e melhorar.	1	2025-08-21 15:03:18.915219
321	56	coaching	Enfócate en desarrollar tus fortalezas mientras te mantienes abierto a oportunidades de crecimiento. Cada desafío es una oportunidad de aprender y mejorar.	1	2025-08-21 15:03:18.915219
322	57	coaching	Enfócate en desarrollar tus fortalezas mientras te mantienes abierto a oportunidades de crecimiento. Cada desafío es una oportunidad de aprender y mejorar.	1	2025-08-21 15:03:18.915219
323	58	coaching	Enfócate en desarrollar tus fortalezas mientras te mantienes abierto a oportunidades de crecimiento. Cada desafío es una oportunidad de aprender y mejorar.	1	2025-08-21 15:03:18.915219
324	59	coaching	Concentrez-vous sur le développement de vos forces tout en restant ouvert aux opportunités de croissance. Chaque défi est une chance pour apprendre et améliorer.	1	2025-08-21 15:03:18.915219
325	60	coaching	Concentrez-vous sur le développement de vos forces tout en restant ouvert aux opportunités de croissance. Chaque défi est une chance pour apprendre et améliorer.	1	2025-08-21 15:03:18.915219
326	61	coaching	Concentrez-vous sur le développement de vos forces tout en restant ouvert aux opportunités de croissance. Chaque défi est une chance pour apprendre et améliorer.	1	2025-08-21 15:03:18.915219
327	62	coaching	Focus on developing your strengths while being open to growth opportunities. Every challenge is a chance to learn and improve.	1	2025-08-21 15:03:18.915219
328	63	coaching	Focus on developing your strengths while being open to growth opportunities. Every challenge is a chance to learn and improve.	1	2025-08-21 15:03:18.915219
329	64	coaching	Focus on developing your strengths while being open to growth opportunities. Every challenge is a chance to learn and improve.	1	2025-08-21 15:03:18.915219
330	65	coaching	Concentre-se em desenvolver seus pontos fortes enquanto permanece aberto a oportunidades de crescimento. Cada desafio é uma chance de aprender e melhorar.	1	2025-08-21 15:03:18.915219
331	66	coaching	Concentre-se em desenvolver seus pontos fortes enquanto permanece aberto a oportunidades de crescimento. Cada desafio é uma chance de aprender e melhorar.	1	2025-08-21 15:03:18.915219
332	67	coaching	Concentre-se em desenvolver seus pontos fortes enquanto permanece aberto a oportunidades de crescimento. Cada desafio é uma chance de aprender e melhorar.	1	2025-08-21 15:03:18.915219
333	68	coaching	Enfócate en desarrollar tus fortalezas mientras te mantienes abierto a oportunidades de crecimiento. Cada desafío es una oportunidad de aprender y mejorar.	1	2025-08-21 15:03:18.915219
334	69	coaching	Enfócate en desarrollar tus fortalezas mientras te mantienes abierto a oportunidades de crecimiento. Cada desafío es una oportunidad de aprender y mejorar.	1	2025-08-21 15:03:18.915219
335	70	coaching	Enfócate en desarrollar tus fortalezas mientras te mantienes abierto a oportunidades de crecimiento. Cada desafío es una oportunidad de aprender y mejorar.	1	2025-08-21 15:03:18.915219
336	71	coaching	Concentrez-vous sur le développement de vos forces tout en restant ouvert aux opportunités de croissance. Chaque défi est une chance pour apprendre et améliorer.	1	2025-08-21 15:03:18.915219
337	72	coaching	Concentrez-vous sur le développement de vos forces tout en restant ouvert aux opportunités de croissance. Chaque défi est une chance pour apprendre et améliorer.	1	2025-08-21 15:03:18.915219
338	73	coaching	Concentrez-vous sur le développement de vos forces tout en restant ouvert aux opportunités de croissance. Chaque défi est une chance pour apprendre et améliorer.	1	2025-08-21 15:03:18.915219
339	74	coaching	Focus on developing your strengths while being open to growth opportunities. Every challenge is a chance to learn and improve.	1	2025-08-21 15:03:18.915219
340	75	coaching	Focus on developing your strengths while being open to growth opportunities. Every challenge is a chance to learn and improve.	1	2025-08-21 15:03:18.915219
341	76	coaching	Focus on developing your strengths while being open to growth opportunities. Every challenge is a chance to learn and improve.	1	2025-08-21 15:03:18.915219
342	77	coaching	Concentre-se em desenvolver seus pontos fortes enquanto permanece aberto a oportunidades de crescimento. Cada desafio é uma chance de aprender e melhorar.	1	2025-08-21 15:03:18.915219
343	78	coaching	Concentre-se em desenvolver seus pontos fortes enquanto permanece aberto a oportunidades de crescimento. Cada desafio é uma chance de aprender e melhorar.	1	2025-08-21 15:03:18.915219
344	79	coaching	Concentre-se em desenvolver seus pontos fortes enquanto permanece aberto a oportunidades de crescimento. Cada desafio é uma chance de aprender e melhorar.	1	2025-08-21 15:03:18.915219
345	80	coaching	Enfócate en desarrollar tus fortalezas mientras te mantienes abierto a oportunidades de crecimiento. Cada desafío es una oportunidad de aprender y mejorar.	1	2025-08-21 15:03:18.915219
346	81	coaching	Enfócate en desarrollar tus fortalezas mientras te mantienes abierto a oportunidades de crecimiento. Cada desafío es una oportunidad de aprender y mejorar.	1	2025-08-21 15:03:18.915219
347	82	coaching	Enfócate en desarrollar tus fortalezas mientras te mantienes abierto a oportunidades de crecimiento. Cada desafío es una oportunidad de aprender y mejorar.	1	2025-08-21 15:03:18.915219
348	83	coaching	Concentrez-vous sur le développement de vos forces tout en restant ouvert aux opportunités de croissance. Chaque défi est une chance pour apprendre et améliorer.	1	2025-08-21 15:03:18.915219
349	84	coaching	Concentrez-vous sur le développement de vos forces tout en restant ouvert aux opportunités de croissance. Chaque défi est une chance pour apprendre et améliorer.	1	2025-08-21 15:03:18.915219
350	85	coaching	Concentrez-vous sur le développement de vos forces tout en restant ouvert aux opportunités de croissance. Chaque défi est une chance pour apprendre et améliorer.	1	2025-08-21 15:03:18.915219
351	26	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:03:18.915219
352	27	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:03:18.915219
353	28	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:03:18.915219
354	29	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:03:18.915219
355	30	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:03:18.915219
356	31	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:03:18.915219
357	32	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:03:18.915219
358	33	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:03:18.915219
359	34	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:03:18.915219
360	35	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:03:18.915219
361	36	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:03:18.915219
362	37	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:03:18.915219
363	38	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:03:18.915219
364	39	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:03:18.915219
365	40	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:03:18.915219
366	41	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:03:18.915219
367	42	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:03:18.915219
368	43	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:03:18.915219
369	44	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:03:18.915219
370	45	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:03:18.915219
371	46	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:03:18.915219
372	47	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:03:18.915219
373	48	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:03:18.915219
374	49	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:03:18.915219
375	50	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:03:18.915219
376	51	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:03:18.915219
377	52	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:03:18.915219
378	53	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:03:18.915219
379	54	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:03:18.915219
380	55	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:03:18.915219
381	56	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:03:18.915219
382	57	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:03:18.915219
383	58	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:03:18.915219
384	59	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:03:18.915219
385	60	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:03:18.915219
386	61	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:03:18.915219
387	62	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:03:18.915219
388	63	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:03:18.915219
389	64	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:03:18.915219
390	65	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:03:18.915219
391	66	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:03:18.915219
392	67	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:03:18.915219
393	68	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:03:18.915219
394	69	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:03:18.915219
395	70	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:03:18.915219
396	71	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:03:18.915219
397	72	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:03:18.915219
398	73	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:03:18.915219
399	74	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:03:18.915219
400	75	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:03:18.915219
401	76	development	Set clear goals and celebrate small wins along the way. Consistent progress leads to lasting transformation.	2	2025-08-21 15:03:18.915219
402	77	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:03:18.915219
403	78	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:03:18.915219
404	79	development	Estabeleça metas claras e celebre pequenas vitórias ao longo do caminho. Progresso consistente leva à transformação duradoura.	2	2025-08-21 15:03:18.915219
405	80	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:03:18.915219
406	81	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:03:18.915219
407	82	development	Establece metas claras y celebra pequeñas victorias en el camino. El progreso consistente lleva a una transformación duradera.	2	2025-08-21 15:03:18.915219
408	83	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:03:18.915219
409	84	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:03:18.915219
410	85	development	Fixez des objectifs clairs et célébrez les petites victoires en cours de route. Un progrès constant mène à une transformation durable.	2	2025-08-21 15:03:18.915219
\.


--
-- Data for Name: personality_types; Type: TABLE DATA; Schema: public; Owner: quiz_user
--

COPY public.personality_types (id, quiz_id, type_name, type_key, description, created_at, country) FROM stdin;
6	1	The Communicator	communicator	You value open and honest communication in relationships. You're direct about your needs and feelings, which helps prevent misunderstandings.	2025-08-16 10:55:56.240505	en_US
7	1	The Nurturer	nurturer	You prioritize emotional support and understanding in relationships. Your empathetic nature makes others feel safe and valued.	2025-08-16 10:55:56.249929	en_US
8	1	The Harmonizer	harmonizer	You seek peace and balance in relationships. You're adaptable and willing to compromise to maintain harmony.	2025-08-16 10:55:56.254744	en_US
9	1	The Independent	independent	You value autonomy and personal growth in relationships. You bring a strong sense of self and clear boundaries to your connections.	2025-08-16 10:55:56.261314	en_US
10	1	The Loyalist	loyalist	You prioritize trust and commitment in relationships. Your reliability and dedication create a secure foundation for deep connections.	2025-08-16 10:55:56.264862	en_US
16	1	O Comunicador	communicator	Você valoriza a comunicação aberta e honesta em relacionamentos. Você expressa seus sentimentos claramente e encoraja outros a fazerem o mesmo.	2025-08-16 17:53:02.166185	pt_BR
17	1	O Cuidador	nurturer	Você naturalmente cuida e apoia seu parceiro. Você encontra alegria em fazer outros se sentirem amados e seguros.	2025-08-16 17:53:02.170393	pt_BR
18	1	O Harmonizador	harmonizer	Você busca paz e equilíbrio em relacionamentos. Você trabalha para resolver conflitos e criar harmonia entre você e seu parceiro.	2025-08-16 17:53:02.170966	pt_BR
19	1	O Independente	independent	Você valoriza sua autonomia enquanto está em um relacionamento. Você acredita que parceiros saudáveis mantêm suas identidades individuais.	2025-08-16 17:53:02.171429	pt_BR
20	1	O Leal	loyalist	Você é profundamente comprometido e leal em relacionamentos. Você valoriza estabilidade e constrói conexões duradouras.	2025-08-16 17:53:02.171823	pt_BR
21	1	El Comunicador	communicator	Valoras la comunicación abierta y honesta en las relaciones. Expresas tus sentimientos claramente y animas a otros a hacer lo mismo.	2025-08-16 18:57:31.41699	es_ES
22	1	El Cuidador	nurturer	Priorizas el cuidado y apoyo de tu pareja. Eres naturalmente empático y te enfocas en las necesidades emocionales de otros.	2025-08-16 18:57:31.418851	es_ES
23	1	El Armonizador	harmonizer	Buscas equilibrio y armonía en tus relaciones. Evitas conflictos y trabajas para crear un ambiente pacífico y comprensivo.	2025-08-16 18:57:31.419767	es_ES
24	1	El Independiente	independent	Valoras tu autonomía personal mientras mantienes conexiones significativas. Equilibras el tiempo solo con la intimidad en las relaciones.	2025-08-16 18:57:31.420831	es_ES
25	1	El Leal	loyalist	La lealtad y el compromiso son fundamentales para ti. Construyes relaciones duraderas basadas en la confianza y la consistencia.	2025-08-16 18:57:31.421696	es_ES
26	2	🔧 Type A - Quiz=2 - en_US	type_a	🔧 Description Type A - Quiz=2 - en_US	2025-08-21 14:16:27.998228	en_US
27	2	🔧 Type B - Quiz=2 - en_US	type_b	🔧 Description Type B - Quiz=2 - en_US	2025-08-21 14:16:27.998228	en_US
28	2	🔧 Type C - Quiz=2 - en_US	type_c	🔧 Description Type C - Quiz=2 - en_US	2025-08-21 14:16:27.998228	en_US
29	2	🔧 Tipo A - Quiz=2 - pt_BR	type_a	🔧 Descrição Tipo A - Quiz=2 - pt_BR	2025-08-21 14:16:27.998228	pt_BR
30	2	🔧 Tipo B - Quiz=2 - pt_BR	type_b	🔧 Descrição Tipo B - Quiz=2 - pt_BR	2025-08-21 14:16:27.998228	pt_BR
31	2	🔧 Tipo C - Quiz=2 - pt_BR	type_c	🔧 Descrição Tipo C - Quiz=2 - pt_BR	2025-08-21 14:16:27.998228	pt_BR
32	2	🔧 Tipo A - Quiz=2 - es_ES	type_a	🔧 Descripción Tipo A - Quiz=2 - es_ES	2025-08-21 14:16:27.998228	es_ES
33	2	🔧 Tipo B - Quiz=2 - es_ES	type_b	🔧 Descripción Tipo B - Quiz=2 - es_ES	2025-08-21 14:16:27.998228	es_ES
34	2	🔧 Tipo C - Quiz=2 - es_ES	type_c	🔧 Descripción Tipo C - Quiz=2 - es_ES	2025-08-21 14:16:27.998228	es_ES
35	2	🔧 Type A - Quiz=2 - fr_FR	type_a	🔧 Description Type A - Quiz=2 - fr_FR	2025-08-21 14:16:27.998228	fr_FR
36	2	🔧 Type B - Quiz=2 - fr_FR	type_b	🔧 Description Type B - Quiz=2 - fr_FR	2025-08-21 14:16:27.998228	fr_FR
37	2	🔧 Type C - Quiz=2 - fr_FR	type_c	🔧 Description Type C - Quiz=2 - fr_FR	2025-08-21 14:16:27.998228	fr_FR
38	3	🔧 Type A - Quiz=3 - en_US	type_a	🔧 Description Type A - Quiz=3 - en_US	2025-08-21 14:16:28.000257	en_US
39	3	🔧 Type B - Quiz=3 - en_US	type_b	🔧 Description Type B - Quiz=3 - en_US	2025-08-21 14:16:28.000257	en_US
40	3	🔧 Type C - Quiz=3 - en_US	type_c	🔧 Description Type C - Quiz=3 - en_US	2025-08-21 14:16:28.000257	en_US
41	3	🔧 Tipo A - Quiz=3 - pt_BR	type_a	🔧 Descrição Tipo A - Quiz=3 - pt_BR	2025-08-21 14:16:28.000257	pt_BR
42	3	🔧 Tipo B - Quiz=3 - pt_BR	type_b	🔧 Descrição Tipo B - Quiz=3 - pt_BR	2025-08-21 14:16:28.000257	pt_BR
43	3	🔧 Tipo C - Quiz=3 - pt_BR	type_c	🔧 Descrição Tipo C - Quiz=3 - pt_BR	2025-08-21 14:16:28.000257	pt_BR
44	3	🔧 Tipo A - Quiz=3 - es_ES	type_a	🔧 Descripción Tipo A - Quiz=3 - es_ES	2025-08-21 14:16:28.000257	es_ES
45	3	🔧 Tipo B - Quiz=3 - es_ES	type_b	🔧 Descripción Tipo B - Quiz=3 - es_ES	2025-08-21 14:16:28.000257	es_ES
46	3	🔧 Tipo C - Quiz=3 - es_ES	type_c	🔧 Descripción Tipo C - Quiz=3 - es_ES	2025-08-21 14:16:28.000257	es_ES
47	3	🔧 Type A - Quiz=3 - fr_FR	type_a	🔧 Description Type A - Quiz=3 - fr_FR	2025-08-21 14:16:28.000257	fr_FR
48	3	🔧 Type B - Quiz=3 - fr_FR	type_b	🔧 Description Type B - Quiz=3 - fr_FR	2025-08-21 14:16:28.000257	fr_FR
49	3	🔧 Type C - Quiz=3 - fr_FR	type_c	🔧 Description Type C - Quiz=3 - fr_FR	2025-08-21 14:16:28.000257	fr_FR
50	4	🔧 Type A - Quiz=4 - en_US	type_a	🔧 Description Type A - Quiz=4 - en_US	2025-08-21 14:16:28.000676	en_US
51	4	🔧 Type B - Quiz=4 - en_US	type_b	🔧 Description Type B - Quiz=4 - en_US	2025-08-21 14:16:28.000676	en_US
52	4	🔧 Type C - Quiz=4 - en_US	type_c	🔧 Description Type C - Quiz=4 - en_US	2025-08-21 14:16:28.000676	en_US
53	4	🔧 Tipo A - Quiz=4 - pt_BR	type_a	🔧 Descrição Tipo A - Quiz=4 - pt_BR	2025-08-21 14:16:28.000676	pt_BR
54	4	🔧 Tipo B - Quiz=4 - pt_BR	type_b	🔧 Descrição Tipo B - Quiz=4 - pt_BR	2025-08-21 14:16:28.000676	pt_BR
55	4	🔧 Tipo C - Quiz=4 - pt_BR	type_c	🔧 Descrição Tipo C - Quiz=4 - pt_BR	2025-08-21 14:16:28.000676	pt_BR
56	4	🔧 Tipo A - Quiz=4 - es_ES	type_a	🔧 Descripción Tipo A - Quiz=4 - es_ES	2025-08-21 14:16:28.000676	es_ES
57	4	🔧 Tipo B - Quiz=4 - es_ES	type_b	🔧 Descripción Tipo B - Quiz=4 - es_ES	2025-08-21 14:16:28.000676	es_ES
58	4	🔧 Tipo C - Quiz=4 - es_ES	type_c	🔧 Descripción Tipo C - Quiz=4 - es_ES	2025-08-21 14:16:28.000676	es_ES
59	4	🔧 Type A - Quiz=4 - fr_FR	type_a	🔧 Description Type A - Quiz=4 - fr_FR	2025-08-21 14:16:28.000676	fr_FR
60	4	🔧 Type B - Quiz=4 - fr_FR	type_b	🔧 Description Type B - Quiz=4 - fr_FR	2025-08-21 14:16:28.000676	fr_FR
61	4	🔧 Type C - Quiz=4 - fr_FR	type_c	🔧 Description Type C - Quiz=4 - fr_FR	2025-08-21 14:16:28.000676	fr_FR
62	5	🔧 Type A - Quiz=5 - en_US	type_a	🔧 Description Type A - Quiz=5 - en_US	2025-08-21 14:16:28.001047	en_US
63	5	🔧 Type B - Quiz=5 - en_US	type_b	🔧 Description Type B - Quiz=5 - en_US	2025-08-21 14:16:28.001047	en_US
64	5	🔧 Type C - Quiz=5 - en_US	type_c	🔧 Description Type C - Quiz=5 - en_US	2025-08-21 14:16:28.001047	en_US
65	5	🔧 Tipo A - Quiz=5 - pt_BR	type_a	🔧 Descrição Tipo A - Quiz=5 - pt_BR	2025-08-21 14:16:28.001047	pt_BR
66	5	🔧 Tipo B - Quiz=5 - pt_BR	type_b	🔧 Descrição Tipo B - Quiz=5 - pt_BR	2025-08-21 14:16:28.001047	pt_BR
67	5	🔧 Tipo C - Quiz=5 - pt_BR	type_c	🔧 Descrição Tipo C - Quiz=5 - pt_BR	2025-08-21 14:16:28.001047	pt_BR
68	5	🔧 Tipo A - Quiz=5 - es_ES	type_a	🔧 Descripción Tipo A - Quiz=5 - es_ES	2025-08-21 14:16:28.001047	es_ES
69	5	🔧 Tipo B - Quiz=5 - es_ES	type_b	🔧 Descripción Tipo B - Quiz=5 - es_ES	2025-08-21 14:16:28.001047	es_ES
70	5	🔧 Tipo C - Quiz=5 - es_ES	type_c	🔧 Descripción Tipo C - Quiz=5 - es_ES	2025-08-21 14:16:28.001047	es_ES
71	5	🔧 Type A - Quiz=5 - fr_FR	type_a	🔧 Description Type A - Quiz=5 - fr_FR	2025-08-21 14:16:28.001047	fr_FR
72	5	🔧 Type B - Quiz=5 - fr_FR	type_b	🔧 Description Type B - Quiz=5 - fr_FR	2025-08-21 14:16:28.001047	fr_FR
73	5	🔧 Type C - Quiz=5 - fr_FR	type_c	🔧 Description Type C - Quiz=5 - fr_FR	2025-08-21 14:16:28.001047	fr_FR
74	6	🔧 Type A - Quiz=6 - en_US	type_a	🔧 Description Type A - Quiz=6 - en_US	2025-08-21 14:16:28.002201	en_US
75	6	🔧 Type B - Quiz=6 - en_US	type_b	🔧 Description Type B - Quiz=6 - en_US	2025-08-21 14:16:28.002201	en_US
76	6	🔧 Type C - Quiz=6 - en_US	type_c	🔧 Description Type C - Quiz=6 - en_US	2025-08-21 14:16:28.002201	en_US
77	6	🔧 Tipo A - Quiz=6 - pt_BR	type_a	🔧 Descrição Tipo A - Quiz=6 - pt_BR	2025-08-21 14:16:28.002201	pt_BR
78	6	🔧 Tipo B - Quiz=6 - pt_BR	type_b	🔧 Descrição Tipo B - Quiz=6 - pt_BR	2025-08-21 14:16:28.002201	pt_BR
79	6	🔧 Tipo C - Quiz=6 - pt_BR	type_c	🔧 Descrição Tipo C - Quiz=6 - pt_BR	2025-08-21 14:16:28.002201	pt_BR
80	6	🔧 Tipo A - Quiz=6 - es_ES	type_a	🔧 Descripción Tipo A - Quiz=6 - es_ES	2025-08-21 14:16:28.002201	es_ES
81	6	🔧 Tipo B - Quiz=6 - es_ES	type_b	🔧 Descripción Tipo B - Quiz=6 - es_ES	2025-08-21 14:16:28.002201	es_ES
82	6	🔧 Tipo C - Quiz=6 - es_ES	type_c	🔧 Descripción Tipo C - Quiz=6 - es_ES	2025-08-21 14:16:28.002201	es_ES
83	6	🔧 Type A - Quiz=6 - fr_FR	type_a	🔧 Description Type A - Quiz=6 - fr_FR	2025-08-21 14:16:28.002201	fr_FR
84	6	🔧 Type B - Quiz=6 - fr_FR	type_b	🔧 Description Type B - Quiz=6 - fr_FR	2025-08-21 14:16:28.002201	fr_FR
85	6	🔧 Type C - Quiz=6 - fr_FR	type_c	🔧 Description Type C - Quiz=6 - fr_FR	2025-08-21 14:16:28.002201	fr_FR
86	1	The Communicator	communicator	You value open and honest communication above all else. You believe that talking through problems and expressing feelings clearly is the foundation of any strong relationship.	2025-08-21 16:34:09.774079	en_US
87	1	The Nurturer	nurturer	You are naturally caring and supportive. You show love through acts of service, physical affection, and by always being there for your partner when they need you most.	2025-08-21 16:34:09.774079	en_US
88	1	The Independent	independent	You value personal space and autonomy in relationships. You believe that two whole individuals make a stronger partnership than two people who lose themselves in each other.	2025-08-21 16:34:09.774079	en_US
89	1	The Harmonizer	harmonizer	You prioritize peace and balance in your relationships. You are skilled at finding compromises and creating an atmosphere where both partners feel heard and valued.	2025-08-21 16:34:09.774079	en_US
90	1	The Loyalist	loyalist	Trust and commitment are your core values. Once you commit to someone, you are incredibly dedicated and expect the same level of loyalty and reliability in return.	2025-08-21 16:34:09.774079	en_US
91	1	O Comunicador	communicator	Você valoriza a comunicação aberta e honesta acima de tudo. Acredita que conversar sobre problemas e expressar sentimentos claramente é a base de qualquer relacionamento forte.	2025-08-21 16:34:09.774079	pt_BR
92	1	O Cuidador	nurturer	Você é naturalmente carinhoso e solidário. Demonstra amor através de atos de serviço, carinho físico e estando sempre presente quando seu parceiro mais precisa.	2025-08-21 16:34:09.774079	pt_BR
93	1	O Independente	independent	Você valoriza espaço pessoal e autonomia nos relacionamentos. Acredita que dois indivíduos completos formam uma parceria mais forte do que duas pessoas que se perdem uma na outra.	2025-08-21 16:34:09.774079	pt_BR
94	1	O Harmonizador	harmonizer	Você prioriza paz e equilíbrio em seus relacionamentos. É hábil em encontrar compromissos e criar uma atmosfera onde ambos os parceiros se sentem ouvidos e valorizados.	2025-08-21 16:34:09.774079	pt_BR
95	1	O Leal	loyalist	Confiança e comprometimento são seus valores centrais. Uma vez que se compromete com alguém, você é incrivelmente dedicado e espera o mesmo nível de lealdade e confiabilidade em troca.	2025-08-21 16:34:09.774079	pt_BR
96	1	El Comunicador	communicator	Valoras la comunicación abierta y honesta por encima de todo. Crees que hablar sobre los problemas y expresar los sentimientos claramente es la base de cualquier relación sólida.	2025-08-21 16:34:09.774079	es_ES
97	1	El Cuidador	nurturer	Eres naturalmente cariñoso y solidario. Muestras amor a través de actos de servicio, afecto físico y estando siempre ahí para tu pareja cuando más te necesita.	2025-08-21 16:34:09.774079	es_ES
98	1	El Independiente	independent	Valoras el espacio personal y la autonomía en las relaciones. Crees que dos individuos completos forman una asociación más fuerte que dos personas que se pierden el uno en el otro.	2025-08-21 16:34:09.774079	es_ES
99	1	El Armonizador	harmonizer	Priorizas la paz y el equilibrio en tus relaciones. Eres hábil encontrando compromisos y creando una atmósfera donde ambos compañeros se sienten escuchados y valorados.	2025-08-21 16:34:09.774079	es_ES
100	1	El Leal	loyalist	La confianza y el compromiso son tus valores centrales. Una vez que te comprometes con alguien, eres increíblemente dedicado y esperas el mismo nivel de lealtad y confiabilidad a cambio.	2025-08-21 16:34:09.774079	es_ES
101	1	Le Communicateur	communicator	Vous valorisez la communication ouverte et honnête par-dessus tout. Vous croyez que parler des problèmes et exprimer clairement les sentiments est la base de toute relation solide.	2025-08-21 16:34:09.774079	fr_FR
102	1	Le Bienveillant	nurturer	Vous êtes naturellement attentionné et solidaire. Vous montrez votre amour par des actes de service, de l'affection physique et en étant toujours là pour votre partenaire quand il en a le plus besoin.	2025-08-21 16:34:09.774079	fr_FR
103	1	L'Indépendant	independent	Vous valorisez l'espace personnel et l'autonomie dans les relations. Vous croyez que deux individus complets forment un partenariat plus fort que deux personnes qui se perdent l'une dans l'autre.	2025-08-21 16:34:09.774079	fr_FR
104	1	L'Harmonisateur	harmonizer	Vous priorisez la paix et l'équilibre dans vos relations. Vous êtes habile à trouver des compromis et à créer une atmosphère où les deux partenaires se sentent entendus et valorisés.	2025-08-21 16:34:09.774079	fr_FR
105	1	Le Loyal	loyalist	La confiance et l'engagement sont vos valeurs centrales. Une fois que vous vous engagez envers quelqu'un, vous êtes incroyablement dévoué et attendez le même niveau de loyauté et de fiabilité en retour.	2025-08-21 16:34:09.774079	fr_FR
\.


--
-- Data for Name: question_weights; Type: TABLE DATA; Schema: public; Owner: quiz_user
--

COPY public.question_weights (id, quiz_id, question_id, weight_multiplier, importance_level, is_required, created_at) FROM stdin;
7	2	31	2.00	high	t	2025-08-21 15:04:17.704356
8	2	32	2.00	high	t	2025-08-21 15:04:17.704356
9	2	33	2.00	normal	t	2025-08-21 15:04:17.704356
12	2	36	2.00	high	t	2025-08-21 15:04:17.704356
13	2	37	2.00	high	t	2025-08-21 15:04:17.704356
14	2	38	2.00	normal	t	2025-08-21 15:04:17.704356
17	2	41	2.00	high	t	2025-08-21 15:04:17.704356
18	2	42	2.00	high	t	2025-08-21 15:04:17.704356
19	2	43	2.00	normal	t	2025-08-21 15:04:17.704356
22	2	46	2.00	high	t	2025-08-21 15:04:17.704356
23	2	47	2.00	high	t	2025-08-21 15:04:17.704356
24	2	48	2.00	normal	t	2025-08-21 15:04:17.704356
26	3	50	2.00	high	t	2025-08-21 15:04:17.704356
28	3	52	2.00	high	t	2025-08-21 15:04:17.704356
29	3	53	2.00	normal	t	2025-08-21 15:04:17.704356
30	3	54	2.00	normal	t	2025-08-21 15:04:17.704356
31	3	55	2.00	high	t	2025-08-21 15:04:17.704356
33	3	57	2.00	high	t	2025-08-21 15:04:17.704356
34	3	58	2.00	normal	t	2025-08-21 15:04:17.704356
35	3	59	2.00	normal	t	2025-08-21 15:04:17.704356
36	3	60	2.00	high	t	2025-08-21 15:04:17.704356
38	3	62	2.00	high	t	2025-08-21 15:04:17.704356
39	3	63	2.00	normal	t	2025-08-21 15:04:17.704356
40	3	64	2.00	normal	t	2025-08-21 15:04:17.704356
41	3	65	2.00	high	t	2025-08-21 15:04:17.704356
43	3	67	2.00	high	t	2025-08-21 15:04:17.704356
44	3	68	2.00	normal	t	2025-08-21 15:04:17.704356
45	3	69	2.00	normal	t	2025-08-21 15:04:17.704356
46	4	70	2.00	high	t	2025-08-21 15:04:17.704356
47	4	71	2.00	high	t	2025-08-21 15:04:17.704356
49	4	73	2.00	normal	t	2025-08-21 15:04:17.704356
50	4	74	2.00	normal	t	2025-08-21 15:04:17.704356
51	4	75	2.00	high	t	2025-08-21 15:04:17.704356
52	4	76	2.00	high	t	2025-08-21 15:04:17.704356
54	4	78	2.00	normal	t	2025-08-21 15:04:17.704356
55	4	79	2.00	normal	t	2025-08-21 15:04:17.704356
56	4	80	2.00	high	t	2025-08-21 15:04:17.704356
57	4	81	2.00	high	t	2025-08-21 15:04:17.704356
59	4	83	2.00	normal	t	2025-08-21 15:04:17.704356
60	4	84	2.00	normal	t	2025-08-21 15:04:17.704356
61	4	85	2.00	high	t	2025-08-21 15:04:17.704356
62	4	86	2.00	high	t	2025-08-21 15:04:17.704356
64	4	88	2.00	normal	t	2025-08-21 15:04:17.704356
65	4	89	2.00	normal	t	2025-08-21 15:04:17.704356
66	5	90	2.00	high	t	2025-08-21 15:04:17.704356
67	5	91	2.00	high	t	2025-08-21 15:04:17.704356
68	5	92	2.00	high	t	2025-08-21 15:04:17.704356
70	5	94	2.00	normal	t	2025-08-21 15:04:17.704356
71	5	95	2.00	high	t	2025-08-21 15:04:17.704356
72	5	96	2.00	high	t	2025-08-21 15:04:17.704356
73	5	97	2.00	high	t	2025-08-21 15:04:17.704356
75	5	99	2.00	normal	t	2025-08-21 15:04:17.704356
76	5	100	2.00	high	t	2025-08-21 15:04:17.704356
77	5	101	2.00	high	t	2025-08-21 15:04:17.704356
78	5	102	2.00	high	t	2025-08-21 15:04:17.704356
80	5	104	2.00	normal	t	2025-08-21 15:04:17.704356
81	5	105	2.00	high	t	2025-08-21 15:04:17.704356
82	5	106	2.00	high	t	2025-08-21 15:04:17.704356
83	5	107	2.00	high	t	2025-08-21 15:04:17.704356
85	5	109	2.00	normal	t	2025-08-21 15:04:17.704356
87	6	111	2.00	high	t	2025-08-21 15:04:17.704356
88	6	112	2.00	high	t	2025-08-21 15:04:17.704356
89	6	113	2.00	normal	t	2025-08-21 15:04:17.704356
90	6	114	2.00	normal	t	2025-08-21 15:04:17.704356
92	6	116	2.00	high	t	2025-08-21 15:04:17.704356
93	6	117	2.00	high	t	2025-08-21 15:04:17.704356
94	6	118	2.00	normal	t	2025-08-21 15:04:17.704356
95	6	119	2.00	normal	t	2025-08-21 15:04:17.704356
97	6	121	2.00	high	t	2025-08-21 15:04:17.704356
98	6	122	2.00	high	t	2025-08-21 15:04:17.704356
99	6	123	2.00	normal	t	2025-08-21 15:04:17.704356
100	6	124	2.00	normal	t	2025-08-21 15:04:17.704356
102	6	126	2.00	high	t	2025-08-21 15:04:17.704356
103	6	127	2.00	high	t	2025-08-21 15:04:17.704356
104	6	128	2.00	normal	t	2025-08-21 15:04:17.704356
105	6	129	2.00	normal	t	2025-08-21 15:04:17.704356
6	2	30	2.50	high	t	2025-08-21 15:04:17.704356
10	2	34	2.50	high	t	2025-08-21 15:04:17.704356
11	2	35	2.50	high	t	2025-08-21 15:04:17.704356
15	2	39	2.50	high	t	2025-08-21 15:04:17.704356
16	2	40	2.50	high	t	2025-08-21 15:04:17.704356
20	2	44	2.50	high	t	2025-08-21 15:04:17.704356
21	2	45	2.50	high	t	2025-08-21 15:04:17.704356
25	2	49	2.50	high	t	2025-08-21 15:04:17.704356
27	3	51	2.50	high	t	2025-08-21 15:04:17.704356
32	3	56	2.50	high	t	2025-08-21 15:04:17.704356
37	3	61	2.50	high	t	2025-08-21 15:04:17.704356
42	3	66	2.50	high	t	2025-08-21 15:04:17.704356
48	4	72	2.50	high	t	2025-08-21 15:04:17.704356
53	4	77	2.50	high	t	2025-08-21 15:04:17.704356
58	4	82	2.50	high	t	2025-08-21 15:04:17.704356
63	4	87	2.50	high	t	2025-08-21 15:04:17.704356
69	5	93	2.50	high	t	2025-08-21 15:04:17.704356
74	5	98	2.50	high	t	2025-08-21 15:04:17.704356
79	5	103	2.50	high	t	2025-08-21 15:04:17.704356
84	5	108	2.50	high	t	2025-08-21 15:04:17.704356
86	6	110	2.50	high	t	2025-08-21 15:04:17.704356
91	6	115	2.50	high	t	2025-08-21 15:04:17.704356
96	6	120	2.50	high	t	2025-08-21 15:04:17.704356
101	6	125	2.50	high	t	2025-08-21 15:04:17.704356
\.


--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: quiz_user
--

COPY public.questions (id, quiz_id, category_id, question_text, question_order, is_active, created_at, country) FROM stdin;
130	1	1	How do you typically handle conflicts in relationships?	1	t	2025-08-21 16:32:22.72212	en_US
131	1	2	What is most important to you in a relationship?	2	t	2025-08-21 16:32:22.72212	en_US
132	1	3	How do you express affection to your partner?	3	t	2025-08-21 16:32:22.72212	en_US
133	1	4	When making important decisions with a partner, you prefer to:	4	t	2025-08-21 16:32:22.72212	en_US
134	1	5	How do you react when you feel emotionally hurt by someone close?	5	t	2025-08-21 16:32:22.72212	en_US
135	1	1	Como você normalmente lida com conflitos em relacionamentos?	1	t	2025-08-21 16:32:22.732739	pt_BR
136	1	2	O que é mais importante para você em um relacionamento?	2	t	2025-08-21 16:32:22.732739	pt_BR
137	1	3	Como você expressa afeto ao seu parceiro?	3	t	2025-08-21 16:32:22.732739	pt_BR
138	1	4	Ao tomar decisões importantes com um parceiro, você prefere:	4	t	2025-08-21 16:32:22.732739	pt_BR
139	1	5	Como você reage quando se sente emocionalmente ferido por alguém próximo?	5	t	2025-08-21 16:32:22.732739	pt_BR
145	1	1	Comment gérez-vous généralement les conflits dans les relations?	1	t	2025-08-21 16:32:22.733693	fr_FR
146	1	2	Qu'est-ce qui est le plus important pour vous dans une relation?	2	t	2025-08-21 16:32:22.733693	fr_FR
147	1	3	Comment exprimez-vous l'affection à votre partenaire?	3	t	2025-08-21 16:32:22.733693	fr_FR
148	1	4	Lors de prises de décisions importantes avec un partenaire, vous préférez:	4	t	2025-08-21 16:32:22.733693	fr_FR
149	1	5	Comment réagissez-vous quand vous vous sentez blessé émotionnellement?	5	t	2025-08-21 16:32:22.733693	fr_FR
17	1	1	¿Cómo prefieres pasar una noche perfecta con tu pareja?	1	t	2025-08-16 13:58:47.412765	es_ES
19	1	2	¿Cómo manejas los conflictos en tu relación?	2	t	2025-08-16 13:58:47.413626	es_ES
21	1	3	¿Qué es lo más importante para ti en una relación?	3	t	2025-08-16 13:58:47.414351	es_ES
23	1	4	¿Cómo expresas tu amor?	4	t	2025-08-16 13:58:47.415043	es_ES
26	1	5	¿Qué te atrae más de una persona?	5	t	2025-08-16 13:58:47.416425	es_ES
30	2	4	🔧 Question 1 - Quiz=2 - en_US	1	t	2025-08-21 14:16:27.987505	en_US
31	2	4	🔧 Question 2 - Quiz=2 - en_US	2	t	2025-08-21 14:16:27.987505	en_US
32	2	4	🔧 Question 3 - Quiz=2 - en_US	3	t	2025-08-21 14:16:27.987505	en_US
33	2	4	🔧 Question 4 - Quiz=2 - en_US	4	t	2025-08-21 14:16:27.987505	en_US
34	2	1	🔧 Question 5 - Quiz=2 - en_US	5	t	2025-08-21 14:16:27.987505	en_US
35	2	4	🔧 Pergunta 1 - Quiz=2 - pt_BR	1	t	2025-08-21 14:16:27.987505	pt_BR
36	2	4	🔧 Pergunta 2 - Quiz=2 - pt_BR	2	t	2025-08-21 14:16:27.987505	pt_BR
37	2	4	🔧 Pergunta 3 - Quiz=2 - pt_BR	3	t	2025-08-21 14:16:27.987505	pt_BR
38	2	4	🔧 Pergunta 4 - Quiz=2 - pt_BR	4	t	2025-08-21 14:16:27.987505	pt_BR
39	2	1	🔧 Pergunta 5 - Quiz=2 - pt_BR	5	t	2025-08-21 14:16:27.987505	pt_BR
40	2	4	🔧 Pregunta 1 - Quiz=2 - es_ES	1	t	2025-08-21 14:16:27.987505	es_ES
41	2	4	🔧 Pregunta 2 - Quiz=2 - es_ES	2	t	2025-08-21 14:16:27.987505	es_ES
42	2	4	🔧 Pregunta 3 - Quiz=2 - es_ES	3	t	2025-08-21 14:16:27.987505	es_ES
43	2	4	🔧 Pregunta 4 - Quiz=2 - es_ES	4	t	2025-08-21 14:16:27.987505	es_ES
44	2	1	🔧 Pregunta 5 - Quiz=2 - es_ES	5	t	2025-08-21 14:16:27.987505	es_ES
45	2	4	🔧 Question 1 - Quiz=2 - fr_FR	1	t	2025-08-21 14:16:27.987505	fr_FR
46	2	4	🔧 Question 2 - Quiz=2 - fr_FR	2	t	2025-08-21 14:16:27.987505	fr_FR
47	2	4	🔧 Question 3 - Quiz=2 - fr_FR	3	t	2025-08-21 14:16:27.987505	fr_FR
48	2	4	🔧 Question 4 - Quiz=2 - fr_FR	4	t	2025-08-21 14:16:27.987505	fr_FR
49	2	1	🔧 Question 5 - Quiz=2 - fr_FR	5	t	2025-08-21 14:16:27.987505	fr_FR
50	3	3	🔧 Question 1 - Quiz=3 - en_US	1	t	2025-08-21 14:16:27.991633	en_US
51	3	3	🔧 Question 2 - Quiz=3 - en_US	2	t	2025-08-21 14:16:27.991633	en_US
52	3	3	🔧 Question 3 - Quiz=3 - en_US	3	t	2025-08-21 14:16:27.991633	en_US
53	3	3	🔧 Question 4 - Quiz=3 - en_US	4	t	2025-08-21 14:16:27.991633	en_US
54	3	2	🔧 Question 5 - Quiz=3 - en_US	5	t	2025-08-21 14:16:27.991633	en_US
55	3	3	🔧 Pergunta 1 - Quiz=3 - pt_BR	1	t	2025-08-21 14:16:27.991633	pt_BR
56	3	3	🔧 Pergunta 2 - Quiz=3 - pt_BR	2	t	2025-08-21 14:16:27.991633	pt_BR
57	3	3	🔧 Pergunta 3 - Quiz=3 - pt_BR	3	t	2025-08-21 14:16:27.991633	pt_BR
58	3	3	🔧 Pergunta 4 - Quiz=3 - pt_BR	4	t	2025-08-21 14:16:27.991633	pt_BR
59	3	2	🔧 Pergunta 5 - Quiz=3 - pt_BR	5	t	2025-08-21 14:16:27.991633	pt_BR
60	3	3	🔧 Pregunta 1 - Quiz=3 - es_ES	1	t	2025-08-21 14:16:27.991633	es_ES
61	3	3	🔧 Pregunta 2 - Quiz=3 - es_ES	2	t	2025-08-21 14:16:27.991633	es_ES
62	3	3	🔧 Pregunta 3 - Quiz=3 - es_ES	3	t	2025-08-21 14:16:27.991633	es_ES
63	3	3	🔧 Pregunta 4 - Quiz=3 - es_ES	4	t	2025-08-21 14:16:27.991633	es_ES
64	3	2	🔧 Pregunta 5 - Quiz=3 - es_ES	5	t	2025-08-21 14:16:27.991633	es_ES
65	3	3	🔧 Question 1 - Quiz=3 - fr_FR	1	t	2025-08-21 14:16:27.991633	fr_FR
66	3	3	🔧 Question 2 - Quiz=3 - fr_FR	2	t	2025-08-21 14:16:27.991633	fr_FR
67	3	3	🔧 Question 3 - Quiz=3 - fr_FR	3	t	2025-08-21 14:16:27.991633	fr_FR
68	3	3	🔧 Question 4 - Quiz=3 - fr_FR	4	t	2025-08-21 14:16:27.991633	fr_FR
69	3	2	🔧 Question 5 - Quiz=3 - fr_FR	5	t	2025-08-21 14:16:27.991633	fr_FR
70	4	2	🔧 Question 1 - Quiz=4 - en_US	1	t	2025-08-21 14:16:27.992288	en_US
71	4	2	🔧 Question 2 - Quiz=4 - en_US	2	t	2025-08-21 14:16:27.992288	en_US
72	4	2	🔧 Question 3 - Quiz=4 - en_US	3	t	2025-08-21 14:16:27.992288	en_US
73	4	2	🔧 Question 4 - Quiz=4 - en_US	4	t	2025-08-21 14:16:27.992288	en_US
74	4	5	🔧 Question 5 - Quiz=4 - en_US	5	t	2025-08-21 14:16:27.992288	en_US
75	4	2	🔧 Pergunta 1 - Quiz=4 - pt_BR	1	t	2025-08-21 14:16:27.992288	pt_BR
76	4	2	🔧 Pergunta 2 - Quiz=4 - pt_BR	2	t	2025-08-21 14:16:27.992288	pt_BR
77	4	2	🔧 Pergunta 3 - Quiz=4 - pt_BR	3	t	2025-08-21 14:16:27.992288	pt_BR
78	4	2	🔧 Pergunta 4 - Quiz=4 - pt_BR	4	t	2025-08-21 14:16:27.992288	pt_BR
79	4	5	🔧 Pergunta 5 - Quiz=4 - pt_BR	5	t	2025-08-21 14:16:27.992288	pt_BR
80	4	2	🔧 Pregunta 1 - Quiz=4 - es_ES	1	t	2025-08-21 14:16:27.992288	es_ES
81	4	2	🔧 Pregunta 2 - Quiz=4 - es_ES	2	t	2025-08-21 14:16:27.992288	es_ES
82	4	2	🔧 Pregunta 3 - Quiz=4 - es_ES	3	t	2025-08-21 14:16:27.992288	es_ES
83	4	2	🔧 Pregunta 4 - Quiz=4 - es_ES	4	t	2025-08-21 14:16:27.992288	es_ES
84	4	5	🔧 Pregunta 5 - Quiz=4 - es_ES	5	t	2025-08-21 14:16:27.992288	es_ES
85	4	2	🔧 Question 1 - Quiz=4 - fr_FR	1	t	2025-08-21 14:16:27.992288	fr_FR
86	4	2	🔧 Question 2 - Quiz=4 - fr_FR	2	t	2025-08-21 14:16:27.992288	fr_FR
87	4	2	🔧 Question 3 - Quiz=4 - fr_FR	3	t	2025-08-21 14:16:27.992288	fr_FR
88	4	2	🔧 Question 4 - Quiz=4 - fr_FR	4	t	2025-08-21 14:16:27.992288	fr_FR
89	4	5	🔧 Question 5 - Quiz=4 - fr_FR	5	t	2025-08-21 14:16:27.992288	fr_FR
90	5	1	🔧 Question 1 - Quiz=5 - en_US	1	t	2025-08-21 14:16:27.993249	en_US
91	5	1	🔧 Question 2 - Quiz=5 - en_US	2	t	2025-08-21 14:16:27.993249	en_US
92	5	1	🔧 Question 3 - Quiz=5 - en_US	3	t	2025-08-21 14:16:27.993249	en_US
93	5	1	🔧 Question 4 - Quiz=5 - en_US	4	t	2025-08-21 14:16:27.993249	en_US
94	5	4	🔧 Question 5 - Quiz=5 - en_US	5	t	2025-08-21 14:16:27.993249	en_US
95	5	1	🔧 Pergunta 1 - Quiz=5 - pt_BR	1	t	2025-08-21 14:16:27.993249	pt_BR
96	5	1	🔧 Pergunta 2 - Quiz=5 - pt_BR	2	t	2025-08-21 14:16:27.993249	pt_BR
97	5	1	🔧 Pergunta 3 - Quiz=5 - pt_BR	3	t	2025-08-21 14:16:27.993249	pt_BR
98	5	1	🔧 Pergunta 4 - Quiz=5 - pt_BR	4	t	2025-08-21 14:16:27.993249	pt_BR
99	5	4	🔧 Pergunta 5 - Quiz=5 - pt_BR	5	t	2025-08-21 14:16:27.993249	pt_BR
100	5	1	🔧 Pregunta 1 - Quiz=5 - es_ES	1	t	2025-08-21 14:16:27.993249	es_ES
101	5	1	🔧 Pregunta 2 - Quiz=5 - es_ES	2	t	2025-08-21 14:16:27.993249	es_ES
102	5	1	🔧 Pregunta 3 - Quiz=5 - es_ES	3	t	2025-08-21 14:16:27.993249	es_ES
103	5	1	🔧 Pregunta 4 - Quiz=5 - es_ES	4	t	2025-08-21 14:16:27.993249	es_ES
104	5	4	🔧 Pregunta 5 - Quiz=5 - es_ES	5	t	2025-08-21 14:16:27.993249	es_ES
105	5	1	🔧 Question 1 - Quiz=5 - fr_FR	1	t	2025-08-21 14:16:27.993249	fr_FR
106	5	1	🔧 Question 2 - Quiz=5 - fr_FR	2	t	2025-08-21 14:16:27.993249	fr_FR
107	5	1	🔧 Question 3 - Quiz=5 - fr_FR	3	t	2025-08-21 14:16:27.993249	fr_FR
108	5	1	🔧 Question 4 - Quiz=5 - fr_FR	4	t	2025-08-21 14:16:27.993249	fr_FR
109	5	4	🔧 Question 5 - Quiz=5 - fr_FR	5	t	2025-08-21 14:16:27.993249	fr_FR
110	6	5	🔧 Question 1 - Quiz=6 - en_US	1	t	2025-08-21 14:16:27.996723	en_US
111	6	5	🔧 Question 2 - Quiz=6 - en_US	2	t	2025-08-21 14:16:27.996723	en_US
112	6	5	🔧 Question 3 - Quiz=6 - en_US	3	t	2025-08-21 14:16:27.996723	en_US
113	6	5	🔧 Question 4 - Quiz=6 - en_US	4	t	2025-08-21 14:16:27.996723	en_US
114	6	4	🔧 Question 5 - Quiz=6 - en_US	5	t	2025-08-21 14:16:27.996723	en_US
115	6	5	🔧 Pergunta 1 - Quiz=6 - pt_BR	1	t	2025-08-21 14:16:27.996723	pt_BR
116	6	5	🔧 Pergunta 2 - Quiz=6 - pt_BR	2	t	2025-08-21 14:16:27.996723	pt_BR
117	6	5	🔧 Pergunta 3 - Quiz=6 - pt_BR	3	t	2025-08-21 14:16:27.996723	pt_BR
118	6	5	🔧 Pergunta 4 - Quiz=6 - pt_BR	4	t	2025-08-21 14:16:27.996723	pt_BR
119	6	4	🔧 Pergunta 5 - Quiz=6 - pt_BR	5	t	2025-08-21 14:16:27.996723	pt_BR
120	6	5	🔧 Pregunta 1 - Quiz=6 - es_ES	1	t	2025-08-21 14:16:27.996723	es_ES
121	6	5	🔧 Pregunta 2 - Quiz=6 - es_ES	2	t	2025-08-21 14:16:27.996723	es_ES
122	6	5	🔧 Pregunta 3 - Quiz=6 - es_ES	3	t	2025-08-21 14:16:27.996723	es_ES
123	6	5	🔧 Pregunta 4 - Quiz=6 - es_ES	4	t	2025-08-21 14:16:27.996723	es_ES
124	6	4	🔧 Pregunta 5 - Quiz=6 - es_ES	5	t	2025-08-21 14:16:27.996723	es_ES
125	6	5	🔧 Question 1 - Quiz=6 - fr_FR	1	t	2025-08-21 14:16:27.996723	fr_FR
126	6	5	🔧 Question 2 - Quiz=6 - fr_FR	2	t	2025-08-21 14:16:27.996723	fr_FR
127	6	5	🔧 Question 3 - Quiz=6 - fr_FR	3	t	2025-08-21 14:16:27.996723	fr_FR
128	6	5	🔧 Question 4 - Quiz=6 - fr_FR	4	t	2025-08-21 14:16:27.996723	fr_FR
129	6	4	🔧 Question 5 - Quiz=6 - fr_FR	5	t	2025-08-21 14:16:27.996723	fr_FR
\.


--
-- Data for Name: quiz_images; Type: TABLE DATA; Schema: public; Owner: sidneygoldbach
--

COPY public.quiz_images (id, quiz_id, image_url, image_type, title, description, display_order, is_active, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: quiz_sessions; Type: TABLE DATA; Schema: public; Owner: quiz_user
--

COPY public.quiz_sessions (id, session_id, email, payment_status, quiz_answers, result_type, created_at, updated_at, quiz_id, personality_type_id, detailed_scores) FROM stdin;
4	test_session_789	\N	pending	[1, 2, 1, 2, 1]	nurturer	2025-08-16 11:49:28.575717	2025-08-16 11:49:28.575717	1	7	{"maxScore": 7, "calculatedAt": "2025-08-16T18:49:28.575Z", "personalityScores": {"loyalist": 5, "nurturer": 7, "harmonizer": 2, "independent": 6, "communicator": 0}, "winningPersonalityType": "nurturer"}
5	quiz_1755370213429_yti3pelf5	\N	pending	[1, 1, 1, 1, 1]	loyalist	2025-08-16 11:50:13.444491	2025-08-16 11:50:13.444491	1	10	{"maxScore": 10, "calculatedAt": "2025-08-16T18:50:13.434Z", "personalityScores": {"loyalist": 10, "nurturer": 1, "harmonizer": 0, "independent": 6, "communicator": 3}, "winningPersonalityType": "loyalist"}
6	quiz_1755493211790_eo1tfxi6m	\N	pending	[3, 3, 3, 3, 3, 3]	harmonizer	2025-08-17 22:00:11.811269	2025-08-17 22:00:11.811269	1	8	{"maxScore": 10, "calculatedAt": "2025-08-18T05:00:11.810Z", "personalityScores": {"loyalist": 3, "nurturer": 4, "harmonizer": 10, "independent": 4, "communicator": 4}, "winningPersonalityType": "harmonizer"}
7	quiz_1755555886518_txx30dhi0	\N	pending	[3, 3, 3, 3, 3, 3]	harmonizer	2025-08-18 15:24:46.539473	2025-08-18 15:24:46.539473	1	8	{"maxScore": 10, "calculatedAt": "2025-08-18T22:24:46.538Z", "personalityScores": {"loyalist": 3, "nurturer": 4, "harmonizer": 10, "independent": 4, "communicator": 4}, "winningPersonalityType": "harmonizer"}
8	quiz_1755556056512_ieuv3paaz	\N	pending	[3, 3, 3, 3, 3, 3]	harmonizer	2025-08-18 15:27:36.528901	2025-08-18 15:27:36.528901	1	8	{"maxScore": 10, "calculatedAt": "2025-08-18T22:27:36.517Z", "personalityScores": {"loyalist": 3, "nurturer": 4, "harmonizer": 10, "independent": 4, "communicator": 4}, "winningPersonalityType": "harmonizer"}
9	quiz_1755556774644_d6if7hljd	\N	pending	[3, 3, 3, 3, 3, 3]	harmonizer	2025-08-18 15:39:34.674803	2025-08-18 15:39:34.674803	1	8	{"maxScore": 10, "calculatedAt": "2025-08-18T22:39:34.663Z", "personalityScores": {"loyalist": 3, "nurturer": 4, "harmonizer": 10, "independent": 4, "communicator": 4}, "winningPersonalityType": "harmonizer"}
10	quiz_1755557252377_46xcob15k	\N	pending	[2, 2, 2, 2, 2, 2]	nurturer	2025-08-18 15:47:32.382673	2025-08-18 15:47:32.382673	1	7	{"maxScore": 11, "calculatedAt": "2025-08-18T22:47:32.382Z", "personalityScores": {"loyalist": 0, "nurturer": 11, "harmonizer": 7, "independent": 0, "communicator": 4}, "winningPersonalityType": "nurturer"}
11	quiz_1755557736164_pm0nvm1vg	\N	pending	[3, 3, 3, 3, 3, 3]	harmonizer	2025-08-18 15:55:36.180938	2025-08-18 15:55:36.180938	1	8	{"maxScore": 10, "calculatedAt": "2025-08-18T22:55:36.180Z", "personalityScores": {"loyalist": 3, "nurturer": 4, "harmonizer": 10, "independent": 4, "communicator": 4}, "winningPersonalityType": "harmonizer"}
12	quiz_1755557789956_s9dbjmnw7	\N	pending	[3, 3, 3, 3, 3, 3]	harmonizer	2025-08-18 15:56:29.973716	2025-08-18 15:56:29.973716	1	8	{"maxScore": 10, "calculatedAt": "2025-08-18T22:56:29.963Z", "personalityScores": {"loyalist": 3, "nurturer": 4, "harmonizer": 10, "independent": 4, "communicator": 4}, "winningPersonalityType": "harmonizer"}
13	quiz_1755561936668_7xwi2vuuy	\N	pending	[2, 2, 2, 2, 2, 2]	nurturer	2025-08-18 17:05:36.675748	2025-08-18 17:05:36.675748	1	7	{"maxScore": 11, "calculatedAt": "2025-08-19T00:05:36.675Z", "personalityScores": {"loyalist": 0, "nurturer": 11, "harmonizer": 7, "independent": 0, "communicator": 4}, "winningPersonalityType": "nurturer"}
14	quiz_1755561984100_86w6iu6ba	\N	pending	[0, 0, 0, 0, 0, 0]	communicator	2025-08-18 17:06:24.11541	2025-08-18 17:06:24.11541	1	6	{"maxScore": 14, "calculatedAt": "2025-08-19T00:06:24.104Z", "personalityScores": {"loyalist": 1, "nurturer": 3, "harmonizer": 2, "independent": 4, "communicator": 14}, "winningPersonalityType": "communicator"}
15	quiz_1755563772420_aoner2qud	\N	pending	[2, 2, 2, 2, 2, 2]	nurturer	2025-08-18 17:36:12.427279	2025-08-18 17:36:12.427279	1	7	{"maxScore": 11, "calculatedAt": "2025-08-19T00:36:12.426Z", "personalityScores": {"loyalist": 0, "nurturer": 11, "harmonizer": 7, "independent": 0, "communicator": 4}, "winningPersonalityType": "nurturer"}
16	quiz_1755566608629_r5qyjzgy9	\N	pending	[2, 2, 2, 2, 2, 2]	nurturer	2025-08-18 18:23:28.634675	2025-08-18 18:23:28.634675	1	7	{"maxScore": 11, "calculatedAt": "2025-08-19T01:23:28.634Z", "personalityScores": {"loyalist": 0, "nurturer": 11, "harmonizer": 7, "independent": 0, "communicator": 4}, "winningPersonalityType": "nurturer"}
17	quiz_1755566635899_jmr3wmz4j	\N	pending	[3, 3, 3, 3, 3, 3]	harmonizer	2025-08-18 18:23:55.905376	2025-08-18 18:23:55.905376	1	8	{"maxScore": 10, "calculatedAt": "2025-08-19T01:23:55.904Z", "personalityScores": {"loyalist": 3, "nurturer": 4, "harmonizer": 10, "independent": 4, "communicator": 4}, "winningPersonalityType": "harmonizer"}
18	quiz_1755635765081_lliq67uhu	\N	pending	[1, 1, 1, 1, 1, 1]	loyalist	2025-08-19 13:36:05.096102	2025-08-19 13:36:05.096102	1	10	{"maxScore": 10, "calculatedAt": "2025-08-19T20:36:05.095Z", "personalityScores": {"loyalist": 10, "nurturer": 4, "harmonizer": 0, "independent": 6, "communicator": 5}, "winningPersonalityType": "loyalist"}
19	quiz_1755635799615_qqaigdnvr	\N	pending	[2, 2, 2, 2, 2, 2]	nurturer	2025-08-19 13:36:39.622412	2025-08-19 13:36:39.622412	1	7	{"maxScore": 11, "calculatedAt": "2025-08-19T20:36:39.617Z", "personalityScores": {"loyalist": 0, "nurturer": 11, "harmonizer": 7, "independent": 0, "communicator": 4}, "winningPersonalityType": "nurturer"}
20	quiz_1755636616111_7imdj9x9o	\N	pending	[2, 2, 2, 2, 2, 2]	nurturer	2025-08-19 13:50:16.122758	2025-08-19 13:50:16.122758	1	7	{"maxScore": 11, "calculatedAt": "2025-08-19T20:50:16.114Z", "personalityScores": {"loyalist": 0, "nurturer": 11, "harmonizer": 7, "independent": 0, "communicator": 4}, "winningPersonalityType": "nurturer"}
21	quiz_1755636642861_cxejw8bij	\N	pending	[0, 0, 0, 0, 0, 0]	communicator	2025-08-19 13:50:42.872911	2025-08-19 13:50:42.872911	1	6	{"maxScore": 14, "calculatedAt": "2025-08-19T20:50:42.864Z", "personalityScores": {"loyalist": 1, "nurturer": 3, "harmonizer": 2, "independent": 4, "communicator": 14}, "winningPersonalityType": "communicator"}
22	quiz_1755640326451_oots3u0y2	\N	pending	[1, 1, 1, 1, 1, 1]	loyalist	2025-08-19 14:52:06.465502	2025-08-19 14:52:06.465502	1	10	{"maxScore": 10, "calculatedAt": "2025-08-19T21:52:06.465Z", "personalityScores": {"loyalist": 10, "nurturer": 4, "harmonizer": 0, "independent": 6, "communicator": 5}, "winningPersonalityType": "loyalist"}
23	quiz_1755642476455_dm7rt7mav	\N	pending	[2, 2, 2, 2, 2, 2]	nurturer	2025-08-19 15:27:56.476183	2025-08-19 15:27:56.476183	1	7	{"maxScore": 11, "calculatedAt": "2025-08-19T22:27:56.475Z", "personalityScores": {"loyalist": 0, "nurturer": 11, "harmonizer": 7, "independent": 0, "communicator": 4}, "winningPersonalityType": "nurturer"}
24	quiz_1755649436387_f3w5os3xb	\N	pending	[2, 2, 2, 2, 2, 2]	nurturer	2025-08-19 17:23:56.401816	2025-08-19 17:23:56.61032	1	7	{"maxScore": 11, "calculatedAt": "2025-08-20T00:23:56.610Z", "personalityScores": {"loyalist": 0, "nurturer": 11, "harmonizer": 7, "independent": 0, "communicator": 4}, "winningPersonalityType": "nurturer"}
26	quiz_1755649451870_kqi4l3qv0	\N	pending	[1, 1, 1, 1, 1, 1]	loyalist	2025-08-19 17:24:11.882457	2025-08-19 17:24:11.882457	1	10	{"maxScore": 10, "calculatedAt": "2025-08-20T00:24:11.874Z", "personalityScores": {"loyalist": 10, "nurturer": 4, "harmonizer": 0, "independent": 6, "communicator": 5}, "winningPersonalityType": "loyalist"}
27	quiz_1755725670133_2zhp41mqg	\N	pending	[0, 0, 0, 0, 0, 0]	communicator	2025-08-20 14:34:30.146531	2025-08-20 14:34:30.146531	1	6	{"maxScore": 14, "calculatedAt": "2025-08-20T21:34:30.145Z", "personalityScores": {"loyalist": 1, "nurturer": 3, "harmonizer": 2, "independent": 4, "communicator": 14}, "winningPersonalityType": "communicator"}
28	quiz_1755725719624_cho0t0qai	\N	pending	[0, 0, 0, 0, 0, 0]	communicator	2025-08-20 14:35:19.632028	2025-08-20 14:35:19.632028	1	6	{"maxScore": 14, "calculatedAt": "2025-08-20T21:35:19.631Z", "personalityScores": {"loyalist": 1, "nurturer": 3, "harmonizer": 2, "independent": 4, "communicator": 14}, "winningPersonalityType": "communicator"}
29	quiz_1755833567792_umiqf5jfo	\N	pending	[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]	communicator	2025-08-21 20:32:47.845867	2025-08-21 20:32:47.845867	1	6	{"maxScore": 13, "calculatedAt": "2025-08-22T03:32:47.845Z", "personalityScores": {"loyalist": 8, "nurturer": 8, "harmonizer": 2, "independent": 13, "communicator": 13}, "winningPersonalityType": "communicator"}
30	quiz_1755834183710_jt9qvt6x2	\N	pending	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]	communicator	2025-08-21 20:43:03.765957	2025-08-21 20:43:03.765957	1	6	{"maxScore": 24, "calculatedAt": "2025-08-22T03:43:03.765Z", "personalityScores": {"loyalist": 2, "nurturer": 5, "harmonizer": 3, "independent": 10, "communicator": 24}, "winningPersonalityType": "communicator"}
31	quiz_1755842064148_ntb6udsew	\N	pending	[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]	communicator	2025-08-21 22:54:24.198197	2025-08-21 22:54:24.198197	1	6	{"maxScore": 13, "calculatedAt": "2025-08-22T05:54:24.197Z", "personalityScores": {"loyalist": 8, "nurturer": 8, "harmonizer": 2, "independent": 13, "communicator": 13}, "winningPersonalityType": "communicator"}
32	quiz_1755842092634_xo5avl9vo	\N	pending	[0, 0, 0, 0, 0]	type_a	2025-08-21 22:54:52.656116	2025-08-21 22:54:52.656116	4	50	{"maxScore": 15, "calculatedAt": "2025-08-22T05:54:52.655Z", "personalityScores": {"type_a": 15, "type_b": 5, "type_c": 0}, "winningPersonalityType": "type_a"}
33	quiz_1755842134659_7fs9h4bvv	\N	pending	[3, 3, 3, 3, 3]	type_c	2025-08-21 22:55:34.682331	2025-08-21 22:55:34.682331	2	28	{"maxScore": 5, "calculatedAt": "2025-08-22T05:55:34.682Z", "personalityScores": {"type_a": 0, "type_b": 0, "type_c": 5}, "winningPersonalityType": "type_c"}
34	quiz_1755888532226_51ep68h7i	\N	pending	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]	communicator	2025-08-22 11:48:52.246258	2025-08-22 11:48:52.246258	1	6	{"maxScore": 24, "calculatedAt": "2025-08-22T18:48:52.245Z", "personalityScores": {"loyalist": 2, "nurturer": 5, "harmonizer": 3, "independent": 10, "communicator": 24}, "winningPersonalityType": "communicator"}
35	quiz_1755889081074_x5oxpvyjy	\N	pending	[1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3]	harmonizer	2025-08-22 11:58:01.090816	2025-08-22 11:58:01.090816	1	8	{"maxScore": 12, "calculatedAt": "2025-08-22T18:58:01.079Z", "personalityScores": {"loyalist": 8, "nurturer": 9, "harmonizer": 12, "independent": 10, "communicator": 6}, "winningPersonalityType": "harmonizer"}
36	quiz_1755889105355_rm0igutou	\N	pending	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]	communicator	2025-08-22 11:58:25.36322	2025-08-22 11:58:25.36322	1	6	{"maxScore": 24, "calculatedAt": "2025-08-22T18:58:25.362Z", "personalityScores": {"loyalist": 2, "nurturer": 5, "harmonizer": 3, "independent": 10, "communicator": 24}, "winningPersonalityType": "communicator"}
37	quiz_1755889415841_qg4thdusm	\N	pending	[1, 1, 1, 1, 1]	independent	2025-08-22 12:03:35.846489	2025-08-22 12:03:35.846489	1	9	{"maxScore": 6, "calculatedAt": "2025-08-22T19:03:35.846Z", "personalityScores": {"loyalist": 6, "nurturer": 4, "harmonizer": 1, "independent": 6, "communicator": 3}, "winningPersonalityType": "independent"}
38	quiz_1755889800793_3hdi8lr75	\N	pending	[1, 1, 1, 1, 1]	independent	2025-08-22 12:10:00.806858	2025-08-22 12:10:00.806858	1	9	{"maxScore": 6, "calculatedAt": "2025-08-22T19:10:00.806Z", "personalityScores": {"loyalist": 6, "nurturer": 4, "harmonizer": 1, "independent": 6, "communicator": 3}, "winningPersonalityType": "independent"}
39	quiz_1755889852771_3j0wksl0k	\N	pending	[3, 3, 3, 3, 3]	type_c	2025-08-22 12:10:52.782837	2025-08-22 12:10:52.782837	4	52	{"maxScore": 5, "calculatedAt": "2025-08-22T19:10:52.777Z", "personalityScores": {"type_a": 0, "type_b": 0, "type_c": 5}, "winningPersonalityType": "type_c"}
40	quiz_1755889876372_xqwgcs3ni	\N	pending	[1, 1, 1, 1, 1]	type_b	2025-08-22 12:11:16.375827	2025-08-22 12:11:16.375827	4	51	{"maxScore": 15, "calculatedAt": "2025-08-22T19:11:16.375Z", "personalityScores": {"type_a": 5, "type_b": 15, "type_c": 0}, "winningPersonalityType": "type_b"}
41	quiz_1755889906832_p5xj663a0	\N	pending	[1, 1, 1, 1, 1]	type_b	2025-08-22 12:11:46.83645	2025-08-22 12:11:46.83645	4	51	{"maxScore": 15, "calculatedAt": "2025-08-22T19:11:46.836Z", "personalityScores": {"type_a": 5, "type_b": 15, "type_c": 0}, "winningPersonalityType": "type_b"}
42	quiz_1755889926512_r89g1vwyb	\N	pending	[1, 1, 1, 1, 1]	independent	2025-08-22 12:12:06.51653	2025-08-22 12:12:06.51653	1	9	{"maxScore": 6, "calculatedAt": "2025-08-22T19:12:06.516Z", "personalityScores": {"loyalist": 6, "nurturer": 4, "harmonizer": 1, "independent": 6, "communicator": 3}, "winningPersonalityType": "independent"}
43	quiz_1755890330729_gaheor4j7	\N	pending	[1, 1, 1, 1, 1]	independent	2025-08-22 12:18:50.751109	2025-08-22 12:18:50.751109	1	9	{"maxScore": 6, "calculatedAt": "2025-08-22T19:18:50.750Z", "personalityScores": {"loyalist": 6, "nurturer": 4, "harmonizer": 1, "independent": 6, "communicator": 3}, "winningPersonalityType": "independent"}
44	quiz_1755890355138_vcakxt3b0	\N	pending	[1, 1, 1, 1, 1]	type_b	2025-08-22 12:19:15.141352	2025-08-22 12:19:15.141352	5	63	{"maxScore": 15, "calculatedAt": "2025-08-22T19:19:15.141Z", "personalityScores": {"type_a": 5, "type_b": 15, "type_c": 0}, "winningPersonalityType": "type_b"}
45	quiz_1755890373503_28c2xsddr	\N	pending	[1, 1, 1, 1, 1]	type_b	2025-08-22 12:19:33.512944	2025-08-22 12:19:33.512944	6	75	{"maxScore": 15, "calculatedAt": "2025-08-22T19:19:33.512Z", "personalityScores": {"type_a": 5, "type_b": 15, "type_c": 0}, "winningPersonalityType": "type_b"}
46	quiz_1755892221849_ypy37fb9w	\N	pending	[1, 1, 1, 1, 1]	independent	2025-08-22 12:50:21.883191	2025-08-22 12:50:21.883191	1	9	{"maxScore": 6, "calculatedAt": "2025-08-22T19:50:21.882Z", "personalityScores": {"loyalist": 6, "nurturer": 4, "harmonizer": 1, "independent": 6, "communicator": 3}, "winningPersonalityType": "independent"}
47	quiz_1755892409399_7bcgg3huz	\N	pending	[0, 0, 0, 0, 0]	communicator	2025-08-22 12:53:29.405136	2025-08-22 12:53:29.405136	1	6	{"maxScore": 10, "calculatedAt": "2025-08-22T19:53:29.404Z", "personalityScores": {"loyalist": 1, "nurturer": 3, "harmonizer": 1, "independent": 5, "communicator": 10}, "winningPersonalityType": "communicator"}
48	quiz_1755895922992_jsrcgbll0	\N	pending	[3, 3, 3, 3, 3]	harmonizer	2025-08-22 13:52:03.023291	2025-08-22 13:52:03.023291	1	8	{"maxScore": 11, "calculatedAt": "2025-08-22T20:52:03.022Z", "personalityScores": {"loyalist": 2, "nurturer": 2, "harmonizer": 11, "independent": 4, "communicator": 1}, "winningPersonalityType": "harmonizer"}
49	quiz_1755895946585_qopb9fghn	\N	pending	[3, 3, 3, 3, 3]	harmonizer	2025-08-22 13:52:26.593176	2025-08-22 13:52:26.593176	1	8	{"maxScore": 11, "calculatedAt": "2025-08-22T20:52:26.592Z", "personalityScores": {"loyalist": 2, "nurturer": 2, "harmonizer": 11, "independent": 4, "communicator": 1}, "winningPersonalityType": "harmonizer"}
\.


--
-- Data for Name: quizzes; Type: TABLE DATA; Schema: public; Owner: quiz_user
--

COPY public.quizzes (id, name, title, description, price, currency, is_active, created_at, updated_at, result_title, coach_type, coach_category, icon_url, coach_title, coach_description) FROM stdin;
6	🔧 personal-growth	🔧 Personal Growth Quiz	🔧 Personal growth and development quiz	100	usd	t	2025-08-21 14:16:27.98374	2025-08-21 14:16:27.98374	Personality Type	relationship	personal	\N	\N	\N
1	relationship-quiz	relationship_personal	personal	100	usd	t	2025-08-15 17:17:27.108497	2025-08-21 20:48:09.982956	Personality Type	relationship	personal	\N	\N	\N
2	🔧 professional-coach	career_development	professional	100	usd	t	2025-08-21 14:16:27.98374	2025-08-21 20:48:09.995573	Personality Type	relationship	personal	\N	\N	\N
3	🔧 romantic-coach	interview_preparation	professional	100	usd	t	2025-08-21 14:16:27.98374	2025-08-21 20:48:10.002648	Personality Type	relationship	personal	\N	\N	\N
4	🔧 family-coach	romantic_conquest	romantic	100	usd	t	2025-08-21 14:16:27.98374	2025-08-21 20:48:10.009117	Personality Type	relationship	personal	\N	\N	\N
5	🔧 friendship-coach	lasting_relationships	romantic	100	usd	t	2025-08-21 14:16:27.98374	2025-08-21 20:48:10.016928	Personality Type	relationship	personal	\N	\N	\N
\.


--
-- Data for Name: scoring_rules; Type: TABLE DATA; Schema: public; Owner: quiz_user
--

COPY public.scoring_rules (id, quiz_id, personality_type_id, rule_conditions, weight, created_at) FROM stdin;
\.


--
-- Data for Name: system_config; Type: TABLE DATA; Schema: public; Owner: quiz_user
--

COPY public.system_config (id, config_key, config_value, config_type, description, is_active, created_at, updated_at) FROM stdin;
1	quiz_price_cents	50	pricing	Quiz price in cents (Stripe format)	t	2025-08-15 18:48:52.262709	2025-08-15 18:48:52.262709
2	quiz_price_dollars	0.5	pricing	Quiz price in dollars (display format)	t	2025-08-15 18:48:52.2697	2025-08-15 18:48:52.2697
3	quiz_currency	"USD"	pricing	Currency code for payments	t	2025-08-15 18:48:52.271129	2025-08-15 18:48:52.271129
4	quiz_price_display_text	"Pay $0.50 USD"	display	Complete display text for payment buttons	t	2025-08-15 18:48:52.272318	2025-08-15 18:48:52.272318
5	default_quiz_id	1	calculation	Default quiz ID when none specified	t	2025-08-15 18:48:52.273075	2025-08-15 18:48:52.273075
6	session_id_length	32	calculation	Length of generated session IDs	t	2025-08-15 18:48:52.273894	2025-08-15 18:48:52.273894
7	cache_enabled	true	calculation	Enable quiz data caching for performance	t	2025-08-15 18:48:52.274635	2025-08-15 18:48:52.274635
\.


--
-- Data for Name: validation_rules; Type: TABLE DATA; Schema: public; Owner: quiz_user
--

COPY public.validation_rules (id, quiz_id, rule_name, rule_type, rule_config, error_message, is_active, created_at) FROM stdin;
1	1	Answer Array Validation	answer_validation	{"type": "array_check", "validation": "Array.isArray(answers)", "description": "Answers must be provided as an array"}	Answers must be an array	t	2025-08-15 18:48:52.285351
2	1	Answer Count Validation	completion_rate	{"type": "count_check", "validation": "answers.length === questions.length", "description": "Number of answers must match number of questions"}	All questions must be answered	t	2025-08-15 18:48:52.287293
3	1	Answer Index Validation	answer_validation	{"type": "index_check", "validation": "typeof answerIndex === \\"number\\" && answerIndex >= 0 && answerIndex < question.options.length", "description": "Each answer must be a valid option index"}	Invalid answer option selected	t	2025-08-15 18:48:52.287781
\.


--
-- Name: advice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: quiz_user
--

SELECT pg_catalog.setval('public.advice_id_seq', 440, true);


--
-- Name: answer_options_id_seq; Type: SEQUENCE SET; Schema: public; Owner: quiz_user
--

SELECT pg_catalog.setval('public.answer_options_id_seq', 640, true);


--
-- Name: business_rules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: quiz_user
--

SELECT pg_catalog.setval('public.business_rules_id_seq', 5, true);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: quiz_user
--

SELECT pg_catalog.setval('public.categories_id_seq', 15, true);


--
-- Name: currencies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sidneygoldbach
--

SELECT pg_catalog.setval('public.currencies_id_seq', 4, true);


--
-- Name: layout_locale_id_seq; Type: SEQUENCE SET; Schema: public; Owner: quiz_user
--

SELECT pg_catalog.setval('public.layout_locale_id_seq', 1465, true);


--
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: quiz_user
--

SELECT pg_catalog.setval('public.payments_id_seq', 79, true);


--
-- Name: personality_advice_id_seq; Type: SEQUENCE SET; Schema: public; Owner: quiz_user
--

SELECT pg_catalog.setval('public.personality_advice_id_seq', 410, true);


--
-- Name: personality_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: quiz_user
--

SELECT pg_catalog.setval('public.personality_types_id_seq', 105, true);


--
-- Name: question_weights_id_seq; Type: SEQUENCE SET; Schema: public; Owner: quiz_user
--

SELECT pg_catalog.setval('public.question_weights_id_seq', 105, true);


--
-- Name: questions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: quiz_user
--

SELECT pg_catalog.setval('public.questions_id_seq', 149, true);


--
-- Name: quiz_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sidneygoldbach
--

SELECT pg_catalog.setval('public.quiz_images_id_seq', 1, false);


--
-- Name: quiz_sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: quiz_user
--

SELECT pg_catalog.setval('public.quiz_sessions_id_seq', 49, true);


--
-- Name: quizzes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: quiz_user
--

SELECT pg_catalog.setval('public.quizzes_id_seq', 3, true);


--
-- Name: scoring_rules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: quiz_user
--

SELECT pg_catalog.setval('public.scoring_rules_id_seq', 1, false);


--
-- Name: system_config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: quiz_user
--

SELECT pg_catalog.setval('public.system_config_id_seq', 7, true);


--
-- Name: validation_rules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: quiz_user
--

SELECT pg_catalog.setval('public.validation_rules_id_seq', 3, true);


--
-- Name: advice advice_pkey; Type: CONSTRAINT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.advice
    ADD CONSTRAINT advice_pkey PRIMARY KEY (id);


--
-- Name: answer_options answer_options_pkey; Type: CONSTRAINT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.answer_options
    ADD CONSTRAINT answer_options_pkey PRIMARY KEY (id);


--
-- Name: business_rules business_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.business_rules
    ADD CONSTRAINT business_rules_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: currencies currencies_locale_key; Type: CONSTRAINT; Schema: public; Owner: sidneygoldbach
--

ALTER TABLE ONLY public.currencies
    ADD CONSTRAINT currencies_locale_key UNIQUE (locale);


--
-- Name: currencies currencies_pkey; Type: CONSTRAINT; Schema: public; Owner: sidneygoldbach
--

ALTER TABLE ONLY public.currencies
    ADD CONSTRAINT currencies_pkey PRIMARY KEY (id);


--
-- Name: layout_locale layout_locale_country_component_name_key; Type: CONSTRAINT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.layout_locale
    ADD CONSTRAINT layout_locale_country_component_name_key UNIQUE (country, component_name);


--
-- Name: layout_locale layout_locale_pkey; Type: CONSTRAINT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.layout_locale
    ADD CONSTRAINT layout_locale_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: payments payments_stripe_payment_id_key; Type: CONSTRAINT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_stripe_payment_id_key UNIQUE (stripe_payment_id);


--
-- Name: personality_advice personality_advice_pkey; Type: CONSTRAINT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.personality_advice
    ADD CONSTRAINT personality_advice_pkey PRIMARY KEY (id);


--
-- Name: personality_types personality_types_pkey; Type: CONSTRAINT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.personality_types
    ADD CONSTRAINT personality_types_pkey PRIMARY KEY (id);


--
-- Name: question_weights question_weights_pkey; Type: CONSTRAINT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.question_weights
    ADD CONSTRAINT question_weights_pkey PRIMARY KEY (id);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: quiz_images quiz_images_pkey; Type: CONSTRAINT; Schema: public; Owner: sidneygoldbach
--

ALTER TABLE ONLY public.quiz_images
    ADD CONSTRAINT quiz_images_pkey PRIMARY KEY (id);


--
-- Name: quiz_sessions quiz_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.quiz_sessions
    ADD CONSTRAINT quiz_sessions_pkey PRIMARY KEY (id);


--
-- Name: quiz_sessions quiz_sessions_session_id_key; Type: CONSTRAINT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.quiz_sessions
    ADD CONSTRAINT quiz_sessions_session_id_key UNIQUE (session_id);


--
-- Name: quizzes quizzes_pkey; Type: CONSTRAINT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.quizzes
    ADD CONSTRAINT quizzes_pkey PRIMARY KEY (id);


--
-- Name: scoring_rules scoring_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.scoring_rules
    ADD CONSTRAINT scoring_rules_pkey PRIMARY KEY (id);


--
-- Name: system_config system_config_config_key_key; Type: CONSTRAINT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.system_config
    ADD CONSTRAINT system_config_config_key_key UNIQUE (config_key);


--
-- Name: system_config system_config_pkey; Type: CONSTRAINT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.system_config
    ADD CONSTRAINT system_config_pkey PRIMARY KEY (id);


--
-- Name: validation_rules validation_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.validation_rules
    ADD CONSTRAINT validation_rules_pkey PRIMARY KEY (id);


--
-- Name: idx_advice_type_id; Type: INDEX; Schema: public; Owner: quiz_user
--

CREATE INDEX idx_advice_type_id ON public.advice USING btree (personality_type_id);


--
-- Name: idx_answer_options_question_id; Type: INDEX; Schema: public; Owner: quiz_user
--

CREATE INDEX idx_answer_options_question_id ON public.answer_options USING btree (question_id);


--
-- Name: idx_payments_session_id; Type: INDEX; Schema: public; Owner: quiz_user
--

CREATE INDEX idx_payments_session_id ON public.payments USING btree (session_id);


--
-- Name: idx_payments_stripe_id; Type: INDEX; Schema: public; Owner: quiz_user
--

CREATE INDEX idx_payments_stripe_id ON public.payments USING btree (stripe_payment_id);


--
-- Name: idx_personality_advice_type_id; Type: INDEX; Schema: public; Owner: quiz_user
--

CREATE INDEX idx_personality_advice_type_id ON public.personality_advice USING btree (personality_type_id);


--
-- Name: idx_questions_quiz_id; Type: INDEX; Schema: public; Owner: quiz_user
--

CREATE INDEX idx_questions_quiz_id ON public.questions USING btree (quiz_id);


--
-- Name: idx_quiz_images_quiz_id; Type: INDEX; Schema: public; Owner: sidneygoldbach
--

CREATE INDEX idx_quiz_images_quiz_id ON public.quiz_images USING btree (quiz_id);


--
-- Name: idx_quiz_images_type; Type: INDEX; Schema: public; Owner: sidneygoldbach
--

CREATE INDEX idx_quiz_images_type ON public.quiz_images USING btree (image_type);


--
-- Name: idx_quiz_sessions_session_id; Type: INDEX; Schema: public; Owner: quiz_user
--

CREATE INDEX idx_quiz_sessions_session_id ON public.quiz_sessions USING btree (session_id);


--
-- Name: idx_quizzes_coach_category; Type: INDEX; Schema: public; Owner: quiz_user
--

CREATE INDEX idx_quizzes_coach_category ON public.quizzes USING btree (coach_category);


--
-- Name: idx_quizzes_coach_type; Type: INDEX; Schema: public; Owner: quiz_user
--

CREATE INDEX idx_quizzes_coach_type ON public.quizzes USING btree (coach_type);


--
-- Name: idx_quizzes_is_active; Type: INDEX; Schema: public; Owner: quiz_user
--

CREATE INDEX idx_quizzes_is_active ON public.quizzes USING btree (is_active);


--
-- Name: advice advice_personality_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.advice
    ADD CONSTRAINT advice_personality_type_id_fkey FOREIGN KEY (personality_type_id) REFERENCES public.personality_types(id) ON DELETE CASCADE;


--
-- Name: answer_options answer_options_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.answer_options
    ADD CONSTRAINT answer_options_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(id) ON DELETE CASCADE;


--
-- Name: business_rules business_rules_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.business_rules
    ADD CONSTRAINT business_rules_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES public.quizzes(id) ON DELETE CASCADE;


--
-- Name: payments payments_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.quiz_sessions(session_id);


--
-- Name: personality_advice personality_advice_personality_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.personality_advice
    ADD CONSTRAINT personality_advice_personality_type_id_fkey FOREIGN KEY (personality_type_id) REFERENCES public.personality_types(id) ON DELETE CASCADE;


--
-- Name: personality_types personality_types_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.personality_types
    ADD CONSTRAINT personality_types_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES public.quizzes(id) ON DELETE CASCADE;


--
-- Name: question_weights question_weights_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.question_weights
    ADD CONSTRAINT question_weights_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(id) ON DELETE CASCADE;


--
-- Name: question_weights question_weights_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.question_weights
    ADD CONSTRAINT question_weights_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES public.quizzes(id) ON DELETE CASCADE;


--
-- Name: questions questions_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: questions questions_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES public.quizzes(id) ON DELETE CASCADE;


--
-- Name: quiz_images quiz_images_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sidneygoldbach
--

ALTER TABLE ONLY public.quiz_images
    ADD CONSTRAINT quiz_images_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES public.quizzes(id) ON DELETE CASCADE;


--
-- Name: quiz_sessions quiz_sessions_personality_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.quiz_sessions
    ADD CONSTRAINT quiz_sessions_personality_type_id_fkey FOREIGN KEY (personality_type_id) REFERENCES public.personality_types(id);


--
-- Name: quiz_sessions quiz_sessions_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.quiz_sessions
    ADD CONSTRAINT quiz_sessions_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES public.quizzes(id);


--
-- Name: scoring_rules scoring_rules_personality_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.scoring_rules
    ADD CONSTRAINT scoring_rules_personality_type_id_fkey FOREIGN KEY (personality_type_id) REFERENCES public.personality_types(id) ON DELETE CASCADE;


--
-- Name: scoring_rules scoring_rules_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.scoring_rules
    ADD CONSTRAINT scoring_rules_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES public.quizzes(id) ON DELETE CASCADE;


--
-- Name: validation_rules validation_rules_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: quiz_user
--

ALTER TABLE ONLY public.validation_rules
    ADD CONSTRAINT validation_rules_quiz_id_fkey FOREIGN KEY (quiz_id) REFERENCES public.quizzes(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--


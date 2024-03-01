CREATE TABLE IF NOT EXISTS public.country (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name character varying NOT NULL,
    name_pt character varying NOT NULL,
    alpha_2_code character(2),
    alpha_3_code character(3),
    created_at timestamp without time zone NOT NULL DEFAULT now(),
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    CONSTRAINT "PK_bf6e37c231c4f4ea56dcd887269" PRIMARY KEY (id),
    CONSTRAINT "UQ_2c5aa339240c0c3ae97fcc9dc4c" UNIQUE (name),
    CONSTRAINT "UQ_69c6da9574151020d186279419f" UNIQUE (alpha_2_code),
    CONSTRAINT "UQ_9f88595b715818e292be3472256" UNIQUE (alpha_3_code),
    CONSTRAINT "UQ_f7c67d6e048708bb13b14a0bc1a" UNIQUE (name_pt)
);
CREATE TABLE IF NOT EXISTS public.state (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name character varying NOT NULL,
    abbreviation character(2),
    country_id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL DEFAULT now(),
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    CONSTRAINT "PK_549ffd046ebab1336c3a8030a12" PRIMARY KEY (id),
    CONSTRAINT "UQ_a4925b2350673eb963998d27ec3" UNIQUE (abbreviation),
    CONSTRAINT "UQ_b2c4aef5929860729007ac32f6f" UNIQUE (name),
    CONSTRAINT "FKCountryState" FOREIGN KEY (country_id) REFERENCES public.country (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS public.city (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name character varying NOT NULL,
    country_id uuid NOT NULL,
    state_id uuid,
    created_at timestamp without time zone NOT NULL DEFAULT now(),
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    CONSTRAINT "PK_b222f51ce26f7e5ca86944a6739" PRIMARY KEY (id),
    CONSTRAINT "FKCountryCity" FOREIGN KEY (country_id) REFERENCES public.country (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT "FKStateCity" FOREIGN KEY (state_id) REFERENCES public.state (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS public.institution (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name character varying NOT NULL,
    acronym character varying(50),
    description character varying(5000),
    lattes_id character(12),
    cnpj character(14),
    image character varying,
    created_at timestamp without time zone NOT NULL DEFAULT now(),
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    latitude double precision,
    longitude double precision,
    CONSTRAINT "PK_f60ee4ff0719b7df54830b39087" PRIMARY KEY (id),
    CONSTRAINT "UQ_c50c675ba2bedbaff7192b0a30e" UNIQUE (acronym),
    CONSTRAINT "UQ_c9af99711dccbeb22b20b24cca8" UNIQUE (cnpj),
    CONSTRAINT "UQ_d218ad3566afa9e396f184fd7d5" UNIQUE (name)
);
CREATE TABLE IF NOT EXISTS public.periodical_magazine (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name character varying(600),
    issn character varying(20),
    qualis character varying(8),
    created_at timestamp without time zone NOT NULL DEFAULT now(),
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    jcr character varying(100),
    jcr_link character varying(200) DEFAULT NULL::character varying,
    CONSTRAINT "PK_35bb0df687d8879d763c1f3ae68" PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS public.great_area_expertise (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL DEFAULT now(),
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    CONSTRAINT pk_id_great_area_expertise PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS public.area_expertise (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL DEFAULT now(),
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    great_area_expertise_id uuid,
    CONSTRAINT "PK_44d189c8477ad880b9ec101d453" PRIMARY KEY (id),
    CONSTRAINT "FK_great_area_expertise" FOREIGN KEY (great_area_expertise_id) REFERENCES public.great_area_expertise (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS public.sub_area_expertise (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name character varying NOT NULL,
    area_expertise_id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL DEFAULT now(),
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    CONSTRAINT pk_id_sub_area_expertise PRIMARY KEY (id),
    CONSTRAINT sub_area_expertise_area_expertise_id_fkey FOREIGN KEY (area_expertise_id) REFERENCES public.area_expertise (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS public.area_specialty (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name character varying NOT NULL,
    sub_area_expertise_id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL DEFAULT now(),
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    CONSTRAINT pk_id_area_specialty PRIMARY KEY (id),
    CONSTRAINT area_specialty_sub_area_expertise_id_fkey FOREIGN KEY (sub_area_expertise_id) REFERENCES public.sub_area_expertise (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS public.researcher (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name character varying NOT NULL,
    lattes_id character(16),
    lattes_10_id character(10),
    last_update timestamp without time zone NOT NULL DEFAULT now(),
    citations character varying,
    orcid character(31),
    abstract character varying(5000),
    abstract_en character varying(5000),
    other_information character varying(5000),
    city_id uuid,
    country_id uuid,
    has_image boolean NOT NULL DEFAULT false,
    created_at timestamp without time zone NOT NULL DEFAULT now(),
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    qtt_publications integer,
    institution_id uuid,
    graduate_program character varying(255),
    graduation character varying(30),
    update_abstract boolean DEFAULT true,
    CONSTRAINT "PK_7b53850398061862ebe70d4ce44" PRIMARY KEY (id),
    CONSTRAINT "UQ_cd7166a27f090d19d4e985592db" UNIQUE (lattes_10_id),
    CONSTRAINT "UQ_fdf2bde0f46501e3e84ec154c32" UNIQUE (lattes_id),
    CONSTRAINT "FKCityResearcher" FOREIGN KEY (city_id) REFERENCES public.city (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT "FKCountryResearcher" FOREIGN KEY (country_id) REFERENCES public.country (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT "FKInstitutionResearcher" FOREIGN KEY (institution_id) REFERENCES public.institution (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS public.researcher_address (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    researcher_id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL DEFAULT now(),
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    city character varying(50),
    organ character varying(255),
    unity character varying(255),
    institution character varying(255),
    public_place character varying(255),
    district character varying(255),
    cep character varying(255),
    mailbox character varying(255),
    fax character varying(20),
    url_homepage character varying(300),
    telephone character varying(20),
    country character varying(100),
    uf character varying(5),
    CONSTRAINT "PK_180e58d987170694c2c11424916" PRIMARY KEY (id),
    CONSTRAINT "FKAddressResearcher" FOREIGN KEY (researcher_id) REFERENCES public.researcher (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS public.researcher_area_expertise (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    researcher_id uuid NOT NULL,
    sub_area_expertise_id uuid NOT NULL,
    "order" integer,
    created_at timestamp without time zone NOT NULL DEFAULT now(),
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    area_expertise_id uuid,
    great_area_expertise_id uuid,
    area_specialty_id uuid,
    CONSTRAINT "PK_35338c2e178fa10e7b30966a4fc" PRIMARY KEY (id),
    CONSTRAINT "FKResearcherAreaExpertise" FOREIGN KEY (researcher_id) REFERENCES public.researcher (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT "FKSubAreaExpertise" FOREIGN KEY (sub_area_expertise_id) REFERENCES public.sub_area_expertise (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT "FkAreaExpertise" FOREIGN KEY (area_expertise_id) REFERENCES public.area_expertise (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT "FkAreaSpecialty" FOREIGN KEY (area_specialty_id) REFERENCES public.area_specialty (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT "FkGreatAreaExpertise" FOREIGN KEY (great_area_expertise_id) REFERENCES public.great_area_expertise (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TYPE public.bibliographic_production_type_enum AS ENUM (
    'BOOK',
    'BOOK_CHAPTER',
    'ARTICLE',
    'WORK_IN_EVENT',
    'TEXT_IN_NEWSPAPER_MAGAZINE'
);
CREATE TABLE IF NOT EXISTS public.bibliographic_production (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    title character varying(500) NOT NULL,
    title_en character varying(500),
    type bibliographic_production_type_enum NOT NULL,
    doi character varying,
    nature character varying(50),
    year character(4),
    country_id uuid,
    language character(2),
    means_divulgation character varying(20),
    homepage character varying,
    relevance boolean NOT NULL DEFAULT false,
    scientific_divulgation boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL DEFAULT now(),
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    researcher_id uuid,
    authors character varying(1000),
    year_ integer,
    is_new boolean DEFAULT true,
    CONSTRAINT "PK_9c61219aee0513e9a1cf707a41a" PRIMARY KEY (id),
    CONSTRAINT "FKCountryResearcher" FOREIGN KEY (country_id) REFERENCES public.country (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_researcher_id FOREIGN KEY (researcher_id) REFERENCES public.researcher (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS public.software (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    created_at timestamp without time zone NOT NULL DEFAULT now(),
    title character varying,
    platform character varying,
    goal character varying,
    environment character varying,
    availability character varying,
    financing_institutionc character varying,
    researcher_id uuid,
    year smallint,
    is_new boolean DEFAULT true,
    CONSTRAINT software_pkey PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS public.patent (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    created_at timestamp without time zone NOT NULL DEFAULT now(),
    title character varying(400),
    category character varying(100),
    development_year character varying(10),
    details character varying(2500),
    researcher_id uuid,
    grant_date timestamp without time zone,
    deposit_date character varying(255),
    is_new boolean DEFAULT true,
    CONSTRAINT patent_pkey PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS public.research_report (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    created_at timestamp without time zone NOT NULL DEFAULT now(),
    researcher_id uuid,
    title character varying(400),
    project_name character varying(255),
    financing_institutionc character varying(255),
    year smallint,
    is_new boolean DEFAULT true,
    CONSTRAINT research_report_pkey PRIMARY KEY (id),
    CONSTRAINT research_report_relation_1 FOREIGN KEY (researcher_id) REFERENCES public.researcher (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS public.guidance (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    created_at timestamp without time zone NOT NULL DEFAULT now(),
    researcher_id uuid,
    title character varying(400),
    nature character varying(255),
    oriented character varying(255),
    type character varying(255),
    status character varying(100),
    year smallint,
    is_new boolean DEFAULT true,
    CONSTRAINT guidance_pkey PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS public.brand (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    created_at timestamp without time zone NOT NULL DEFAULT now(),
    title character varying(400),
    goal character varying(255),
    nature character varying(100),
    researcher_id uuid,
    year smallint,
    is_new boolean DEFAULT true,
    CONSTRAINT brand_pkey PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS public.participation_events (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    created_at timestamp without time zone NOT NULL DEFAULT now(),
    title character varying(500),
    event_name character varying(500),
    nature character varying(30),
    form_participation character varying(30),
    type_participation character varying(30),
    researcher_id uuid,
    year smallint,
    is_new boolean DEFAULT true,
    CONSTRAINT participation_events_pkey PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS public.event_organization (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    created_at timestamp without time zone NOT NULL DEFAULT now(),
    title character varying(500),
    promoter_institution character varying(500),
    nature character varying(30),
    researcher_id uuid,
    local character varying(500),
    duration_in_weeks smallint,
    year smallint,
    is_new boolean DEFAULT true,
    CONSTRAINT event_organization_pkey PRIMARY KEY (id)
);
CREATE TABLE IF NOT EXISTS public.bibliographic_production_article (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    bibliographic_production_id uuid NOT NULL,
    periodical_magazine_id uuid NOT NULL,
    volume character varying(30),
    fascicle character varying(30),
    series character varying(30),
    start_page character varying(30),
    end_page character varying(30),
    place_publication character varying,
    created_at timestamp without time zone NOT NULL DEFAULT now(),
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    periodical_magazine_name character varying(600),
    issn character varying(20),
    qualis character varying(8) DEFAULT 'SQ'::character varying,
    jcr character varying(100),
    jcr_link character varying(200),
    CONSTRAINT "PK_3a53ca9c0bd82c629e7a14ef0f4" PRIMARY KEY (id),
    CONSTRAINT "FKPeriodicalMagazineArticle" FOREIGN KEY (periodical_magazine_id) REFERENCES public.periodical_magazine (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT "FKPublicationArticle" FOREIGN KEY (bibliographic_production_id) REFERENCES public.bibliographic_production (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS public.bibliographic_production_book (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    bibliographic_production_id uuid NOT NULL,
    isbn character(13),
    qtt_volume character varying(25),
    qtt_pages character varying(25),
    num_edition_revision character varying(25),
    num_series character varying(25),
    publishing_company character varying,
    publishing_company_city character varying,
    created_at timestamp without time zone NOT NULL DEFAULT now(),
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    CONSTRAINT "PK_818a520edae9528a6d586485d18" PRIMARY KEY (id),
    CONSTRAINT "FKPublicationBook" FOREIGN KEY (bibliographic_production_id) REFERENCES public.bibliographic_production (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS public.bibliographic_production_book_chapter (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    bibliographic_production_id uuid NOT NULL,
    book_title character varying,
    isbn character(13),
    start_page character varying(25),
    end_page character varying(25),
    qtt_volume character varying(25),
    organizers character varying(500),
    num_edition_revision character varying(25),
    num_series character varying(25),
    publishing_company character varying,
    publishing_company_city character varying,
    created_at timestamp without time zone NOT NULL DEFAULT now(),
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    CONSTRAINT "PK_ccc5964c28ffa1e316b8c0c821e" PRIMARY KEY (id),
    CONSTRAINT "FKPublicationBookChapter" FOREIGN KEY (bibliographic_production_id) REFERENCES public.bibliographic_production (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS public.research_dictionary (
    research_dictionary_id uuid NOT NULL DEFAULT uuid_generate_v4(),
    term character varying(255),
    frequency integer DEFAULT 1,
    type_ character varying(30),
    CONSTRAINT research_dictionary_pkey PRIMARY KEY (research_dictionary_id),
    CONSTRAINT research_dictionary_term_type__key UNIQUE (term, type_)
);
CREATE TABLE IF NOT EXISTS public.graduate_program (
    graduate_program_id uuid NOT NULL DEFAULT uuid_generate_v4(),
    code character varying(100),
    name character varying(100) NOT NULL,
    area character varying(100),
    modality character varying(100),
    type character varying(100),
    rating character varying(5),
    institution_id uuid,
    state character varying(4) DEFAULT 'BA'::character varying,
    city character varying(100) DEFAULT 'Salvador'::character varying,
    instituicao character varying(100),
    url_image character varying(400),
    region character varying(100),
    sigla character varying(100),
    latitude character varying(100),
    longitude character varying(100),
    CONSTRAINT graduate_program_pkey PRIMARY KEY (graduate_program_id)
);
CREATE TABLE IF NOT EXISTS public.graduate_program_researcher (
    graduate_program_id uuid NOT NULL,
    researcher_id uuid NOT NULL,
    year integer NOT NULL,
    type_ character varying(100),
    CONSTRAINT graduate_program_researcher_pkey PRIMARY KEY (graduate_program_id, researcher_id, year),
    CONSTRAINT graduate_program_researcher_graduate_program_id_fkey FOREIGN KEY (graduate_program_id) REFERENCES public.graduate_program (graduate_program_id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT graduate_program_researcher_researcher_id_fkey FOREIGN KEY (researcher_id) REFERENCES public.researcher (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);
CREATE TABLE IF NOT EXISTS public.JCR (
    rank character varying,
    journalName character varying,
    jcrYear character varying,
    abbrJournal character varying,
    issn character varying DEFAULT NULL::character varying,
    eissn character varying DEFAULT NULL::character varying,
    totalCites character varying DEFAULT NULL::character varying,
    totalArticles character varying DEFAULT NULL::character varying,
    citableItems character varying DEFAULT NULL::character varying,
    citedHalfLife character varying DEFAULT NULL::character varying,
    citingHalfLife character varying DEFAULT NULL::character varying,
    jif2019 character varying DEFAULT NULL::character varying,
    url_revista character varying NOT NULL
);
CREATE TABLE IF NOT EXISTS public.researcher_production (
    researcher_production_id uuid NOT NULL DEFAULT uuid_generate_v4(),
    researcher_id uuid NOT NULL,
    articles integer,
    book_chapters integer,
    book integer,
    work_in_event integer,
    patent integer,
    software integer,
    brand integer,
    great_area text,
    area_specialty text,
    city character varying(100),
    organ character varying(100),
    CONSTRAINT researcher_production_pkey PRIMARY KEY (researcher_production_id),
    CONSTRAINT researcher_production_researcher_id_fkey FOREIGN KEY (researcher_id) REFERENCES public.researcher (id) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
);
CREATE TABLE IF NOT EXISTS public.researcher_address
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    researcher_id uuid NOT NULL,
    created_at timestamp without time zone NOT NULL DEFAULT now(),
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    city character varying(50) ,
    organ character varying(255) ,
    unity character varying(255) ,
    institution character varying(255) ,
    public_place character varying(255) ,
    district character varying(255) ,
    cep character varying(255) ,
    mailbox character varying(255) ,
    fax character varying(20) ,
    url_homepage character varying(300) ,
    telephone character varying(20) ,
    country character varying(100) ,
    uf character varying(5) ,
    CONSTRAINT "PK_180e58d987170694c2c11424916" PRIMARY KEY (id),
    CONSTRAINT "FKAddressResearcher" FOREIGN KEY (researcher_id)
        REFERENCES public.researcher (id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
create EXTENSION fuzzystrmatch;
create EXTENSION pg_trgm;
CREATE EXTENSION unaccent;
CREATE INDEX IDXT_TERM_research_dictionary ON research_dictionary (term);
CREATE INDEX IDXT__frequency_dictionary ON research_dictionary (frequency);
CREATE INDEX IDXT_TERM ON researcher_frequency (term);
CREATE INDEX IDX_NAME ON researcher (name);
CREATE INDEX IDXT_TITLE ON bibliographic_production (title);
CREATE INDEX IDX_AREA_EXPERTISE ON area_expertise (name);
CREATE INDEX IDX_bibliographic_production_year_ ON bibliographic_production (year_);
CREATE INDEX IDX_bibliographic_production_year ON bibliographic_production (YEAR);
CREATE INDEX IDXT_TERM_dictionary ON research_dictionary (term);
CREATE INDEX IDX_NAME_institution ON institution(name);
CREATE INDEX IDX_NAME_researcher_production ON researcher_production(area_specialty);
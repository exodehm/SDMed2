--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.17
-- Dumped by pg_dump version 9.5.17

-- Started on 2019-05-18 20:16:59 CEST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 244 (class 1259 OID 140279)
-- Name: perfiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.perfiles (
    id integer NOT NULL,
    nombre character varying(25),
    descripcion character varying(50)
);


ALTER TABLE public.perfiles OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 140284)
-- Name: tCorrugados; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."tCorrugados" (
    diametro integer NOT NULL,
    seccion numeric(5,3),
    peso numeric(4,2),
    id_perfil integer
);


ALTER TABLE public."tCorrugados" OWNER TO postgres;

--
-- TOC entry 2283 (class 2606 OID 140283)
-- Name: PerfilesY_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.perfiles
    ADD CONSTRAINT "PerfilesY_pkey" PRIMARY KEY (id);


--
-- TOC entry 2285 (class 2606 OID 140288)
-- Name: tCorrugados_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."tCorrugados"
    ADD CONSTRAINT "tCorrugados_pkey" PRIMARY KEY (diametro);


--
-- TOC entry 2286 (class 2606 OID 140289)
-- Name: tCorrugados_id_perfil_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."tCorrugados"
    ADD CONSTRAINT "tCorrugados_id_perfil_fkey" FOREIGN KEY (id_perfil) REFERENCES public.perfiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2019-05-18 20:17:00 CEST

--
-- PostgreSQL database dump complete
--


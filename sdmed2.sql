--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.14
-- Dumped by pg_dump version 9.5.14

-- Started on 2018-12-06 09:36:06 CET

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 1 (class 3079 OID 12435)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2356 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 699 (class 1247 OID 29607)
-- Name: concepto; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.concepto AS (
	codigo character varying(20),
	resumen character varying(50),
	descripcion text,
	descripcionhtml text,
	preciomed numeric(15,3),
	preciobloq numeric(15,3),
	naturaleza integer,
	fecha date,
	ud character varying(5),
	preciocert numeric(15,3)
);


ALTER TYPE public.concepto OWNER TO postgres;

--
-- TOC entry 667 (class 1247 OID 31544)
-- Name: borrarconcepto; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.borrarconcepto AS (
	idborrar integer,
	paso integer,
	c public.concepto
);


ALTER TYPE public.borrarconcepto OWNER TO postgres;

--
-- TOC entry 638 (class 1247 OID 27919)
-- Name: medicion; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.medicion AS (
	id integer,
	fase integer,
	tipo integer,
	comentario character varying(120),
	ud numeric,
	longitud numeric(7,3),
	anchura numeric(7,3),
	altura numeric(7,3),
	formula character varying(80),
	codpadre character varying,
	codhijo character varying,
	posicion integer
);


ALTER TYPE public.medicion OWNER TO postgres;

--
-- TOC entry 641 (class 1247 OID 41003)
-- Name: borrarmedicion; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.borrarmedicion AS (
	idborrar integer,
	paso integer,
	m public.medicion
);


ALTER TYPE public.borrarmedicion OWNER TO postgres;

--
-- TOC entry 644 (class 1247 OID 27346)
-- Name: relacion; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.relacion AS (
	id integer,
	codpadre character varying,
	codhijo character varying,
	canpres numeric(7,3),
	cancert numeric(7,3),
	posicion smallint
);


ALTER TYPE public.relacion OWNER TO postgres;

--
-- TOC entry 670 (class 1247 OID 31547)
-- Name: borrarrelacion; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.borrarrelacion AS (
	idborrar integer,
	paso integer,
	r public.relacion
);


ALTER TYPE public.borrarrelacion OWNER TO postgres;

--
-- TOC entry 661 (class 1247 OID 43458)
-- Name: color; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.color AS ENUM (
    'NORMAL',
    'BLOQUEADO',
    'DESCOMPUESTO'
);


ALTER TYPE public.color OWNER TO postgres;

--
-- TOC entry 664 (class 1247 OID 28184)
-- Name: lineamedicion; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.lineamedicion AS (
	fase integer,
	comentario character varying,
	ud numeric,
	longitud numeric,
	anchura numeric,
	altura numeric,
	formula character varying,
	parcial numeric,
	subtotal numeric,
	id integer,
	pos integer
);


ALTER TYPE public.lineamedicion OWNER TO postgres;

--
-- TOC entry 627 (class 1247 OID 25498)
-- Name: partida; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.partida AS (
	codigopadre character varying,
	codigohijo character varying,
	pos smallint,
	ud character varying,
	resumen character varying(50),
	descripcion text,
	precio numeric(15,3),
	cantidad numeric(7,3),
	nat integer,
	fec character varying
);


ALTER TYPE public.partida OWNER TO postgres;

--
-- TOC entry 241 (class 1255 OID 29869)
-- Name: actualizar_desde_nodo(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.actualizar_desde_nodo(nombretabla character varying, codigonodo character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$

DECLARE
    nuevo_precio numeric;
    r record;
    existe boolean;
    bloqueado numeric(7,3);
    tablaconceptos character varying;
    tablarelacion character varying;
    str_null_case character varying;
    --texto text;
    --borrar numeric;

BEGIN
--borrar = (SELECT preciomed FROM "PRUEBASCOMP_Conceptos"  WHERE codigo = 'P02');
IF (codigonodo = '') IS NOT FALSE THEN
	str_null_case := ' IS NULL';
ELSE
	str_null_case := ' = '||quote_literal(codigonodo);
END IF;
tablaconceptos = nombretabla || '_Conceptos';
tablarelacion = nombretabla || '_Relacion';
--primera comprobacion, que sea un precio bloqueado
EXECUTE FORMAT ('SELECT preciobloq FROM %I WHERE codigo %s',tablaconceptos,str_null_case) INTO bloqueado;
IF (bloqueado IS NOT NULL) THEN 
    nuevo_precio = bloqueado;
ELSE
    EXECUTE FORMAT ('SELECT EXISTS (SELECT codpadre FROM %I WHERE codpadre %s)',tablarelacion,str_null_case) INTO existe;
    IF existe = FALSE
        THEN
            EXECUTE FORMAT ('SELECT preciomed FROM %I WHERE codigo %s',tablaconceptos,str_null_case) INTO nuevo_precio;		
        ELSE
            EXECUTE FORMAT ('SELECT SUM(importe) FROM (SELECT C.codigo, C.resumen, C.preciomed, R.canpres, C.preciomed * R.canpres AS "importe"
		FROM %I AS C,%I AS R 
		WHERE codpadre %s AND R.codhijo = C.codigo) AS subtotal',
		tablaconceptos,tablarelacion, str_null_case) INTO nuevo_precio;	
    END IF;
END IF;
EXECUTE FORMAT ('UPDATE %I SET preciomed = %s WHERE codigo %s', tablaconceptos, quote_literal(nuevo_precio), str_null_case);
RAISE NOTICE 'El valor del nodo es: %', nuevo_precio;
EXECUTE FORMAT ('SELECT EXISTS (SELECT codhijo FROM %I WHERE codhijo %s)', tablarelacion, str_null_case) INTO existe;
IF existe = TRUE THEN
	FOR r IN EXECUTE FORMAT ('SELECT * FROM %I WHERE codhijo %s', tablarelacion, str_null_case)
	LOOP
		--RAISE NOTICE 'Hay que seguir para arriba con: %,%',r.codpadre,r.codhijo;
		EXECUTE FORMAT ('SELECT actualizar_desde_nodo(%s,%s)', quote_literal(nombretabla), 
		CASE WHEN r.codpadre IS NULL THEN 'null' ELSE quote_literal(r.codpadre) END);
	END LOOP;
END IF;
END;
$$;


ALTER FUNCTION public.actualizar_desde_nodo(nombretabla character varying, codigonodo character varying) OWNER TO postgres;

--
-- TOC entry 228 (class 1255 OID 18492)
-- Name: actualizar_parcial(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.actualizar_parcial() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

DECLARE
suma_inicial numeric;
suma_final numeric;
BEGIN

suma_inicial = (SELECT SUM(parcial) FROM mediciones WHERE id_rel_padre = OLD.id_rel_padre AND id_rel_hijo = OLD.id_rel_hijo);
RAISE NOTICE 'La cantidad inicial es: %',suma_inicial;

	NEW.parcial := NEW.ud*
CASE WHEN NEW.longitud IS NULL THEN 1 ELSE NEW.longitud END*
CASE WHEN NEW.anchura IS NULL THEN 1 ELSE NEW.anchura END*
CASE WHEN NEW.altura IS NULL THEN 1 ELSE NEW.altura END;
--RAISE NOTICE 'Valores que intervienen: %*%*%*%=%',NEW.id,NEW.longitud,NEW.anchura,NEW.altura,NEW.parcial;
--suma = (SELECT SUM(NEW.parcial) FROM mediciones);
RAISE NOTICE 'Actualizar la relacion %,%',NEW.id_rel_padre,NEW.id_rel_hijo;
suma_final= suma_inicial-OLD.parcial+NEW.parcial;
RAISE NOTICE 'La cantidad final es: %',suma_final;
UPDATE relacion SET cantidad = suma_final WHERE id_padre = NEW.id_rel_padre AND id_hijo = NEW.id_rel_hijo;
PERFORM actualizar_desde_nodo(NEW.id_rel_padre);
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.actualizar_parcial() OWNER TO postgres;

--
-- TOC entry 229 (class 1255 OID 18986)
-- Name: actualizar_partida(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.actualizar_partida() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

DECLARE
BEGIN
RAISE NOTICE 'Actualizar desde nodo: %',OLD.id;
PERFORM (actualizar_desde_nodo(OLD.id));
RETURN NEW;
END;
$$;


ALTER FUNCTION public.actualizar_partida() OWNER TO postgres;

--
-- TOC entry 230 (class 1255 OID 20163)
-- Name: anadir_obra_a_listado(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.anadir_obra_a_listado(codigo character varying, resumen character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
noexiste boolean;
BEGIN
EXECUTE format (
		'CREATE TABLE IF NOT EXISTS listaobras
		(id serial NOT NULL,
		codigo character varying(20),
		resumen character varying(50),
		CONSTRAINT "listado_pkey" PRIMARY KEY (id));'
		);
EXECUTE FORMAT ('SELECT NOT EXISTS (SELECT codigo FROM listaobras WHERE codigo = %s)', quote_literal(codigo)) INTO noexiste;
IF noexiste = TRUE THEN

EXECUTE format ('INSERT INTO %I(codigo,resumen) VALUES
		(%s,%s)',
		'listaobras',quote_literal(codigo),quote_literal(resumen));

RETURN 0;
END IF;
RETURN -1;
EXCEPTION 
    WHEN others THEN
        RAISE INFO 'Error Name:%',SQLERRM;
        RAISE INFO 'Error State:%', SQLSTATE;
        RETURN -1;
END;
$$;


ALTER FUNCTION public.anadir_obra_a_listado(codigo character varying, resumen character varying) OWNER TO postgres;

--
-- TOC entry 267 (class 1255 OID 42757)
-- Name: bloquear_precio(character varying, character varying, numeric, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.bloquear_precio(nombretabla character varying, codigo character varying, precio numeric, bloquear boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN
IF bloquear = TRUE THEN	
    EXECUTE FORMAT ('UPDATE %I SET preciobloq = %s WHERE codigo=%s',nombretabla||'_Conceptos',quote_literal(precio),quote_literal(codigo));
ELSE
    EXECUTE FORMAT ('UPDATE %I SET preciobloq = NULL WHERE codigo=%s',nombretabla||'_Conceptos',quote_literal(codigo));
END IF;
END;
$$;


ALTER FUNCTION public.bloquear_precio(nombretabla character varying, codigo character varying, precio numeric, bloquear boolean) OWNER TO postgres;

--
-- TOC entry 266 (class 1255 OID 32040)
-- Name: borrar_descompuesto1(character varying, character varying, character varying, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.borrar_descompuesto1(nombretabla character varying, codigopadre character varying, codigohijo character varying, restaurar boolean DEFAULT false) RETURNS void
    LANGUAGE plpgsql
    AS $_$ 
DECLARE
tablaconceptos character varying;
tablarelacion character varying;
tablamediciones character varying;
tablaconceptosborrar character varying;
tablarelacionborrar character varying;
tablamedicionesborrar character varying;
existe boolean;
r relacion%ROWTYPE;
c concepto%ROWTYPE;
texto text;
idmediciones integer[];
indice integer;
BEGIN
IF restaurar = FALSE THEN 
	tablaconceptos = nombretabla || '_Conceptos';
	tablaconceptosborrar = nombretabla || '_BorrarConceptos';
	tablarelacion = nombretabla || '_Relacion';	
	tablarelacionborrar = nombretabla || '_BorrarRelacion';
	tablamediciones = nombretabla || '_Mediciones';
	tablamedicionesborrar = nombretabla || 'BorrarMediciones';
ELSE 
	tablaconceptos = nombretabla || '_BorrarConceptos';
	tablaconceptosborrar = nombretabla || '_Conceptos';
	tablarelacion = nombretabla || '_BorrarRelacion';
	tablarelacionborrar = nombretabla || '_Relacion';
	tablamediciones = nombretabla || '_BorrarMediciones';
	tablamedicionesborrar = nombretabla || '_Mediciones';
END IF;

--CREO LA TABLA DE RELACIONES BORRAR
IF restaurar = FALSE THEN	
	EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I OF borrarrelacion (PRIMARY KEY (idborrar))',tablarelacionborrar);
END IF;
--METO LA RELACION PADRE HIJO EN LA TABLA DE RELACION
EXECUTE FORMAT ('SELECT * FROM %I WHERE codpadre = %s AND codhijo = %s',
		tablarelacion,quote_literal(codigopadre),quote_literal(codigohijo)) INTO r;

EXECUTE FORMAT ('INSERT INTO %I VALUES(CASE WHEN (SELECT MAX(idborrar) FROM %I) IS NULL THEN 0 ELSE (SELECT MAX(idborrar)+1 FROM %I) END
		,NULL,(%s,%s,%s,%s,%s,%s))',tablarelacionborrar,tablarelacionborrar,tablarelacionborrar,
		r.id,quote_literal(r.codpadre),quote_literal(r.codhijo),r.canpres,COALESCE(r.cancert,0),r.posicion);

--BORRO LA RELACION PADRE-HIJO EN LA TABLA ORIGINAL
EXECUTE FORMAT ('DELETE FROM %I WHERE codpadre = %s AND codhijo = %s', tablarelacion,quote_literal(codigopadre),quote_literal(codigohijo));
--VEO SI QUEDAN MAS HIJOS EN LA TABLA RELACION
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM %I WHERE codhijo = %s )',	tablarelacion , quote_literal(codigohijo)) INTO existe;
--SI NO QUEDAN MAS HIJOS:
IF existe = FALSE THEN
   --CREO LA TABLA DE CONCEPTOS BORRAR Y METO EL CONCEPTO Y LO BORRO DE LA TABLA DE CONCEPTOS
	IF restaurar = FALSE THEN	
		EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I OF borrarconcepto (PRIMARY KEY (idborrar))',tablaconceptosborrar);
	END IF;
	EXECUTE FORMAT ('SELECT * FROM %I WHERE codigo = %s',tablaconceptos,quote_literal(codigohijo)) INTO c;
	EXECUTE FORMAT ('INSERT INTO %I VALUES(CASE WHEN (SELECT MAX(idborrar) FROM %I) IS NULL THEN 0 ELSE (SELECT MAX(idborrar)+1 FROM %I) END
		,NULL,(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s))',tablaconceptosborrar,tablaconceptosborrar,tablaconceptosborrar,
		quote_literal(c.codigo),
		quote_literal(c.resumen),
		quote_literal(COALESCE(c.descripcion,'')),
		quote_literal(COALESCE(c.descripcionhtml,'')),
		quote_literal(c.preciomed),
		COALESCE(c.preciobloq::varchar,'NULL'),
		quote_literal(c.naturaleza),
		quote_literal(c.fecha),
		quote_literal(COALESCE(c.ud,'')),
		COALESCE(c.preciocert::varchar,'NULL')
		);	
	EXECUTE FORMAT ('DELETE FROM %I WHERE codigo = %s', tablaconceptos, quote_literal(codigohijo));
	--ITERO SOBRE LA TABLA RELACION EN LA QUE ESE HIJO ES PADRE EJECUTANDO LA FUNCION
	FOR r IN EXECUTE FORMAT('SELECT * FROM %I WHERE codpadre = $1',tablarelacion) USING codigohijo
	LOOP
		RAISE NOTICE 'ENTRO EN LA FUNCION CON %-%-%',nombretabla,codigohijo,r.codhijo;
		PERFORM borrar_descompuesto1(nombretabla::character varying, codigohijo::character varying, r.codhijo::character varying, restaurar);
	END LOOP;
END IF;
--AHORA LAS MEDICIONES
EXECUTE format('SELECT array_agg(id) from %I WHERE codpadre = %s AND codhijo = %s',
tablamediciones,quote_literal(codigopadre),quote_literal(codigohijo)) INTO idmediciones;
IF idmediciones IS NOT NULL THEN
    PERFORM borrar_lineas_medicion(nombretabla,idmediciones,restaurar);
END IF;
--queda la ordenacion de los elementos restantes
END;
$_$;


ALTER FUNCTION public.borrar_descompuesto1(nombretabla character varying, codigopadre character varying, codigohijo character varying, restaurar boolean) OWNER TO postgres;

--
-- TOC entry 250 (class 1255 OID 40923)
-- Name: borrar_hijos(character varying, character varying, character varying, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.borrar_hijos(nombretabla character varying, codigopadre character varying, codigohijos character varying DEFAULT NULL::character varying, restaurar boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$ 
DECLARE
num_paso integer;
tablaconceptos character varying := nombretabla || '_Conceptos';
tablarelacion character varying := nombretabla || '_Relacion';
tablaborrarconceptos character varying := nombretabla || '_BorrarConceptos';
tablaborrarrelacion character varying := nombretabla || '_BorrarRelacion';
tablaborrarmedicion character varying := nombretabla || '_BorrarMediciones';
arraycodigoshijos character varying[];
r relacion%ROWTYPE;
rb borrarrelacion%ROWTYPE;
c concepto%ROWTYPE;
cb borrarconcepto%ROWTYPE;
existe boolean;
BEGIN
IF codigohijos IS NULL THEN --SI NO HAY ARRAY DE CODIGOS HIJO BORRO TODOS LOS QUE PENDEN DEL PADRE
	EXECUTE FORMAT('SELECT array_agg(codhijo) from %I WHERE codpadre = %s',
			tablarelacion,quote_literal(codigopadre)) INTO arraycodigoshijos;	
ELSE --SI HAY CADENA DE ARRAY DE CODIGOS, LOS METO EN EL ARRAY DE LA FUNCION
	arraycodigoshijos = string_to_array(codigohijos,',');
	raise notice 'el array a borrar es: %',arraycodigoshijos;
END IF;
--FINALMENTE EJECUTO LA FUNCION
PERFORM borrar_lineas_principal(nombretabla,codigopadre,arraycodigoshijos,restaurar);
--pongo el numero de paso en la tabla de borrar
EXECUTE FORMAT ('SELECT MAX(paso)+1 FROM %I',tablaborrarrelacion) INTO num_paso;
IF num_paso IS NULL THEN num_paso = 0; END IF;
EXECUTE FORMAT ('UPDATE %I SET paso = %s WHERE paso IS NULL',tablaborrarrelacion,num_paso);
--actualizar tabla borrar conceptos
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = %s)', quote_literal(tablaborrarconceptos)) INTO existe;
IF existe IS TRUE THEN
	EXECUTE FORMAT ('UPDATE %I SET paso = %s WHERE paso IS NULL',tablaborrarconceptos,num_paso);
END IF;
--actualizar tabla borrar medicion
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = %s)', quote_literal(tablaborrarmedicion)) INTO existe;
IF existe IS TRUE THEN
	EXECUTE FORMAT ('UPDATE %I SET paso = %s WHERE paso IS NULL',tablaborrarmedicion,num_paso);
END IF;
END;
$$;


ALTER FUNCTION public.borrar_hijos(nombretabla character varying, codigopadre character varying, codigohijos character varying, restaurar boolean) OWNER TO postgres;

--
-- TOC entry 269 (class 1255 OID 43024)
-- Name: borrar_lineas_medicion(character varying, integer[], boolean, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.borrar_lineas_medicion(nombretabla character varying, ids integer[], restaurar boolean DEFAULT true, solomedicion boolean DEFAULT false) RETURNS void
    LANGUAGE plpgsql
    AS $$ 
DECLARE
    tamanno integer := array_length(ids, 1);
    indice integer := 1;
    tablamediciones character varying := nombretabla || '_Mediciones';
    tablamedicionesborrar character varying := nombretabla || '_BorrarMediciones';
    tablaborrarrelacion character varying := nombretabla || '_BorrarRelacion';
    codigopadre character varying;
    codigohijo character varying;
    m medicion%ROWTYPE;
    num_paso integer := NULL;
    existe boolean;    
--LA FUNCION TIENE DOS BOOLEANOS. SI restaurar es TRUE SE GUARDARAN LAS LINEAS DE MEDICION BORRADAS EN UNA TABLA PARA POSTERIORMENTE PODER 
--RECUPERARLAS
--POR OTRO LADO, SI LA FUNCION ES LLAMADA DESDE LA FUNCION borrar_lineas_principal, SERA ESTA LA QUE PONGA EL num_paso, PERO SI SE LLAMA
--DE FORMA DIRECTA SE PONDRA DESDE LA PROPIA FUNCION
BEGIN	
    IF tamanno IS NOT NULL THEN
	EXECUTE FORMAT ('SELECT codpadre FROM %I WHERE id = %s',tablamediciones,ids[indice]) INTO codigopadre;
	EXECUTE FORMAT ('SELECT codhijo FROM %I WHERE id = %s',tablamediciones,ids[indice]) INTO codigohijo;
	IF restaurar IS TRUE THEN
	    EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I OF borrarmedicion (PRIMARY KEY (idborrar))',tablamedicionesborrar);
	END IF;
	
	WHILE indice <= tamanno LOOP
	    IF restaurar IS TRUE THEN
		EXECUTE FORMAT ('SELECT * FROM %I WHERE %I.id = %s',tablamediciones,tablamediciones,quote_literal(ids[indice])) INTO m;            
		EXECUTE FORMAT ('INSERT INTO %I VALUES(CASE WHEN (SELECT MAX(idborrar) FROM %I) IS NULL THEN 0 ELSE (SELECT MAX(idborrar)+1 FROM %I) END
				,NULL,(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s))',tablamedicionesborrar,tablamedicionesborrar,tablamedicionesborrar,
				quote_literal(m.id),
				COALESCE(m.fase::varchar,'NULL'),
				COALESCE(m.tipo::varchar,'NULL'),
				quote_literal(COALESCE(m.comentario,'')),
				COALESCE(m.ud::varchar,'NULL'),
				COALESCE(m.longitud::varchar,'NULL'),
				COALESCE(m.anchura::varchar,'NULL'),
				COALESCE(m.altura::varchar,'NULL'),
				quote_literal(COALESCE(m.formula,'')),
				quote_literal(m.codpadre),
				quote_literal(m.codhijo),				
				COALESCE(m.posicion::varchar,'NULL')
				);
	    END IF;
            EXECUTE FORMAT ('DELETE FROM %I WHERE %I.id = %s',tablamediciones,tablamediciones,quote_literal(ids[indice]));
            PERFORM modificar_cantidad(nombretabla,codigopadre,codigohijo);
            indice = indice + 1;
	END LOOP;
	IF solomedicion IS TRUE THEN
		EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = %s)', quote_literal(tablaborrarrelacion)) INTO existe;
		IF existe IS TRUE THEN--si hay tabla de relacion cojo el num_paso de ahí
			EXECUTE FORMAT ('SELECT MAX(paso)+1 FROM %I',tablaborrarrelacion) INTO num_paso;
		ELSE EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = %s)', quote_literal(tablamedicionesborrar)) INTO existe;
			IF existe IS TRUE THEN--si no hay tabla de relacionborrar pero si hay tabla medicionborrar cojo num_paso de ahi
				EXECUTE FORMAT ('SELECT MAX(paso)+1 FROM %I',tablamedicionesborrar) INTO num_paso;			
			END IF;
		END IF;
		IF num_paso IS NULL THEN num_paso = 0; END IF;
		EXECUTE FORMAT ('UPDATE %I SET paso = %s WHERE paso IS NULL',tablamedicionesborrar,num_paso);
	END IF;
   END IF;    
   END;
$$;


ALTER FUNCTION public.borrar_lineas_medicion(nombretabla character varying, ids integer[], restaurar boolean, solomedicion boolean) OWNER TO postgres;

--
-- TOC entry 270 (class 1255 OID 41609)
-- Name: borrar_lineas_principal(character varying, character varying, character varying[], boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.borrar_lineas_principal(nombretabla character varying, codigopadre character varying, codigoshijo character varying[], restaurar boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$ 
DECLARE
tablaconceptos character varying := nombretabla || '_Conceptos';
tablaconceptosborrar character varying := nombretabla || '_BorrarConceptos';
tablarelacion character varying := nombretabla || '_Relacion';
tablarelacionborrar character varying := nombretabla || '_BorrarRelacion';
tablamediciones character varying := nombretabla || '_Mediciones';
tablamedicionesborrar character varying := nombretabla || 'BorrarMediciones';
existe boolean;
r relacion%ROWTYPE;
c concepto%ROWTYPE;
idmediciones integer[];
arraycodigoshijos character varying[];
indice integer;
BEGIN
--CREO LA TABLA DE RELACIONES BORRAR SI RESTAURAR ES TRUE Y NO EXISTE PREVIEMENTE
IF restaurar IS TRUE THEN
	raise notice 'creo la tabla relacionborARRR!';
	EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I OF borrarrelacion (PRIMARY KEY (idborrar))',tablarelacionborrar);
END IF;
IF codigoshijo IS NOT NULL THEN	
	--ITERO SOBRE EL ARRAY DE CODIGOS HIJO
	FOR I IN array_lower(codigoshijo, 1)..array_upper(codigoshijo, 1) LOOP
		--METO LA RELACION PADRE HIJO EN LA TABLA DE RELACION EN UN REGISTRO SI RESTAURAR ES TRUE
		raise notice 'itero sobre los hijos de %-%',codigopadre,codigoshijo[i];
		IF restaurar IS TRUE THEN
			EXECUTE FORMAT ('SELECT * FROM %I WHERE codpadre = %s AND codhijo = %s',
					tablarelacion,
					quote_literal(codigopadre),
					quote_literal(codigoshijo[I])) 
					INTO r;
			--METO ESE REGISTRO EN LA TABLA DE RELACION BORRAR
			EXECUTE FORMAT ('INSERT INTO %I VALUES(CASE WHEN (SELECT MAX(idborrar) FROM %I) IS NULL THEN 0 ELSE (SELECT MAX(idborrar)+1 FROM %I) END
					,NULL,(%s,%s,%s,%s,%s,%s))',tablarelacionborrar,tablarelacionborrar,tablarelacionborrar,
					r.id,quote_literal(r.codpadre),quote_literal(r.codhijo),r.canpres,COALESCE(r.cancert,0),r.posicion);
		END IF;
		--BORRO LA RELACION PADRE-HIJO EN LA TABLA ORIGINAL
		EXECUTE FORMAT ('DELETE FROM %I WHERE codpadre = %s AND codhijo = %s', tablarelacion,quote_literal(codigopadre),quote_literal(codigoshijo[I]));
		--VEO SI QUEDAN MAS HIJOS EN LA TABLA RELACION
		EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM %I WHERE codhijo = %s )',	tablarelacion , quote_literal(codigoshijo[I])) INTO existe;
		--SI NO QUEDAN MAS HIJOS:
		IF existe = FALSE THEN
		   --CREO LA TABLA DE CONCEPTOS BORRAR Y METO EL CONCEPTO Y LO BORRO DE LA TABLA DE CONCEPTOS SI restaurar ES TRUE
			IF restaurar IS TRUE THEN
				RAISE NOTICE 'CREO LA TABLA DE CONCEPTOS BORRAR';
				EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I OF borrarconcepto (PRIMARY KEY (idborrar))',tablaconceptosborrar);			
				EXECUTE FORMAT ('SELECT * FROM %I WHERE codigo = %s',tablaconceptos,quote_literal(codigoshijo[I])) INTO c;
				EXECUTE FORMAT ('INSERT INTO %I VALUES(CASE WHEN (SELECT MAX(idborrar) FROM %I) IS NULL THEN 0 ELSE (SELECT MAX(idborrar)+1 FROM %I) END
					,NULL,(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s))',tablaconceptosborrar,tablaconceptosborrar,tablaconceptosborrar,
					quote_literal(c.codigo),
					quote_literal(c.resumen),
					quote_literal(COALESCE(c.descripcion,'')),
					quote_literal(COALESCE(c.descripcionhtml,'')),
					quote_literal(c.preciomed),
					COALESCE(c.preciobloq::varchar,'NULL'),
					quote_literal(c.naturaleza),
					quote_literal(c.fecha),
					quote_literal(COALESCE(c.ud,'')),
					COALESCE(c.preciocert::varchar,'NULL')
					);
			END IF;
			--BORRO DE LA TABLA DE CONCEPTOS LOS HIJOS QUE CORRESPONDAN
			EXECUTE FORMAT ('DELETE FROM %I WHERE codigo = %s', tablaconceptos, quote_literal(codigoshijo[I]));
			--METO LOS HIJOS EN UN ARRAY Y LLAMO DE NUEVO A LA FUNCION
			EXECUTE FORMAT('SELECT array_agg(codhijo) from %I WHERE codpadre = %s',
				tablarelacion,quote_literal(codigoshijo[I])) INTO arraycodigoshijos;			
				PERFORM borrar_lineas_principal(nombretabla,codigoshijo[I],arraycodigoshijos,restaurar);			
		END IF;
		--AHORA LAS MEDICIONES
		EXECUTE format('SELECT array_agg(id) from %I WHERE codpadre = %s AND codhijo = %s',
		tablamediciones,quote_literal(codigopadre),quote_literal(codigoshijo[I])) INTO idmediciones;
		IF idmediciones IS NOT NULL THEN
		    PERFORM borrar_lineas_medicion(nombretabla,idmediciones);
		END IF;
		--queda la ordenacion de los elementos restantes
	END LOOP;
END IF;
END;
$$;


ALTER FUNCTION public.borrar_lineas_principal(nombretabla character varying, codigopadre character varying, codigoshijo character varying[], restaurar boolean) OWNER TO postgres;

--
-- TOC entry 236 (class 1255 OID 21783)
-- Name: borrar_obra(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.borrar_obra(nombretabla character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
tabla_conceptos character varying;
tabla_relacion character varying;
tabla_mediciones character varying;
tabla_borrar_mediciones character varying;
secuencia_relacion character varying;
secuencia_mediciones character varying;
BEGIN
tabla_conceptos := nombretabla || '_Conceptos';
tabla_relacion := nombretabla || '_Relacion';
tabla_mediciones := nombretabla || '_Mediciones';
tabla_borrar_mediciones := nombretabla || '_BorrarMediciones';
secuencia_relacion := tabla_relacion || '_id_seq';
secuencia_mediciones := tabla_mediciones || '_id_seq';

--borrar tabla conceptos
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_conceptos);
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_mediciones);
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_relacion);
EXECUTE FORMAT ('DROP TABLE IF EXISTS %I', tabla_borrar_mediciones);
EXECUTE FORMAT ('DROP SEQUENCE IF EXISTS public.%I',secuencia_relacion);
EXECUTE FORMAT ('DROP SEQUENCE IF EXISTS public.%I',secuencia_mediciones);
END;
$$;


ALTER FUNCTION public.borrar_obra(nombretabla character varying) OWNER TO postgres;

--
-- TOC entry 232 (class 1255 OID 21039)
-- Name: borrar_relacion(character varying, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.borrar_relacion(nombretabla character varying, idpadre integer, idhijo integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  r record;
  pos integer;
  tablarelacion character varying;
  str_null_case character varying;
BEGIN
IF idpadre IS NULL THEN
	str_null_case := ' IS NULL';
ELSE
	str_null_case := ' = '||idpadre;
END IF;
tablarelacion = nombretabla || '_Relacion';
RAISE NOTICE 'Funcion borrar_relacion(%,%,%)',nombretabla,idpadre,idhijo;
EXECUTE FORMAT ('SELECT posicion FROM %I WHERE id_padre %s AND id_hijo = %s',tablarelacion,str_null_case,idhijo) INTO pos;
--pos = (SELECT posicion FROM relacion WHERE id_padre = idpadre AND id_hijo = idhijo);
RAISE NOTICE 'borrar_relacion con % - % en la posicion: %', str_null_case, idhijo, pos;
EXECUTE FORMAT ('DELETE FROM %I WHERE id_padre %s AND id_hijo = %s',tablarelacion,str_null_case,idhijo);
--DELETE FROM relacion WHERE id_padre = idpadre AND id_hijo = idhijo;
--ahora ordeno los hijos
FOR r IN EXECUTE FORMAT ('SELECT * FROM %I WHERE id_padre %s', tablarelacion, str_null_case)
--FOR r IN SELECT * FROM relacion WHERE id_padre = idpadre
	LOOP
	 IF(r.posicion>=pos AND r.id_hijo<>idhijo) THEN
	 	EXECUTE FORMAT ('UPDATE %I SET posicion = %I.posicion-1 WHERE id_hijo = %s',
			tablarelacion, tablarelacion, quote_literal(r.id_hijo));
		RAISE NOTICE 'Ordenar los hijos % que esten despues de la posicion %',r.id_hijo,pos;
	 	
	 END IF;
	END LOOP;
END;
$$;


ALTER FUNCTION public.borrar_relacion(nombretabla character varying, idpadre integer, idhijo integer) OWNER TO postgres;

--
-- TOC entry 246 (class 1255 OID 26129)
-- Name: crear_obra(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.crear_obra(codigo character varying, resumen character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
resultado integer;
tablaconceptos character varying;
tablarelacion character varying;
BEGIN
resultado = (SELECT crear_tabla_conceptos(codigo));
IF resultado != 0 THEN
RETURN resultado;
END IF;
resultado = (SELECT crear_tabla_relacion(codigo));
IF resultado != 0 THEN
RETURN resultado;
END IF;
resultado = (SELECT crear_tabla_mediciones(codigo));
IF resultado != 0 THEN
RETURN resultado;
END IF;
--si todo esta correcto:
tablaconceptos := codigo||'_Conceptos';
tablarelacion := codigo||'_Relacion';
--insertamos el nodo raiz
EXECUTE format ('INSERT INTO %I(codigo,resumen,naturaleza,fecha) VALUES(%s,%s,6,NOW())',tablaconceptos,quote_literal(codigo),quote_literal(resumen));
--insertamos la primera relacion
EXECUTE format ('INSERT INTO %I VALUES(0,NULL,%s,1,1,0)',tablarelacion,quote_literal(codigo));
return 0;
END;
$$;


ALTER FUNCTION public.crear_obra(codigo character varying, resumen character varying) OWNER TO postgres;

--
-- TOC entry 247 (class 1255 OID 26130)
-- Name: crear_tabla_conceptos(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.crear_tabla_conceptos(codigo character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
cadena text;
BEGIN
EXECUTE format ('CREATE TABLE IF NOT EXISTS %I OF concepto (PRIMARY KEY (codigo))',codigo||'_Conceptos');		
RETURN 0;
EXCEPTION 
    WHEN others THEN
        RAISE INFO 'Error Name:%',SQLERRM;
        RAISE INFO 'Error State:%', SQLSTATE;
        RETURN -1;
END;
$$;


ALTER FUNCTION public.crear_tabla_conceptos(codigo character varying) OWNER TO postgres;

--
-- TOC entry 255 (class 1255 OID 27302)
-- Name: crear_tabla_mediciones(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.crear_tabla_mediciones(codigo character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
tablamedicion character varying;
secuencia character varying;
BEGIN
tablamedicion := codigo||'_Mediciones';
secuencia := tablamedicion||'_id_seq';
EXECUTE format ('CREATE TABLE IF NOT EXISTS %I OF medicion (PRIMARY KEY (id))',tablamedicion);
EXECUTE FORMAT ('CREATE SEQUENCE %I',codigo||'_Mediciones_id_seq');
EXECUTE FORMAT ('ALTER TABLE %I ALTER COLUMN id SET NOT NULL, ALTER COLUMN id SET DEFAULT nextval (''%I''::regclass)',
tablamedicion, secuencia);
RETURN 0;
EXCEPTION 
    WHEN others THEN
        RAISE INFO 'Error Name:%',SQLERRM;
        RAISE INFO 'Error State:%', SQLSTATE;
        RETURN -3;
END;
$$;


ALTER FUNCTION public.crear_tabla_mediciones(codigo character varying) OWNER TO postgres;

--
-- TOC entry 254 (class 1255 OID 27293)
-- Name: crear_tabla_relacion(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.crear_tabla_relacion(codigo character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
tablarelacion character varying;
secuencia character varying;
BEGIN
tablarelacion := codigo||'_Relacion';
secuencia := tablarelacion||'_id_seq';
EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I OF relacion (PRIMARY KEY (id))',tablarelacion);
EXECUTE FORMAT ('CREATE SEQUENCE %I',codigo||'_Relacion_id_seq');
EXECUTE FORMAT ('ALTER TABLE %I ALTER COLUMN id SET NOT NULL, ALTER COLUMN id SET DEFAULT nextval (''%I''::regclass)',
tablarelacion, secuencia);
RETURN 0;
EXCEPTION 
    WHEN others THEN
        RAISE INFO 'Error Name:%',SQLERRM;
        RAISE INFO 'Error State:%', SQLSTATE;
        RETURN -2;
END;
$$;


ALTER FUNCTION public.crear_tabla_relacion(codigo character varying) OWNER TO postgres;

--
-- TOC entry 252 (class 1255 OID 26373)
-- Name: es_ancestro(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.es_ancestro(nombretabla character varying, codigopadre character varying, codigohijo character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
r character varying;
hayAncestro boolean;
str_null_case character varying;
tablarelacion character varying;
BEGIN
IF codigopadre IS NULL THEN
	str_null_case := ' IS NULL';
ELSE
	str_null_case := ' = '||quote_literal(codigopadre);
END IF;
hayAncestro = false;
tablarelacion := nombretabla||'_Relacion';
--primera comprobacion, que padre e hijo no sean el mismo codigo
IF codigopadre = codigohijo THEN
RETURN true;
END IF;
FOR r in EXECUTE FORMAT('SELECT codpadre FROM %I WHERE codhijo %s',tablarelacion,str_null_case)
LOOP
	RAISE NOTICE 'Estudio el par : %-%',r,codigohijo;
	IF r = codigohijo THEN
	RAISE NOTICE 'Existe la relacion : %-%',codigopadre,codigohijo;
	hayAncestro =  true;
	RAISE NOTICE 'El ancestro recente es: %',HayAncestro;
	RETURN hayAncestro;	
	ELSE
	hayAncestro =  es_ancestro(nombretabla, r, codigohijo);
	END IF;
END LOOP;
RAISE NOTICE 'El ancestro es: %',hayAncestro;
RETURN hayAncestro;
END;
$$;


ALTER FUNCTION public.es_ancestro(nombretabla character varying, codigopadre character varying, codigohijo character varying) OWNER TO postgres;

--
-- TOC entry 262 (class 1255 OID 30876)
-- Name: existe_codigo(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.existe_codigo(nombretabla character varying, codigo character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
tablaconceptos character varying;
existe boolean;
BEGIN
tablaconceptos = nombretabla || '_Conceptos';
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM %I WHERE codigo = %s )',
	tablaconceptos , quote_literal(codigo)) INTO existe;
RETURN existe;
END;
$$;


ALTER FUNCTION public.existe_codigo(nombretabla character varying, codigo character varying) OWNER TO postgres;

--
-- TOC entry 249 (class 1255 OID 26370)
-- Name: existe_hermano(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.existe_hermano(nombretabla character varying, codigopadre character varying, codigohijo character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
existe boolean;

BEGIN
EXECUTE FORMAT ('SELECT EXISTS(SELECT codhijo FROM %I WHERE codpadre = %s)', nombretabla||'_Relacion', codigopadre) INTO existe;
RETURN existe;
END;
$$;


ALTER FUNCTION public.existe_hermano(nombretabla character varying, codigopadre character varying, codigohijo character varying) OWNER TO postgres;

--
-- TOC entry 237 (class 1255 OID 29562)
-- Name: exportarbc3(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.exportarbc3(tabla character varying) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
C record;
D record;
M record;
tablaconceptos character varying;
tablarelacion character varying;
tablamedicion character varying;
haydescomposicion boolean;
haymedicion boolean;
salida text;
cadenamedicion text;
BEGIN
cadenamedicion = '';
tablaconceptos := tabla||'_Conceptos';
tablarelacion := tabla||'_Relacion';
tablamedicion := tabla||'_Mediciones';
--REGISTRO C	
FOR C IN EXECUTE FORMAT ('SELECT codigo, ud, resumen, preciomed, fecha, naturaleza,descripcion FROM %I',tablaconceptos)
	LOOP
	salida := concat (salida,'~C|');
	salida := concat(salida,poner_almohadilla(tabla, C.codigo));salida:=concat(salida,'|');
	salida := concat(salida,C.ud);salida:=concat(salida,'|');
	salida := concat(salida,C.resumen);salida:=concat(salida,'|');
	salida := concat(salida,C.preciomed);salida:=concat(salida,'|');
	salida := concat(salida,fecha_a_bc3(C.fecha));salida:=concat(salida,'|');
	salida := concat(salida,C.naturaleza);salida:=concat(salida,'|');
	salida := concat(salida,chr(10));
	--REGISTRO D
	haydescomposicion = hay_descomposicion(tabla,C.codigo);
	IF haydescomposicion IS TRUE THEN
	    salida := concat (salida,'~D|',poner_almohadilla(tabla, C.codigo),'|');
	END IF;
	FOR D IN EXECUTE FORMAT ('SELECT codhijo, canpres FROM %I WHERE codpadre = %s',tablarelacion, quote_literal(C.codigo))	    
	    LOOP		
		IF haydescomposicion IS TRUE THEN		    		    
		    salida := concat(salida, D.codhijo);salida:=concat(salida,chr(92),'1',chr(92),D.canpres,chr(92));		    
		END IF;
		--AQUI CONSTRUYO LA CADENA DE MEDICION EN CASO DE QUE HAYA
		haymedicion = hay_medicion(tabla,C.codigo,D.codhijo);		
		IF haymedicion IS TRUE THEN
		    cadenamedicion := concat (cadenamedicion,'~M|',poner_almohadilla(tabla, C.codigo),chr(92),D.codhijo,'||',D.canpres,'|');
		    FOR M IN EXECUTE FORMAT('SELECT tipo,comentario,ud,longitud,anchura,altura FROM %I WHERE codpadre = %s AND codhijo = %s',
		    tablamedicion, quote_literal(C.codigo), quote_literal(D.codhijo))
		        LOOP
		            cadenamedicion:=concat(cadenamedicion,M.tipo,'\',M.comentario,'\',M.ud,'\',M.longitud,'\',M.anchura,'\',M.altura,'\');
		        END LOOP;
		    cadenamedicion := concat (cadenamedicion,'|',chr(10));		    
		END IF;
		--FIN DE LA CONSTRUCCION DE LA CADENA DE MEDICION
	    END LOOP;
	IF haydescomposicion IS TRUE THEN
	    salida := concat(salida,'|',chr(10));
	END IF;
	--REGISTRO M	
	IF haymedicion IS TRUE THEN--SI HAY MEDICION AÑADO LA CADENA CREADA ANTERIORMENTE A LA CADENA PRINCIPAL Y LA PONGO A 0
	    salida := concat (salida,cadenamedicion);
	    cadenamedicion := '';	   
	END IF;
	END LOOP;
	--REGISTRO T
	IF (C.descripcion <> '') IS TRUE THEN
	    salida := concat(salida,'~T|',C.descripcion,'|',chr(10));
	END IF;
RAISE NOTICE 'salida %',salida;
RETURN salida;
END;
$$;


ALTER FUNCTION public.exportarbc3(tabla character varying) OWNER TO postgres;

--
-- TOC entry 260 (class 1255 OID 29561)
-- Name: fecha_a_bc3(date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.fecha_a_bc3(fecha date) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
fechabc3 character varying;
dia character varying;
mes character varying;
anno character varying;
BEGIN
fechabc3 := fecha::character varying;
dia := substring(fechabc3 from 9 for 2);
mes := substring(fechabc3 from 6 for 2);
anno := substring(fechabc3 from 1 for 4);
fechabc3 := concat(dia,mes,anno);
RETURN fechabc3;
END;
$$;


ALTER FUNCTION public.fecha_a_bc3(fecha date) OWNER TO postgres;

--
-- TOC entry 243 (class 1255 OID 24015)
-- Name: hay_descomposicion(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.hay_descomposicion(nombretabla character varying, codigo character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
tablarelacion character varying;
resultado boolean;
BEGIN
tablarelacion = nombretabla || '_Relacion';
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM %I WHERE codpadre = %s )',tablarelacion , quote_literal(codigo)) INTO resultado;
RETURN resultado;
END;
$$;


ALTER FUNCTION public.hay_descomposicion(nombretabla character varying, codigo character varying) OWNER TO postgres;

--
-- TOC entry 259 (class 1255 OID 29144)
-- Name: hay_medicion(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.hay_medicion(nombretabla character varying, codigopadre character varying, codigohijo character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
tablamedicion character varying;
resultado boolean;
BEGIN
tablamedicion = nombretabla || '_Mediciones';
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM %I WHERE codpadre = %s AND codhijo = %s)',
tablamedicion , 
quote_literal(codigopadre),
quote_literal(codigohijo))
 INTO resultado;
RETURN resultado;
END;
$$;


ALTER FUNCTION public.hay_medicion(nombretabla character varying, codigopadre character varying, codigohijo character varying) OWNER TO postgres;

--
-- TOC entry 235 (class 1255 OID 21364)
-- Name: insertar_concepto(character varying, character varying, character varying, character varying, numeric, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertar_concepto(nombretabla character varying, codigopadre character varying, u character varying DEFAULT ''::character varying, resumen character varying DEFAULT ''::character varying, precio numeric DEFAULT 0, nat integer DEFAULT 7, fec character varying DEFAULT ''::character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$

DECLARE
tablaconceptos character varying;
fecha date;
existe boolean;

BEGIN
tablaconceptos = nombretabla || '_Conceptos';
fecha = procesar_cadena_fecha(fec);
EXECUTE FORMAT ('SELECT NOT EXISTS (SELECT codigo FROM %I WHERE codigo = %s)', tablaconceptos, quote_literal(codigopadre)) INTO existe;
IF existe = TRUE THEN
EXECUTE FORMAT ('INSERT INTO %I (codigo,ud,resumen,preciomed,naturaleza,fecha) VALUES
		($1,$2,$3,$4,$5,$6)',tablaconceptos, tablaconceptos)
		USING		
		codigopadre,
		u,
		resumen,
		precio,
		nat,	
		fecha;
END IF;
END;
$_$;


ALTER FUNCTION public.insertar_concepto(nombretabla character varying, codigopadre character varying, u character varying, resumen character varying, precio numeric, nat integer, fec character varying) OWNER TO postgres;

--
-- TOC entry 258 (class 1255 OID 29208)
-- Name: insertar_medicion(character varying, character varying, character varying, smallint, integer, character varying, numeric, numeric, numeric, numeric, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertar_medicion(nombretabla character varying, codigopadre character varying, codigohijo character varying, posicion smallint DEFAULT (- (1)::smallint), tipo integer DEFAULT 0, comentario character varying DEFAULT NULL::character varying, ud numeric DEFAULT (0)::numeric, longitud numeric DEFAULT (0)::numeric, anchura numeric DEFAULT (0)::numeric, altura numeric DEFAULT (0)::numeric, formula character varying DEFAULT NULL::character varying, idfila integer DEFAULT NULL::integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
tablamediciones character varying;
tablaconceptos character varying;
nuevaid integer;
r record;
BEGIN
--obtenemos el nombre de la tabla
tablamediciones := nombretabla||'_Mediciones';
tablaconceptos := nombretabla||'_Conceptos';
--defino el tipo si hay formula
IF formula!= 'NULL' THEN TIPO = 3; END IF;
--tratamos el comentario
IF comentario = 'NULL' THEN comentario = ''; END IF;
--ahora ordenar las lineas
FOR r IN EXECUTE FORMAT ('SELECT * FROM ver_mediciones(%s,%s,%s)', 
			quote_literal(nombretabla),quote_literal(codigopadre),quote_literal(codigohijo))
		LOOP
			IF r.pos>=posicion THEN
				EXECUTE FORMAT ('UPDATE %I SET posicion = posicion+1 WHERE id = %s',
				tablamediciones,
				quote_literal(r.id));
			END IF;
		END LOOP;
RAISE NOTICE 'INSERTAR EN % LA UD: %, LA LANOGITUD %, LA ANCHURA % Y LA ALTURA %', tablamediciones, ud,longitud,anchura,altura;
EXECUTE FORMAT ('INSERT INTO %I (comentario,ud,longitud,anchura,altura,formula,tipo,codpadre,codhijo,posicion)
	VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10)',tablamediciones)
USING 
comentario,
ud,
longitud,
anchura,
altura,
formula,
tipo,
codigopadre,
codigohijo,
posicion
;
PERFORM modificar_cantidad(nombretabla,codigopadre,codigohijo);
--ahora hallo la id de la linea recien insertada
EXECUTE FORMAT ('SELECT MAX(id) FROM %I',tablamediciones) INTO nuevaid;
RETURN nuevaid;
END;
$_$;


ALTER FUNCTION public.insertar_medicion(nombretabla character varying, codigopadre character varying, codigohijo character varying, posicion smallint, tipo integer, comentario character varying, ud numeric, longitud numeric, anchura numeric, altura numeric, formula character varying, idfila integer) OWNER TO postgres;

--
-- TOC entry 244 (class 1255 OID 25944)
-- Name: insertar_partida(character varying, character varying, character varying, smallint, character varying, character varying, text, numeric, numeric, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertar_partida(nombretabla character varying, codigopadre character varying, codigohijo character varying, pos smallint DEFAULT (- (1)::smallint), u character varying DEFAULT ''::character varying, res character varying DEFAULT ''::character varying, texto text DEFAULT ''::text, precio numeric DEFAULT 0, cantidad numeric DEFAULT 1, nat integer DEFAULT 7, fec character varying DEFAULT ''::character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
fechapartida DATE;
eshermano boolean;
esancestro boolean;
existe boolean;
tablaconceptos character varying;
tablarelacion character varying;
BEGIN
tablaconceptos := nombretabla||'_Conceptos';
tablarelacion := nombretabla || '_Relacion';
eshermano := FALSE;
esancestro:= FALSE;
-- lo primero es ver si el hijo ya existe. Si no existe, annadimos el nuevo concepto y su relacion, sin hacer mas comprobaciones
EXECUTE FORMAT ('SELECT EXISTS (SELECT codigo FROM %I WHERE codigo = %s)',tablaconceptos,quote_literal(codigohijo)) INTO existe;
IF (existe is FALSE) THEN --si es NULL es que no existe
	RAISE NOTICE 'Creo e inserto nuevo nodo';
	--creo el nuevo concepto (nodo)
	--proceso la fecha
	fechapartida = procesar_cadena_fecha(fec);
	EXECUTE FORMAT('INSERT INTO %I (codigo,ud,resumen,descripcion,naturaleza,preciomed,fecha) 
	VALUES ($1, $2, $3, $4, $5, $6, $7)',
	tablaconceptos)
	USING codigohijo, u, res, texto, nat, precio, fechapartida;	
ELSE  --si ya existe hay que hacer comprobaciones de si es padre o referencia circular. Si ocurre alguna
	--de estas dos cosas salimos de la funcion con codigo de error
	--primera comprobacion. Que no exista ya esl codigo bajo ese padre, es decir, que no haya un hermano
	RAISE NOTICE 'LLEGO HASTA LO DE LOS HERMANOS';
	EXECUTE FORMAT ('SELECT existe_hermano($1,$2,$3)')
	USING
	nombretabla,
	quote_literal(codigopadre),
	quote_literal(codigohijo)
	INTO eshermano;	
	IF eshermano IS TRUE
		THEN RAISE NOTICE 'El codigo % ya tiene un codigo hijo = a %',codigopadre,codigohijo;
		RETURN 1;
	--segunda comprobacion, si no es hermano comprobamos que no haya un ancestro directo con el mcismo codigo
	ELSE
	    EXECUTE FORMAT ('SELECT es_ancestro($1,$2,$3)') 
	    USING
	    nombretabla,
	    quote_literal(codigopadre),
	    quote_literal(codigohijo)
	    INTO esancestro;
	    IF esancestro IS TRUE	    
		THEN RAISE NOTICE 'Hay referencia circular';
		RETURN 2;
	    END IF;
	END IF;
END IF;
--RAISE NOTICE 'HE LLEGADO HASTA AQUI y voy con la cantidad: %',cantidad;
PERFORM insertar_relacion(nombretabla, codigopadre, codigohijo, cantidad, pos);
PERFORM actualizar_desde_nodo(nombretabla,codigopadre);
RETURN 0;
END;
$_$;


ALTER FUNCTION public.insertar_partida(nombretabla character varying, codigopadre character varying, codigohijo character varying, pos smallint, u character varying, res character varying, texto text, precio numeric, cantidad numeric, nat integer, fec character varying) OWNER TO postgres;

--
-- TOC entry 242 (class 1255 OID 26466)
-- Name: insertar_relacion(character varying, character varying, character varying, numeric, smallint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertar_relacion(nombretabla character varying, codigopadre character varying, codigohijo character varying, cantidad numeric, pos smallint) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
  r record;
  tablarelacion character varying;
  
BEGIN
tablarelacion := nombretabla||'_Relacion';
RAISE NOTICE 'insertar_relacion con % - % en la posicion: % y cantidad: %',codigopadre,codigohijo,pos,cantidad;
EXECUTE FORMAT ('INSERT INTO %I (codpadre,codhijo,canpres,posicion) VALUES($1,$2,$3,$4)', tablarelacion)
USING 
codigopadre,
codigohijo,
cantidad,
pos;

--ahora ordeno los hijos
IF pos = -1 THEN	
	EXECUTE FORMAT ('UPDATE %I SET posicion = (SELECT MAX(posicion)+1 FROM %I WHERE codpadre = $1) WHERE codpadre = $2 AND codhijo = $3',
	tablarelacion,tablarelacion)
	USING
	codigopadre,
	codigopadre,
	codigohijo;		 
ELSE 
	FOR r IN EXECUTE FORMAT ('SELECT * FROM %I WHERE codpadre = %s', tablarelacion, quote_literal(codigopadre))
		LOOP
			RAISE NOTICE 'Listado: %- %- %- % - %', r.id, r.codpadre, r.codhijo, r.canpres, r.posicion;
			IF(r.posicion>=pos AND r.codhijo!=codigohijo) THEN
				EXECUTE FORMAT ('UPDATE %I SET posicion = %I.posicion+1 WHERE codhijo = %s',
				tablarelacion, tablarelacion,
				quote_literal(r.codhijo));
				RAISE NOTICE 'Ordenar los hijos % que esten despues de la posicion %',r.codhijo,pos;
			END IF;
		END LOOP;
END IF;
END;
$_$;


ALTER FUNCTION public.insertar_relacion(nombretabla character varying, codigopadre character varying, codigohijo character varying, cantidad numeric, pos smallint) OWNER TO postgres;

--
-- TOC entry 238 (class 1255 OID 22230)
-- Name: insertar_texto(character varying, character varying, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertar_texto(tabla character varying, cod character varying, texto text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
codigo character varying;
tablaconceptos character varying;
descripcion character varying; 
BEGIN
--definimos tabla_conceptos y la cadena str_null_case
tablaconceptos := tabla||'_Conceptos';
codigo := quote_literal(cod);
descripcion := quote_literal(texto);
--insertamos el texto
EXECUTE FORMAT ('UPDATE %I SET descripcion = %s WHERE codigo = %s',tablaconceptos,descripcion,codigo);
END;
$$;


ALTER FUNCTION public.insertar_texto(tabla character varying, cod character varying, texto text) OWNER TO postgres;

--
-- TOC entry 257 (class 1255 OID 27226)
-- Name: modificar_campo_medicion(character varying, character varying, character varying, character varying, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.modificar_campo_medicion(nombretabla character varying, codigopadre character varying, codigohijo character varying, valor character varying, idfila integer, columna integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
tablamediciones character varying;
texto text;
BEGIN
tablamediciones := nombretabla||'_Mediciones';
IF (columna!=1 AND valor = '') THEN valor =0;END IF;
CASE columna
WHEN 1 THEN texto := ' comentario = '||quote_literal(valor);
WHEN 2 THEN texto := ' ud = '||quote_literal(valor);
WHEN 3 THEN texto := ' longitud = '||quote_literal(valor);
WHEN 4 THEN texto := ' anchura = '||quote_literal(valor);
WHEN 5 THEN texto := ' altura = '||quote_literal(valor);
END CASE;
EXECUTE FORMAT ('UPDATE %I SET %s WHERE id = %s',tablamediciones, texto, idfila);
PERFORM modificar_cantidad(nombretabla,codigopadre,codigohijo);
END;
$$;


ALTER FUNCTION public.modificar_campo_medicion(nombretabla character varying, codigopadre character varying, codigohijo character varying, valor character varying, idfila integer, columna integer) OWNER TO postgres;

--
-- TOC entry 263 (class 1255 OID 29146)
-- Name: modificar_cantidad(character varying, character varying, character varying, numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.modificar_cantidad(nombretabla character varying, codigopadre character varying, codigohijo character varying, cantidad numeric DEFAULT NULL::numeric) RETURNS void
    LANGUAGE plpgsql
    AS $_$
DECLARE
tablarelacion character varying;
tablamediciones character varying;
nuevacantidad numeric;
indices int[];
BEGIN
tablarelacion := nombretabla||'_Relacion';
tablamediciones:= nombretabla||'_Mediciones';
--si la cantidad no es nula tengo que borrar todas las lineas de medicion y sustituir la cantidad por la cantidad dada
IF cantidad IS NOT NULL THEN
	raise notice 'entro en la funcion con una cantidad dada: %',cantidad;
    --guardo los indices de las lineas de medicion de esa partida (si los hubiera)
    EXECUTE FORMAT ('SELECT array_agg(id) FROM %I WHERE codpadre = %s AND codhijo = %s',
    tablamediciones, 
    quote_literal(codigopadre),
    quote_literal(codigohijo))
    INTO indices;
    --borro las posibles lineas de medicion
    PERFORM borrar_lineas_medicion(nombretabla, indices);
    --sustituyo la cantidad. 
    nuevacantidad = cantidad;
--si el argumento de cantidad es nulo, la calculo a partir de sus mediciones
ELSE
    EXECUTE FORMAT('SELECT SUM(parcial) FROM ver_mediciones($1,$2,$3)') INTO nuevacantidad
    USING nombretabla, codigopadre, codigohijo;
    IF nuevacantidad IS NULL THEN nuevacantidad =0; END IF;
END IF;
--por ultimo cambio la cantidad y recalculo el total
EXECUTE FORMAT ('UPDATE %I SET canpres = %s WHERE codpadre=%s AND codhijo=%s',nombretabla||'_Relacion',
quote_literal(nuevacantidad),quote_literal(codigopadre),quote_literal(codigohijo));
IF existe_codigo(nombretabla,codigohijo) THEN
    PERFORM actualizar_desde_nodo(nombretabla,codigohijo);
END IF;
END;
$_$;


ALTER FUNCTION public.modificar_cantidad(nombretabla character varying, codigopadre character varying, codigohijo character varying, cantidad numeric) OWNER TO postgres;

--
-- TOC entry 245 (class 1255 OID 25236)
-- Name: modificar_codigo(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.modificar_codigo(nombretabla character varying, codigoantiguo character varying, codigonuevo character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
tablaconceptos character varying;
tablarelacion character varying;
existe boolean;
BEGIN
tablaconceptos := nombretabla||'_Conceptos';
tablarelacion := nombretabla||'_Relacion';
EXECUTE FORMAT ('SELECT EXISTS(SELECT codigo FROM %I WHERE codigo = %s)',tablaconceptos, quote_literal(codigonuevo)) INTO existe;
IF existe IS FALSE THEN
    EXECUTE FORMAT ('UPDATE %I SET codigo = %s WHERE codigo = %s',tablaconceptos,quote_literal(codigonuevo), quote_literal(codigoantiguo));
    EXECUTE FORMAT ('UPDATE %I SET codpadre = %s WHERE codpadre = %s',tablarelacion,quote_literal(codigonuevo), quote_literal(codigoantiguo));
    EXECUTE FORMAT ('UPDATE %I SET codhijo = %s WHERE codhijo = %s',tablarelacion,quote_literal(codigonuevo), quote_literal(codigoantiguo));
END IF;
RETURN existe;
END;
$$;


ALTER FUNCTION public.modificar_codigo(nombretabla character varying, codigoantiguo character varying, codigonuevo character varying) OWNER TO postgres;

--
-- TOC entry 239 (class 1255 OID 23081)
-- Name: modificar_naturaleza(character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.modificar_naturaleza(nombretabla character varying, cod character varying, nat integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN

EXECUTE FORMAT ('UPDATE %I SET naturaleza = %s WHERE codigo = %s',nombretabla||'_Conceptos' ,nat , quote_literal(cod));
END;
$$;


ALTER FUNCTION public.modificar_naturaleza(nombretabla character varying, cod character varying, nat integer) OWNER TO postgres;

--
-- TOC entry 264 (class 1255 OID 42060)
-- Name: modificar_precio(character varying, character varying, character varying, numeric, integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.modificar_precio(nombretabla character varying, codpadre character varying, codhijo character varying, precio numeric, opcion integer, restaurar boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
tablaborrarconceptos character varying;
tablaborrarrelacion character varying;
BEGIN
tablaborrarconceptos = nombretabla || '_BorrarConceptos';
tablaborrarrelacion = nombretabla || '_BorrarRelacion';
IF opcion = 2 THEN--bloquear el precio
	PERFORM bloquear_precio(nombretabla,codhijo,precio,restaurar);
ELSE
	IF restaurar IS TRUE THEN
		PERFORM borrar_hijos(nombretabla,codhijo);
	ELSE
		PERFORM restaurar_lineas_principal(nombretabla);
	END IF;	
	--por ultimo actualizo el campo precio	
	EXECUTE FORMAT ('UPDATE %I SET preciomed = %s WHERE codigo=%s',nombretabla||'_Conceptos',quote_literal(precio),quote_literal(codhijo));	
END IF;
PERFORM actualizar_desde_nodo(nombretabla,codhijo);
END;
$$;


ALTER FUNCTION public.modificar_precio(nombretabla character varying, codpadre character varying, codhijo character varying, precio numeric, opcion integer, restaurar boolean) OWNER TO postgres;

--
-- TOC entry 233 (class 1255 OID 21028)
-- Name: modificar_resumen(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.modificar_resumen(nombretabla character varying, cod character varying, res character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN

EXECUTE FORMAT ('UPDATE %I SET resumen = %s WHERE codigo = %s',nombretabla||'_Conceptos' ,quote_literal(res),quote_literal(cod));
END;
$$;


ALTER FUNCTION public.modificar_resumen(nombretabla character varying, cod character varying, res character varying) OWNER TO postgres;

--
-- TOC entry 240 (class 1255 OID 23517)
-- Name: modificar_unidad(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.modificar_unidad(nombretabla character varying, cod character varying, ud character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN
EXECUTE FORMAT ('UPDATE %I SET ud = %s WHERE codigo = %s',nombretabla||'_Conceptos' ,quote_literal(ud),quote_literal(cod));
END;
$$;


ALTER FUNCTION public.modificar_unidad(nombretabla character varying, cod character varying, ud character varying) OWNER TO postgres;

--
-- TOC entry 261 (class 1255 OID 29560)
-- Name: poner_almohadilla(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.poner_almohadilla(tabla character varying, codigo character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
tablarelacion character varying;
r record;
padre character varying;
abuelo character varying;
nuevocodigo character varying;
BEGIN
nuevocodigo = codigo;
tablarelacion := tabla||'_Relacion';
EXECUTE FORMAT ('SELECT codpadre FROM %I WHERE codhijo = %s',tablarelacion, quote_literal(codigo)) INTO padre;
IF padre IS NULL THEN
    nuevocodigo := concat(codigo,'##');
ELSE
    EXECUTE FORMAT ('SELECT codpadre FROM %I WHERE codhijo = %s',tablarelacion, quote_literal(padre)) INTO abuelo;
    IF abuelo IS NULL THEN
        nuevocodigo := concat(codigo,'#');
    END IF;
END IF;
RETURN nuevocodigo;
END;
$$;


ALTER FUNCTION public.poner_almohadilla(tabla character varying, codigo character varying) OWNER TO postgres;

--
-- TOC entry 231 (class 1255 OID 21024)
-- Name: procesar_cadena_fecha(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.procesar_cadena_fecha(cadenafecha character varying DEFAULT ''::character varying) RETURNS date
    LANGUAGE plpgsql
    AS $_$
DECLARE
fecha DATE;

BEGIN
--comprobacion de si hay digitos. Si no son todos digitos se retorna fecha actual
IF cadenafecha ~ '^(-)?[0-9]+$' IS NOT TRUE THEN
   fecha = NOW();
--empezamos definiendo la fecha
ELSIF char_length(cadenafecha) = 6 THEN 
   fecha = to_date(cadenafecha,'DDMMYY');
ELSIF char_length(cadenafecha) = 8 THEN 
   fecha = to_date(cadenafecha,'DDMMYYYY');
ELSE
   fecha = NOW();
END IF;
RETURN fecha;
END;
$_$;


ALTER FUNCTION public.procesar_cadena_fecha(cadenafecha character varying) OWNER TO postgres;

--
-- TOC entry 234 (class 1255 OID 22185)
-- Name: procesar_linea_medicion(numeric, numeric, numeric, numeric, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.procesar_linea_medicion(unidad numeric, longitud numeric, anchura numeric, altura numeric, formula character varying) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
IF unidad IS NULL THEN unidad = 0; END IF;
IF longitud IS NULL OR longitud = 0 THEN longitud =1; END IF;
IF anchura IS NULL OR anchura = 0 THEN anchura =1; END IF;
IF altura IS NULL OR altura = 0 THEN altura =1; END IF;
RETURN unidad*longitud*anchura*altura;
END;
$$;


ALTER FUNCTION public.procesar_linea_medicion(unidad numeric, longitud numeric, anchura numeric, altura numeric, formula character varying) OWNER TO postgres;

--
-- TOC entry 272 (class 1255 OID 43438)
-- Name: restaurar_lineas_borradas(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.restaurar_lineas_borradas(nombretabla character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$ 
DECLARE
num_paso integer;
tablaconceptos character varying := nombretabla || '_Conceptos';
tablaborrarconceptos character varying := nombretabla || '_BorrarConceptos';
tablarelacion character varying := nombretabla || '_Relacion';
tablaborrarrelacion character varying := nombretabla || '_BorrarRelacion';
tablamedicion character varying := nombretabla || '_Mediciones';
tablaborrarmedicion character varying := nombretabla || '_BorrarMediciones';
c concepto%ROWTYPE;
cb borrarconcepto%ROWTYPE;
r relacion%ROWTYPE;
rb borrarrelacion%ROWTYPE;
m medicion%ROWTYPE;
mb borrarmedicion%ROWTYPE;
BEGIN
--PRIMER PASO, HALLAR EL PASO MAS ALTO DE LAS TRES TABLAS
EXECUTE FORMAT('SELECT ultimo_paso(%s)',quote_literal(nombretabla)) INTO num_paso;
RAISE NOTICE 'ULTIMO PASO: %',num_paso;
--EXECUTE FORMAT ('SELECT MAX(paso) FROM %I',tablaborrarrelacion) INTO num_paso;
--TABLA RELACION
FOR rb IN EXECUTE FORMAT ('SELECT * FROM %I WHERE paso = $1',tablaborrarrelacion) USING num_paso
LOOP
	r=rb.r;
	EXECUTE FORMAT ('INSERT INTO %I VALUES(%s,%s,%s,%s,%s,%s)',tablarelacion,
	r.id, quote_literal(r.codpadre), quote_literal(r.codhijo), r.canpres,r.cancert,r.posicion);
END LOOP;
EXECUTE FORMAT ('DELETE FROM %I WHERE paso = %s',tablaborrarrelacion,num_paso);
--TABLA CONCEPTOS
FOR cb IN EXECUTE FORMAT ('SELECT * FROM %I WHERE paso = $1',tablaborrarconceptos) USING num_paso
LOOP
	c=cb.c;
	EXECUTE FORMAT ('INSERT INTO %I VALUES(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)',tablaconceptos,
	quote_literal(c.codigo),
	quote_literal(c.resumen),
	quote_literal(COALESCE(c.descripcion,'')),
	quote_literal(COALESCE(c.descripcionhtml,'')),
	quote_literal(c.preciomed),
	COALESCE(c.preciobloq::varchar,'NULL'),
	quote_literal(c.naturaleza),
	quote_literal(c.fecha),
	quote_literal(COALESCE(c.ud,'')),
	COALESCE(c.preciocert::varchar,'NULL'));
END LOOP;
EXECUTE FORMAT ('DELETE FROM %I WHERE paso = %s',tablaborrarconceptos,num_paso);
--TABLA MEDICIONES
FOR mb IN EXECUTE FORMAT ('SELECT * FROM %I WHERE paso = $1',tablaborrarmedicion) USING num_paso
LOOP
	m=mb.m;
	EXECUTE FORMAT ('INSERT INTO %I VALUES(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)',tablamedicion,
	quote_literal(m.id),
	COALESCE(m.fase::varchar,'NULL'),
	COALESCE(m.tipo::varchar,'NULL'),
	quote_literal(COALESCE(m.comentario,'')),
	COALESCE(m.ud::varchar,'NULL'),
	COALESCE(m.longitud::varchar,'NULL'),
	COALESCE(m.anchura::varchar,'NULL'),
	COALESCE(m.altura::varchar,'NULL'),
	quote_literal(COALESCE(m.formula,'')),
	quote_literal(m.codpadre),
	quote_literal(m.codhijo),				
	COALESCE(m.posicion::varchar,'NULL')
	);
END LOOP;
EXECUTE FORMAT ('DELETE FROM %I WHERE paso = %s',tablaborrarmedicion,num_paso);
END;
$_$;


ALTER FUNCTION public.restaurar_lineas_borradas(nombretabla character varying) OWNER TO postgres;

--
-- TOC entry 271 (class 1255 OID 43320)
-- Name: ultimo_paso(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ultimo_paso(nombretabla character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
tablaborrarconceptos character varying := nombretabla || '_BorrarConceptos';
tablaborrarrelacion character varying := nombretabla || '_BorrarRelacion';
tablaborrarmedicion character varying := nombretabla || '_BorrarMediciones';
ultimo_paso_conceptos integer :=0;
ultimo_paso_relacion integer :=0;
ultimo_paso_mediciones integer :=0;
ultimo_paso integer;
existe boolean;
BEGIN
--maximo paso tabla conceptos
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = %s)', quote_literal(tablaborrarconceptos)) INTO existe;
IF existe IS TRUE THEN
	EXECUTE FORMAT ('SELECT MAX(paso) FROM %I',tablaborrarconceptos) INTO ultimo_paso_conceptos;	
END IF;
--maximo paso tabla relacion
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = %s)', quote_literal(tablaborrarrelacion)) INTO existe;
IF existe IS TRUE THEN
	EXECUTE FORMAT ('SELECT MAX(paso) FROM %I',tablaborrarrelacion) INTO ultimo_paso_relacion;	
END IF;
--maximo paso tabla medicion
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = %s)', quote_literal(tablaborrarmedicion)) INTO existe;
IF existe IS TRUE THEN
	EXECUTE FORMAT ('SELECT MAX(paso) FROM %I',tablaborrarmedicion) INTO ultimo_paso_mediciones;	
END IF;
CREATE TEMP TABLE IF NOT EXISTS temp_maximos (paso integer);
INSERT INTO temp_maximos VALUES(ultimo_paso_conceptos);   
INSERT INTO temp_maximos VALUES(ultimo_paso_relacion);
INSERT INTO temp_maximos VALUES(ultimo_paso_mediciones);
ultimo_paso = (SELECT MAX(paso) FROM temp_maximos) AS algo;
DROP TABLE temp_maximos;
RETURN ultimo_paso;
END;
$$;


ALTER FUNCTION public.ultimo_paso(nombretabla character varying) OWNER TO postgres;

--
-- TOC entry 268 (class 1255 OID 43319)
-- Name: ultimo_paso(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ultimo_paso(tablaconceptos character varying, tablarelacion character varying, tablamediciones character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE   
paso integer;
BEGIN
EXECUTE FORMAT('
SELECT MAX(num_paso) as paso
FROM
(
    SELECT num_paso FROM %I
    UNION ALL
    SELECT num_paso FROM %I
    UNION ALL
    SELECT num_paso FROM %I
) as subQuery',tablaconceptos, tablarelacion, tablamediciones) INTO paso;
RETURN paso;
END;
$$;


ALTER FUNCTION public.ultimo_paso(tablaconceptos character varying, tablarelacion character varying, tablamediciones character varying) OWNER TO postgres;

--
-- TOC entry 248 (class 1255 OID 43474)
-- Name: ver_color_hijos(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ver_color_hijos(nombretabla character varying, codigopadre character varying, codigohijo character varying) RETURNS TABLE(codigo integer, naturaleza integer, ud integer, resumen integer, canpres integer, cancert integer, portcertpres integer, preciomed integer, preciocert integer, imppres integer, impcert integer)
    LANGUAGE plpgsql
    AS $$
DECLARE 
    var_r record;
    tabla_conceptos character varying;
    tabla_relacion character varying;
    str_null_case character varying;
BEGIN
tabla_conceptos := quote_ident(CONCAT(nombretabla,'_Conceptos'));
tabla_relacion := quote_ident(CONCAT(nombretabla,'_Relacion'));
IF (codigopadre = '') IS NOT FALSE THEN
	str_null_case := 'R.codpadre IS NULL';
ELSE
	str_null_case := 'R.codpadre = '||quote_literal(codigopadre);
END IF;
--nodo padre	
 FOR var_r IN EXECUTE 'SELECT ' || 
        'C.codigo,'||
	'C.naturaleza,'||
	'C.ud,'||
	'C.resumen,'||
	'R.canpres,'|| 
	'R.cancert,'||
	'R.cancert / NULLIF(R.canpres,0) AS portcertpres,'||
	'C.preciomed,'||
	'C.preciocert,'||
	'R.canpres * C.preciomed as imppres,'||
	'R.cancert * C.preciocert as impcert
 FROM '||tabla_conceptos||'AS C,'||tabla_relacion||
 ' AS R WHERE C.codigo = '|| quote_literal(codigohijo) ||
 ' AND '||str_null_case||
 ' AND R.codhijo = C.codigo'
 LOOP
        codigo := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        naturaleza := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        ud := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        resumen := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        canpres := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        cancert := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        portcertpres := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        preciomed := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        preciocert := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        imppres := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        impcert := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        RETURN NEXT;
 END LOOP;
 --nodos hijos
 FOR var_r IN EXECUTE 'SELECT '||
	'C.codigo,'||
	'C.naturaleza,'||
	'C.ud,'||
	'C.resumen,'||
	'R.canpres,'||
	'R.cancert,'||
	'R.cancert/NULLIF(R.canpres,0) AS portcertpres,'||
	'C.preciomed,'||
	'C.preciocert,'||
	'R.canpres * C.preciomed as imppres,'||
	'R.cancert * C.preciocert as impcert
 FROM '||tabla_conceptos||'AS C,'||tabla_relacion ||
 ' AS R WHERE R.codpadre = '||quote_literal(codigohijo)||
 ' AND C.codigo = R.codhijo ORDER BY R.posicion'
 LOOP        
        codigo := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        naturaleza := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        ud := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        resumen := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        canpres := CASE WHEN (hay_medicion(nombretabla, codigopadre, codigohijo)) IS TRUE THEN
			array_length(enum_range(NULL, 'DESCOMPUESTO'::color), 1)
		ELSE 
			array_length(enum_range(NULL, 'NORMAL'::color), 1)
		END;
        cancert := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        portcertpres := array_length(enum_range(NULL, 'DESCOMPUESTO'::color), 1);
        preciomed := CASE WHEN (hay_descomposicion(nombretabla, codigohijo)) IS TRUE THEN 
			array_length(enum_range(NULL, 'DESCOMPUESTO'::color), 1)
		ELSE 
			array_length(enum_range(NULL, 'NORMAL'::color), 1)
		END;
        preciocert := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        imppres := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        impcert := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        RETURN NEXT;
 END LOOP;
 END; $$;


ALTER FUNCTION public.ver_color_hijos(nombretabla character varying, codigopadre character varying, codigohijo character varying) OWNER TO postgres;

--
-- TOC entry 265 (class 1255 OID 43467)
-- Name: ver_hijos(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ver_hijos(nombretabla character varying, codigopadre character varying, codigohijo character varying) RETURNS TABLE(codigo character varying, naturaleza integer, ud character varying, resumen character varying, canpres numeric, cancert numeric, portcertpres numeric, preciomed numeric, preciocert numeric, imppres numeric, impcert numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE 
    var_r record;
    tabla_conceptos character varying;
    tabla_relacion character varying;
    str_null_case character varying;
BEGIN
tabla_conceptos := quote_ident(CONCAT(nombretabla,'_Conceptos'));
tabla_relacion := quote_ident(CONCAT(nombretabla,'_Relacion'));
IF (codigopadre = '') IS NOT FALSE THEN
	str_null_case := 'R.codpadre IS NULL';
ELSE
	str_null_case := 'R.codpadre = '||quote_literal(codigopadre);
END IF;
--nodo padre	
 FOR var_r IN EXECUTE 'SELECT ' || 
        'C.codigo,'||
	'C.naturaleza,'||
	'C.ud,'||
	'C.resumen,'||
	'R.canpres,'|| 
	'R.cancert,'||
	'R.cancert / NULLIF(R.canpres,0) AS portcertpres,'||
	'C.preciomed,'||
	'C.preciocert,'||
	'R.canpres * C.preciomed as imppres,'||
	'R.cancert * C.preciocert as impcert
 FROM '||tabla_conceptos||'AS C,'||tabla_relacion||
 ' AS R WHERE C.codigo = '|| quote_literal(codigohijo) ||
 ' AND '||str_null_case||
 ' AND R.codhijo = C.codigo'
 LOOP
        codigo := var_r.codigo;
        naturaleza := var_r.naturaleza;
        ud := var_r.ud;
        resumen := var_r.resumen;
        canpres := var_r.canpres;
        cancert := var_r.cancert;
        portcertpres := var_r.portcertpres;
        preciomed := var_r.preciomed;
        preciocert := var_r.preciocert;
        imppres := var_r.imppres;
        impcert := var_r.impcert;
        RETURN NEXT;
 END LOOP;
 --nodos hijos
 FOR var_r IN EXECUTE 'SELECT '||
	'C.codigo,'||
	'C.naturaleza,'||
	'C.ud,'||
	'C.resumen,'||
	'R.canpres,'||
	'R.cancert,'||
	'R.cancert/NULLIF(R.canpres,0) AS portcertpres,'||
	'C.preciomed,'||
	'C.preciocert,'||
	'R.canpres * C.preciomed as imppres,'||
	'R.cancert * C.preciocert as impcert
 FROM '||tabla_conceptos||'AS C,'||tabla_relacion ||
 ' AS R WHERE R.codpadre = '||quote_literal(codigohijo)||
 ' AND C.codigo = R.codhijo ORDER BY R.posicion'
 LOOP
        codigo := var_r.codigo;
        naturaleza := var_r.naturaleza;
        ud := var_r.ud;
        resumen := var_r.resumen;
        canpres := var_r.canpres;
        cancert := var_r.cancert;
        portcertpres := var_r.portcertpres;
        preciomed := var_r.preciomed;
        preciocert := var_r.preciocert;
        imppres := var_r.imppres;
        impcert := var_r.impcert;
        RETURN NEXT;
 END LOOP;
 END; $$;


ALTER FUNCTION public.ver_hijos(nombretabla character varying, codigopadre character varying, codigohijo character varying) OWNER TO postgres;

--
-- TOC entry 251 (class 1255 OID 26841)
-- Name: ver_lineas_medicion(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ver_lineas_medicion(nombretabla character varying, codigopadre character varying, codigohijo character varying) RETURNS TABLE(tipo integer, comentario character varying, ud numeric, longitud numeric, anchura numeric, altura numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
idpadre integer;
idhijo integer;
var_r record;
tablamediciones character varying;
tablaconceptos character varying;
str_null_case character varying;
BEGIN
--obtenemos el nombre de la tabla
tablamediciones :=  quote_ident(CONCAT(nombretabla,'_Mediciones'));
tablaconceptos := CONCAT(nombretabla,'_Conceptos');
--construimos la cadena del padre
IF (codigopadre = '') IS NOT FALSE THEN
	str_null_case := tablamediciones||'.codpadre IS NULL';
ELSE
	str_null_case := tablamediciones||'.codpadre = '||quote_literal(codigopadre);
END IF;
--RAISE NOTICE 'lOS DATOS SON: %, %',idpadre,idhijo;

FOR var_r IN EXECUTE 'SELECT ' || 
        tablamediciones ||'.tipo,'||
	tablamediciones ||'.comentario,'||
	tablamediciones ||'.ud,'||
	tablamediciones ||'.longitud,'||
	tablamediciones ||'.anchura,'|| 
	tablamediciones ||'.altura
  FROM '||tablamediciones||
 ' WHERE '||tablamediciones||'.codhijo ='||idhijo||
 ' AND '||str_null_case||
 ' ORDER BY '||tablamediciones||'.id'
 LOOP
        tipo := var_r.tipo;
        comentario := var_r.comentario;
        ud := var_r.ud;
        longitud := var_r.longitud;
        anchura := var_r.anchura;
        altura := var_r.altura;         
        RETURN NEXT;
END LOOP;
END;
$$;


ALTER FUNCTION public.ver_lineas_medicion(nombretabla character varying, codigopadre character varying, codigohijo character varying) OWNER TO postgres;

--
-- TOC entry 256 (class 1255 OID 28187)
-- Name: ver_mediciones(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ver_mediciones(nombretabla character varying, codigopadre character varying, codigohijo character varying) RETURNS TABLE(fase integer, comentario character varying, ud numeric, longitud numeric, anchura numeric, altura numeric, formula character varying, parcial numeric, subtotal numeric, id integer, pos integer)
    LANGUAGE plpgsql
    AS $$
DECLARE 
    var_r record;
    tabla_medicion character varying;
    str_null_case character varying;
    acum numeric(7,3);
    texto text;
BEGIN
tabla_medicion := nombretabla||'_Mediciones';
acum = 0;
IF (codigopadre = '') IS NOT FALSE THEN
	str_null_case := 'codpadre IS NULL';
ELSE
	str_null_case := 'codpadre = '||quote_literal(codigopadre);
END IF;
texto = FORMAT('SELECT * FROM %I WHERE codhijo = %s AND %s ORDER BY id',tabla_medicion,quote_literal(codigohijo),str_null_case);
RAISE NOTICE '%',texto;
FOR var_r IN EXECUTE FORMAT('SELECT * FROM %I WHERE codhijo = %s AND %s ORDER BY posicion',tabla_medicion,quote_literal(codigohijo),str_null_case)
 LOOP
        fase := var_r.fase;
        comentario := var_r.comentario;
        ud := var_r.ud;
        longitud := var_r.longitud;
        anchura := var_r.anchura;
        altura := var_r.altura;
        formula := var_r.formula;        
        parcial := procesar_linea_medicion(var_r.ud, var_r.longitud, var_r.anchura, var_r.altura, var_r.formula);
        RAISE NOTICE 'El parcial es: %',parcial;
        acum = acum+parcial;
        IF var_r.tipo =1 or var_r.tipo =2 THEN subtotal = acum; ELSE subtotal = NULL; END IF;
        id :=var_r.id;
        pos := var_r.posicion;
        RETURN NEXT;
 END LOOP;
 END; $$;


ALTER FUNCTION public.ver_mediciones(nombretabla character varying, codigopadre character varying, codigohijo character varying) OWNER TO postgres;

--
-- TOC entry 253 (class 1255 OID 27225)
-- Name: ver_texto(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ver_texto(nombretabla character varying, cod character varying) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
tablaconceptos character varying;
str_null_case character varying;
texto_partida text;
BEGIN
tablaconceptos := nombretabla||'_Conceptos';
IF (cod = '') IS NOT FALSE THEN
	str_null_case := 'codigo IS NULL';
ELSE
	str_null_case := 'codigo = '||quote_literal(cod);
END IF;
EXECUTE FORMAT ('SELECT descripcion FROM %I WHERE %s',tablaconceptos,str_null_case) INTO texto_partida;
return texto_partida;
END;
$$;


ALTER FUNCTION public.ver_texto(nombretabla character varying, cod character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 214 (class 1259 OID 43398)
-- Name: PRUEBASCOMP_BorrarConceptos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PRUEBASCOMP_BorrarConceptos" OF public.borrarconcepto (
    idborrar WITH OPTIONS NOT NULL
);


ALTER TABLE public."PRUEBASCOMP_BorrarConceptos" OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 43406)
-- Name: PRUEBASCOMP_BorrarMediciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PRUEBASCOMP_BorrarMediciones" OF public.borrarmedicion (
    idborrar WITH OPTIONS NOT NULL
);


ALTER TABLE public."PRUEBASCOMP_BorrarMediciones" OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 43390)
-- Name: PRUEBASCOMP_BorrarRelacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PRUEBASCOMP_BorrarRelacion" OF public.borrarrelacion (
    idborrar WITH OPTIONS NOT NULL
);


ALTER TABLE public."PRUEBASCOMP_BorrarRelacion" OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 43360)
-- Name: PRUEBASCOMP_Conceptos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PRUEBASCOMP_Conceptos" OF public.concepto (
    codigo WITH OPTIONS NOT NULL
);


ALTER TABLE public."PRUEBASCOMP_Conceptos" OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 43387)
-- Name: PRUEBASCOMP_Mediciones_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."PRUEBASCOMP_Mediciones_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."PRUEBASCOMP_Mediciones_id_seq" OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 43379)
-- Name: PRUEBASCOMP_Mediciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PRUEBASCOMP_Mediciones" OF public.medicion (
    id WITH OPTIONS DEFAULT nextval('public."PRUEBASCOMP_Mediciones_id_seq"'::regclass) NOT NULL
);


ALTER TABLE public."PRUEBASCOMP_Mediciones" OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 43376)
-- Name: PRUEBASCOMP_Relacion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."PRUEBASCOMP_Relacion_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."PRUEBASCOMP_Relacion_id_seq" OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 43368)
-- Name: PRUEBASCOMP_Relacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PRUEBASCOMP_Relacion" OF public.relacion (
    id WITH OPTIONS DEFAULT nextval('public."PRUEBASCOMP_Relacion_id_seq"'::regclass) NOT NULL
);


ALTER TABLE public."PRUEBASCOMP_Relacion" OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 41601)
-- Name: kaka_BorrarConceptos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."kaka_BorrarConceptos" OF public.borrarconcepto (
    idborrar WITH OPTIONS NOT NULL
);


ALTER TABLE public."kaka_BorrarConceptos" OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 41593)
-- Name: kaka_BorrarRelacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."kaka_BorrarRelacion" OF public.borrarrelacion (
    idborrar WITH OPTIONS NOT NULL
);


ALTER TABLE public."kaka_BorrarRelacion" OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 41435)
-- Name: kaka_Conceptos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."kaka_Conceptos" OF public.concepto (
    codigo WITH OPTIONS NOT NULL
);


ALTER TABLE public."kaka_Conceptos" OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 41462)
-- Name: kaka_Mediciones_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."kaka_Mediciones_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."kaka_Mediciones_id_seq" OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 41454)
-- Name: kaka_Mediciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."kaka_Mediciones" OF public.medicion (
    id WITH OPTIONS DEFAULT nextval('public."kaka_Mediciones_id_seq"'::regclass) NOT NULL
);


ALTER TABLE public."kaka_Mediciones" OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 41451)
-- Name: kaka_Relacion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."kaka_Relacion_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."kaka_Relacion_id_seq" OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 41443)
-- Name: kaka_Relacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."kaka_Relacion" OF public.relacion (
    id WITH OPTIONS DEFAULT nextval('public."kaka_Relacion_id_seq"'::regclass) NOT NULL
);


ALTER TABLE public."kaka_Relacion" OWNER TO postgres;

--
-- TOC entry 2231 (class 2606 OID 43405)
-- Name: PRUEBASCOMP_BorrarConceptos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PRUEBASCOMP_BorrarConceptos"
    ADD CONSTRAINT "PRUEBASCOMP_BorrarConceptos_pkey" PRIMARY KEY (idborrar);


--
-- TOC entry 2233 (class 2606 OID 43413)
-- Name: PRUEBASCOMP_BorrarMediciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PRUEBASCOMP_BorrarMediciones"
    ADD CONSTRAINT "PRUEBASCOMP_BorrarMediciones_pkey" PRIMARY KEY (idborrar);


--
-- TOC entry 2229 (class 2606 OID 43397)
-- Name: PRUEBASCOMP_BorrarRelacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PRUEBASCOMP_BorrarRelacion"
    ADD CONSTRAINT "PRUEBASCOMP_BorrarRelacion_pkey" PRIMARY KEY (idborrar);


--
-- TOC entry 2223 (class 2606 OID 43367)
-- Name: PRUEBASCOMP_Conceptos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PRUEBASCOMP_Conceptos"
    ADD CONSTRAINT "PRUEBASCOMP_Conceptos_pkey" PRIMARY KEY (codigo);


--
-- TOC entry 2227 (class 2606 OID 43386)
-- Name: PRUEBASCOMP_Mediciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PRUEBASCOMP_Mediciones"
    ADD CONSTRAINT "PRUEBASCOMP_Mediciones_pkey" PRIMARY KEY (id);


--
-- TOC entry 2225 (class 2606 OID 43375)
-- Name: PRUEBASCOMP_Relacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PRUEBASCOMP_Relacion"
    ADD CONSTRAINT "PRUEBASCOMP_Relacion_pkey" PRIMARY KEY (id);


--
-- TOC entry 2221 (class 2606 OID 41608)
-- Name: kaka_BorrarConceptos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."kaka_BorrarConceptos"
    ADD CONSTRAINT "kaka_BorrarConceptos_pkey" PRIMARY KEY (idborrar);


--
-- TOC entry 2219 (class 2606 OID 41600)
-- Name: kaka_BorrarRelacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."kaka_BorrarRelacion"
    ADD CONSTRAINT "kaka_BorrarRelacion_pkey" PRIMARY KEY (idborrar);


--
-- TOC entry 2213 (class 2606 OID 41442)
-- Name: kaka_Conceptos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."kaka_Conceptos"
    ADD CONSTRAINT "kaka_Conceptos_pkey" PRIMARY KEY (codigo);


--
-- TOC entry 2217 (class 2606 OID 41461)
-- Name: kaka_Mediciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."kaka_Mediciones"
    ADD CONSTRAINT "kaka_Mediciones_pkey" PRIMARY KEY (id);


--
-- TOC entry 2215 (class 2606 OID 41450)
-- Name: kaka_Relacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."kaka_Relacion"
    ADD CONSTRAINT "kaka_Relacion_pkey" PRIMARY KEY (id);


--
-- TOC entry 2355 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2018-12-06 09:36:06 CET

--
-- PostgreSQL database dump complete
--


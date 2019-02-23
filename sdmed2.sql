--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.14
-- Dumped by pg_dump version 9.5.14

-- Started on 2019-02-23 10:55:09 CET

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
-- TOC entry 2430 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 698 (class 1247 OID 68357)
-- Name: tp_medicion; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tp_medicion AS (
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


ALTER TYPE public.tp_medicion OWNER TO postgres;

--
-- TOC entry 725 (class 1247 OID 114517)
-- Name: tp_certificacion; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tp_certificacion AS (
	id integer,
	num_certif integer,
	fecha date,
	m public.tp_medicion
);


ALTER TYPE public.tp_certificacion OWNER TO postgres;

--
-- TOC entry 668 (class 1247 OID 68362)
-- Name: tp_color; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tp_color AS ENUM (
    'NORMAL',
    'BLOQUEADO',
    'DESCOMPUESTO'
);


ALTER TYPE public.tp_color OWNER TO postgres;

--
-- TOC entry 728 (class 1247 OID 68336)
-- Name: tp_concepto; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tp_concepto AS (
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


ALTER TYPE public.tp_concepto OWNER TO postgres;

--
-- TOC entry 737 (class 1247 OID 68374)
-- Name: tp_copiarconcepto; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tp_copiarconcepto AS (
	idcopiar integer,
	paso integer,
	c public.tp_concepto
);


ALTER TYPE public.tp_copiarconcepto OWNER TO postgres;

--
-- TOC entry 731 (class 1247 OID 68348)
-- Name: tp_relacion; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tp_relacion AS (
	id integer,
	codpadre character varying,
	codhijo character varying,
	canpres numeric(7,3),
	cancert numeric(7,3),
	posicion smallint
);


ALTER TYPE public.tp_relacion OWNER TO postgres;

--
-- TOC entry 734 (class 1247 OID 77295)
-- Name: tp_copiarrelacion; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tp_copiarrelacion AS (
	idcopiar integer,
	grupo integer,
	r public.tp_relacion
);


ALTER TYPE public.tp_copiarrelacion OWNER TO postgres;

--
-- TOC entry 701 (class 1247 OID 112690)
-- Name: tp_guardarconcepto; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tp_guardarconcepto AS (
	idguardar integer,
	paso integer,
	tipoaccion integer,
	c public.tp_concepto
);


ALTER TYPE public.tp_guardarconcepto OWNER TO postgres;

--
-- TOC entry 704 (class 1247 OID 112693)
-- Name: tp_guardarmedicion; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tp_guardarmedicion AS (
	idguardar integer,
	paso integer,
	tipoaccion integer,
	m public.tp_medicion
);


ALTER TYPE public.tp_guardarmedicion OWNER TO postgres;

--
-- TOC entry 707 (class 1247 OID 112696)
-- Name: tp_guardarrelacion; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tp_guardarrelacion AS (
	idguardar integer,
	paso integer,
	tipoaccion integer,
	r public.tp_relacion
);


ALTER TYPE public.tp_guardarrelacion OWNER TO postgres;

--
-- TOC entry 743 (class 1247 OID 68380)
-- Name: tp_lineamedicion; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tp_lineamedicion AS (
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


ALTER TYPE public.tp_lineamedicion OWNER TO postgres;

--
-- TOC entry 740 (class 1247 OID 68377)
-- Name: tp_partida; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tp_partida AS (
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


ALTER TYPE public.tp_partida OWNER TO postgres;

--
-- TOC entry 255 (class 1255 OID 68738)
-- Name: actualizar_desde_nodo(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.actualizar_desde_nodo(_nombretabla character varying, _codigonodo character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$

DECLARE
    nuevo_precio numeric;
    r record;
    existe boolean;
    bloqueado numeric(7,3);
    tablaconceptos character varying := _nombretabla || '_Conceptos';
    tablarelacion character varying := _nombretabla || '_Relacion';
    str_null_case character varying;
BEGIN
IF (_codigonodo = '') IS NOT FALSE THEN
	str_null_case := ' IS NULL';
ELSE
	str_null_case := ' = '||quote_literal(_codigonodo);
END IF;
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
IF nuevo_precio IS NULL THEN nuevo_precio = 0; END IF;
EXECUTE FORMAT ('UPDATE %I SET preciomed = %s WHERE codigo %s', tablaconceptos, quote_literal(nuevo_precio), str_null_case);
--RAISE NOTICE 'El valor del nodo es: %', nuevo_precio;
EXECUTE FORMAT ('SELECT EXISTS (SELECT codhijo FROM %I WHERE codhijo %s)', tablarelacion, str_null_case) INTO existe;
IF existe = TRUE THEN
	FOR r IN EXECUTE FORMAT ('SELECT * FROM %I WHERE codhijo %s', tablarelacion, str_null_case)
	LOOP
		--RAISE NOTICE 'Hay que seguir para arriba con: %,%',r.codpadre,r.codhijo;
		EXECUTE FORMAT ('SELECT actualizar_desde_nodo(%s,%s)', quote_literal(_nombretabla), 
		CASE WHEN r.codpadre IS NULL THEN 'null' ELSE quote_literal(r.codpadre) END);
	END LOOP;
END IF;
END;
$$;


ALTER FUNCTION public.actualizar_desde_nodo(_nombretabla character varying, _codigonodo character varying) OWNER TO postgres;

--
-- TOC entry 244 (class 1255 OID 18492)
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
-- TOC entry 259 (class 1255 OID 18986)
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
-- TOC entry 283 (class 1255 OID 114439)
-- Name: anadir_certificacion(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.anadir_certificacion(_nombretabla character varying, fecha character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
tabla_listado_certificaciones character varying := _nombretabla || '_ListadoCertificaciones';
secuencia character varying := tabla_listado_certificaciones||'_id_seq';
fecha date := procesar_cadena_fecha(fecha);
resultado boolean := false;
existe boolean;
ultima_fecha date;

BEGIN
--PRIMERO CREO LA TABLA DE CERTIFICACIONES Y LA SECUENCIA, SI NO ESTA YA CREADA
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = %L)', tabla_listado_certificaciones) INTO existe;
IF existe IS FALSE THEN
	EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I (num_certificacion integer PRIMARY KEY,fecha date)',tabla_listado_certificaciones);
	EXECUTE FORMAT ('CREATE SEQUENCE %I',_nombretabla||'_ListadoCertificaciones_id_seq');
	EXECUTE FORMAT ('ALTER TABLE %I ALTER COLUMN num_certificacion SET NOT NULL, ALTER COLUMN num_certificacion SET DEFAULT nextval (''%I''::regclass)',
	tabla_listado_certificaciones, secuencia);
END IF;
--AHORA INSERTO LA NUEVA CERTIFICACION. LA FUNCION COMPRUEBA QUE LA FECHA SEA MAYOR A LA ULTIMA INGRESADA.SI NO LO ES, NO HACE NADA Y RETORNA FALSE
EXECUTE FORMAT ('SELECT fecha FROM %I WHERE num_certificacion = (SELECT MAX(num_certificacion) FROM %I)',tabla_listado_certificaciones,tabla_listado_certificaciones) INTO ultima_fecha;
IF ultima_fecha IS NULL OR fecha > ultima_fecha THEN
	EXECUTE FORMAT ('INSERT INTO %I (fecha) VALUES ($1)',tabla_listado_certificaciones) USING fecha;
	resultado = true;
END IF;
return resultado;
END;
$_$;


ALTER FUNCTION public.anadir_certificacion(_nombretabla character varying, fecha character varying) OWNER TO postgres;

--
-- TOC entry 261 (class 1255 OID 20163)
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
-- TOC entry 302 (class 1255 OID 42757)
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
-- TOC entry 265 (class 1255 OID 112637)
-- Name: borrar_hijos(character varying, character varying, character varying, integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.borrar_hijos(_nombretabla character varying, _codigopadre character varying, _codigohijos character varying DEFAULT NULL::character varying, _tipoaccion integer DEFAULT 0, _restaurar boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$ 
DECLARE
--la funcion borrar los hijos de un nodo y lo que hay debajo de ellos y los guarda en una tabla para su posterior restauracion
--si se deshace la accion. Tambien se definira el tipo de accion que -pegado o borrado- para tenerlo en cuenta a la hora
-- de sacarlo de la tabla
num_paso integer;
tablaconceptos character varying := _nombretabla || '_Conceptos';
tablarelacion character varying := _nombretabla || '_Relacion';

tablaguardarconceptos character varying := _nombretabla || '_GuardarConceptos';
tablaguardarrelacion character varying := _nombretabla || '_GuardarRelaciones';
tablaguardarmedicion character varying := _nombretabla || '_GuardarMediciones';
arraycodigoshijos character varying[];

r tp_relacion%ROWTYPE;
rg tp_guardarrelacion%ROWTYPE;
c tp_concepto%ROWTYPE;
cg tp_guardarconcepto%ROWTYPE;
existe boolean;
BEGIN
IF _codigohijos IS NULL THEN --SI NO HAY ARRAY DE CODIGOS HIJO BORRO TODOS LOS QUE PENDEN DEL PADRE
	EXECUTE FORMAT('SELECT array_agg(codhijo) from %I WHERE codpadre = %s',
			tablarelacion,quote_literal(_codigopadre)) INTO arraycodigoshijos;	
ELSE --SI HAY CADENA DE ARRAY DE CODIGOS, LOS METO EN EL ARRAY DE LA FUNCION
	arraycodigoshijos = string_to_array(_codigohijos,',');
	--raise notice 'el array a borrar es: %',arraycodigoshijos;
END IF;
--FINALMENTE EJECUTO LA FUNCION
PERFORM borrar_lineas_principal(_nombretabla,_codigopadre,arraycodigoshijos,_tipoaccion,_restaurar);
--pongo el numero de paso en la tabla de borrar
EXECUTE FORMAT ('SELECT MAX(paso)+1 FROM %I',tablaguardarrelacion) INTO num_paso;
IF num_paso IS NULL THEN num_paso = 0; END IF;
EXECUTE FORMAT ('UPDATE %I SET paso = %s WHERE paso IS NULL',tablaguardarrelacion,num_paso);
--actualizar tabla guardar conceptos
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = %L)', tablaguardarconceptos) INTO existe;
IF existe IS TRUE THEN
	EXECUTE FORMAT ('UPDATE %I SET paso = %s WHERE paso IS NULL',tablaguardarconceptos,num_paso);
END IF;
--actualizar tabla guardar medicion
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = %L)', tablaguardarmedicion) INTO existe;
IF existe IS TRUE THEN
	EXECUTE FORMAT ('UPDATE %I SET paso = %s WHERE paso IS NULL',tablaguardarmedicion,num_paso);
END IF;
--Por ultimo actualizamos las cantidades
PERFORM actualizar_desde_nodo(_nombretabla,_codigopadre);
END;
$$;


ALTER FUNCTION public.borrar_hijos(_nombretabla character varying, _codigopadre character varying, _codigohijos character varying, _tipoaccion integer, _restaurar boolean) OWNER TO postgres;

--
-- TOC entry 269 (class 1255 OID 112739)
-- Name: borrar_lineas_medicion(character varying, integer[], integer, boolean, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.borrar_lineas_medicion(_nombretabla character varying, _ids integer[], _tipoaccion integer DEFAULT 0, _restaurar boolean DEFAULT true, _solomedicion boolean DEFAULT false) RETURNS void
    LANGUAGE plpgsql
    AS $$ 
DECLARE
    tamanno integer := array_length(_ids, 1);
    indice integer := 1;
    tablamediciones character varying := _nombretabla || '_Mediciones';
    tablaguardarrelacion character varying := _nombretabla || '_GuardarRelaciones';
    tablaguardarmedicion character varying := _nombretabla || '_GuardarMediciones';
    codigopadre character varying;
    codigohijo character varying;
    m tp_medicion%ROWTYPE;
    num_paso integer := NULL;
    existe boolean;    
--LA FUNCION TIENE DOS BOOLEANOS. SI restaurar es TRUE SE GUARDARAN LAS LINEAS DE MEDICION BORRADAS EN UNA TABLA PARA POSTERIORMENTE PODER 
--RECUPERARLAS
--POR OTRO LADO, SI LA FUNCION ES LLAMADA DESDE LA FUNCION borrar_lineas_principal, SERA ESTA LA QUE PONGA EL num_paso, PERO SI SE LLAMA
--DE FORMA DIRECTA SE PONDRA DESDE LA PROPIA FUNCION
BEGIN
--CREO LA TABLA DE MEDICION
EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I OF tp_guardarmedicion (PRIMARY KEY (idguardar))',tablaguardarmedicion);
--SOLO EJECUTO SI HAY ARRAY DE LINEAS DE MEDICION
IF tamanno IS NOT NULL THEN
	EXECUTE FORMAT ('SELECT codpadre FROM %I WHERE id = %s',tablamediciones,_ids[indice]) INTO codigopadre;
	EXECUTE FORMAT ('SELECT codhijo FROM %I WHERE id = %s',tablamediciones,_ids[indice]) INTO codigohijo;
	WHILE indice <= tamanno LOOP
	    IF _restaurar IS TRUE THEN
		EXECUTE FORMAT ('SELECT * FROM %I WHERE %I.id = %s',tablamediciones,tablamediciones,quote_literal(_ids[indice])) INTO m;
		PERFORM insertar_registro_guardarmedicion(tablaguardarmedicion,NULL,_tipoaccion,m);		
	    END IF;
            EXECUTE FORMAT ('DELETE FROM %I WHERE %I.id = %s',tablamediciones,tablamediciones,quote_literal(_ids[indice]));
            PERFORM modificar_cantidad(_nombretabla,codigopadre,codigohijo);
            indice = indice + 1;
	END LOOP;

	IF _solomedicion IS TRUE THEN
		EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = %s)', quote_literal(tablaguardarrelacion)) INTO existe;
		IF existe IS TRUE THEN--si hay tabla de relacion cojo el num_paso de ahí
			EXECUTE FORMAT ('SELECT MAX(paso)+1 FROM %I',tablaguardarrelacion) INTO num_paso;
		ELSE EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = %s)', quote_literal(tablaguardarmedicion)) INTO existe;
			IF existe IS TRUE THEN--si no hay tabla de relacionborrar pero si hay tabla medicionborrar cojo num_paso de ahi
				EXECUTE FORMAT ('SELECT MAX(paso)+1 FROM %I',tablaguardarmedicion) INTO num_paso;			
			END IF;
		END IF;
		IF num_paso IS NULL THEN num_paso = 0; END IF;
		EXECUTE FORMAT ('UPDATE %I SET paso = %s WHERE paso IS NULL',tablaguardarmedicion,num_paso);
	END IF;
END IF;    
   END;
$$;


ALTER FUNCTION public.borrar_lineas_medicion(_nombretabla character varying, _ids integer[], _tipoaccion integer, _restaurar boolean, _solomedicion boolean) OWNER TO postgres;

--
-- TOC entry 266 (class 1255 OID 112662)
-- Name: borrar_lineas_principal(character varying, character varying, character varying[], integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.borrar_lineas_principal(_nombretabla character varying, _codigopadre character varying, _codigoshijo character varying[], _tipoaccion integer DEFAULT 0, _restaurar boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$ 
DECLARE
tablaconceptos character varying := _nombretabla || '_Conceptos';
tablamediciones character varying := _nombretabla || '_Mediciones';
tablarelacion character varying := _nombretabla || '_Relacion';
tablaguardarconceptos character varying := _nombretabla || '_GuardarConceptos';
tablaguardarrelacion character varying := _nombretabla || '_GuardarRelaciones';
tablaguardarmedicion character varying := _nombretabla || '_GuardarMediciones';
existe boolean;
r tp_relacion%ROWTYPE;
c tp_concepto%ROWTYPE;
idmediciones integer[];
arraycodigoshijos character varying[];
indice integer;
BEGIN
--CREO LA TABLA DE RELACIONES BORRAR SI RESTAURAR ES TRUE Y NO EXISTE PREVIEMENTE
IF _restaurar IS TRUE THEN
	EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I OF tp_guardarrelacion (PRIMARY KEY (idguardar))',tablaguardarrelacion);
END IF;
IF _codigoshijo IS NOT NULL THEN	
	--ITERO SOBRE EL ARRAY DE CODIGOS HIJO
	FOR I IN array_lower(_codigoshijo, 1)..array_upper(_codigoshijo, 1) LOOP
		--METO LA RELACION PADRE HIJO EN LA TABLA DE RELACION EN UN REGISTRO SI RESTAURAR ES TRUE
		IF _restaurar IS TRUE THEN
			EXECUTE FORMAT ('SELECT * FROM %I WHERE codpadre = %L AND codhijo = %L',
					tablarelacion,
					_codigopadre,
					_codigoshijo[I])
					INTO r;
			--METO ESE REGISTRO EN LA TABLA DE RELACION BORRAR			
			PERFORM insertar_registro_guardarrelacion(tablaguardarrelacion,NULL,_tipoaccion,r);
		END IF;
		--BORRO LA RELACION PADRE-HIJO EN LA TABLA ORIGINAL
		EXECUTE FORMAT ('DELETE FROM %I WHERE codpadre = %s AND codhijo = %s', tablarelacion,quote_literal(_codigopadre),quote_literal(_codigoshijo[I]));
		--VEO SI QUEDAN MAS HIJOS EN LA TABLA RELACION
		EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM %I WHERE codhijo = %s )',	tablarelacion , quote_literal(_codigoshijo[I])) INTO existe;
		--SI NO QUEDAN MAS HIJOS:
		IF existe = FALSE THEN
		   --CREO LA TABLA DE CONCEPTOS BORRAR Y METO EL CONCEPTO Y LO BORRO DE LA TABLA DE CONCEPTOS SI restaurar ES TRUE
			IF _restaurar IS TRUE THEN
				EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I OF tp_guardarconcepto (PRIMARY KEY (idguardar))',tablaguardarconceptos);			
				EXECUTE FORMAT ('SELECT * FROM %I WHERE codigo = %s',tablaconceptos,quote_literal(_codigoshijo[I])) INTO c;
				PERFORM insertar_registro_guardarconcepto(tablaguardarconceptos,NULL,_tipoaccion,c);				
			END IF;
			--BORRO DE LA TABLA DE CONCEPTOS LOS HIJOS QUE CORRESPONDAN
			EXECUTE FORMAT ('DELETE FROM %I WHERE codigo = %s', tablaconceptos, quote_literal(_codigoshijo[I]));
			--METO LOS HIJOS EN UN ARRAY Y LLAMO DE NUEVO A LA FUNCION
			EXECUTE FORMAT('SELECT array_agg(codhijo) from %I WHERE codpadre = %s',
				tablarelacion,quote_literal(_codigoshijo[I])) INTO arraycodigoshijos;			
				PERFORM borrar_lineas_principal(_nombretabla,_codigoshijo[I],arraycodigoshijos,_tipoaccion,_restaurar);			
		END IF;
		--AHORA LAS MEDICIONES
		EXECUTE format('SELECT array_agg(id) from %I WHERE codpadre = %s AND codhijo = %s',
		tablamediciones,quote_literal(_codigopadre),quote_literal(_codigoshijo[I])) INTO idmediciones;
		IF idmediciones IS NOT NULL THEN
		    PERFORM borrar_lineas_medicion(_nombretabla,idmediciones,_tipoaccion);
		END IF;
		--queda la ordenacion de los elementos restantes
	END LOOP;
END IF;
END;
$$;


ALTER FUNCTION public.borrar_lineas_principal(_nombretabla character varying, _codigopadre character varying, _codigoshijo character varying[], _tipoaccion integer, _restaurar boolean) OWNER TO postgres;

--
-- TOC entry 281 (class 1255 OID 21783)
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
-- TOC entry 271 (class 1255 OID 21039)
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
-- TOC entry 286 (class 1255 OID 114651)
-- Name: certificar(character varying, character varying, character varying, character varying[], integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.certificar(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _indices character varying[], _num_certificacion integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$ 
DECLARE
--tablaconceptos character varying := _nombretabla || '_Conceptos';
--tablarelacion character varying := _nombretabla || '_Relacion';
tablamedicion character varying := _nombretabla || '_Mediciones';
tablacertificacion character varying := _nombretabla || '_Certificaciones';
secuencia character varying := tablacertificacion||'_id_seq';
m tp_medicion%ROWTYPE;
fila tp_medicion%rowtype;
existe boolean;
/*tablacopiarconceptos character varying := '__CopiarConceptos';
tablacopiarrelacion character varying := '__CopiarRelacion';
tablacopiarmediciones character varying := '__CopiarMediciones';

r tp_relacion%ROWTYPE;
c tp_concepto%ROWTYPE;
existe boolean;
arraycodigoshijos character varying[];*/

BEGIN
--CREO LA TABLA CERTIFICAR SI NO EXISTE
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = %L)', tablacertificacion) INTO existe;
IF existe IS FALSE THEN
	EXECUTE format ('CREATE TABLE %I OF tp_certificacion (PRIMARY KEY (id))',tablacertificacion);
	EXECUTE FORMAT ('CREATE SEQUENCE %I',_nombretabla||'_Certificaciones_id_seq');
	EXECUTE FORMAT ('ALTER TABLE %I ALTER COLUMN id SET NOT NULL, ALTER COLUMN id SET DEFAULT nextval (''%I''::regclass)',
	tablacertificacion, secuencia);
END IF;
--RECORRO LOS INDICES DADOS DE LA TABLA DE MEDICION
FOR fila in EXECUTE FORMAT('SELECT *, ROW_NUMBER() OVER (ORDER BY id) AS indice FROM %I WHERE codhijo = $1 AND codpadre = $2 ORDER BY id',tablamedicion)
	USING _codigohijo,_codigopadre
LOOP
	RAISE NOTICE 'Comentario: %',fila.comentario;
END LOOP;
--segundo paso, recorrer los codigos seleccionados
/*IF _codigos IS NOT NULL THEN	
	--ITERO SOBRE EL ARRAY DE CODIGOS HIJO
	FOR I IN array_lower(_codigos, 1)..array_upper(_codigos, 1)
	LOOP
		--copio las primeras relaciones
		EXECUTE FORMAT ('INSERT INTO %I	SELECT * FROM %I WHERE codpadre = %L AND codhijo = %L ON CONFLICT DO NOTHING',
							tablacopiarrelacion,
							tablarelacion,
							_codigopadre,
							_codigos[I]);
		--pongo nulos los conceptos raiz
		IF _primer_paso IS TRUE THEN
				EXECUTE FORMAT ('UPDATE %I SET codpadre = NULL WHERE codpadre = %L AND codhijo = %L',
						tablacopiarrelacion,
						_codigopadre,
						_codigos[I]);
		END IF;
		--ahora meto los conceptos
		EXECUTE FORMAT ('INSERT INTO %I	SELECT * FROM %I WHERE codigo = %L ON CONFLICT DO NOTHING',
			tablacopiarconceptos,
			tablaconceptos,
			_codigos[I]);
		--mediciones
		EXECUTE FORMAT ('INSERT INTO %I	SELECT * FROM %I WHERE codpadre = %L AND codhijo = %L ON CONFLICT DO NOTHING',
			tablacopiarmediciones,
			tablamedicion,
			_codigopadre,
			_codigos[I]);		
		--selecciono los hijos de cada hijo y llamo de nuevo a la funcion
		EXECUTE FORMAT('SELECT array_agg(codhijo) from %I WHERE codpadre = %L',
			tablarelacion,_codigos[I]) INTO arraycodigoshijos;
		PERFORM copiar(_nombretabla,_codigos[I], arraycodigoshijos,'FALSE');		
	END LOOP;
END IF;*/
END;
$_$;


ALTER FUNCTION public.certificar(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying, _indices character varying[], _num_certificacion integer) OWNER TO postgres;

--
-- TOC entry 264 (class 1255 OID 94819)
-- Name: copiar(character varying, character varying, character varying[], boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.copiar(_nombretabla character varying, _codigopadre character varying, _codigos character varying[], _primer_paso boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$ 
DECLARE
tablaconceptos character varying := _nombretabla || '_Conceptos';
tablarelacion character varying := _nombretabla || '_Relacion';
tablamedicion character varying := _nombretabla || '_Mediciones';


tablacopiarconceptos character varying := '__CopiarConceptos';
tablacopiarrelacion character varying := '__CopiarRelacion';
tablacopiarmediciones character varying := '__CopiarMediciones';

r tp_relacion%ROWTYPE;
c tp_concepto%ROWTYPE;

existe boolean;
arraycodigoshijos character varying[];

BEGIN
--primer paso, crear las tablas copiar conceptos, relaciones y mediciones y por si ya existieran, borrar su contenido
--Esta operacion solo se realizara en la primera llamada a la funcion
IF _primer_paso IS TRUE THEN
    EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I OF tp_relacion (PRIMARY KEY (id))',tablacopiarrelacion);
    EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I OF tp_concepto (PRIMARY KEY (codigo))',tablacopiarconceptos);
    EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I OF tp_medicion (PRIMARY KEY (id))',tablacopiarmediciones);
    -- Luego se limpiaran por si ya existieran y tuvieran contenido
    EXECUTE FORMAT ('TRUNCATE %I,%I,%I',tablacopiarrelacion,tablacopiarconceptos,tablacopiarmediciones);
END IF;
--segundo paso, recorrer los codigos seleccionados
IF _codigos IS NOT NULL THEN	
	--ITERO SOBRE EL ARRAY DE CODIGOS HIJO
	FOR I IN array_lower(_codigos, 1)..array_upper(_codigos, 1)
	LOOP
		--copio las primeras relaciones
		EXECUTE FORMAT ('INSERT INTO %I	SELECT * FROM %I WHERE codpadre = %L AND codhijo = %L ON CONFLICT DO NOTHING',
							tablacopiarrelacion,
							tablarelacion,
							_codigopadre,
							_codigos[I]);
		--pongo nulos los conceptos raiz
		IF _primer_paso IS TRUE THEN
				EXECUTE FORMAT ('UPDATE %I SET codpadre = NULL WHERE codpadre = %L AND codhijo = %L',
						tablacopiarrelacion,
						_codigopadre,
						_codigos[I]);
		END IF;
		--ahora meto los conceptos
		EXECUTE FORMAT ('INSERT INTO %I	SELECT * FROM %I WHERE codigo = %L ON CONFLICT DO NOTHING',
			tablacopiarconceptos,
			tablaconceptos,
			_codigos[I]);
		--mediciones
		EXECUTE FORMAT ('INSERT INTO %I	SELECT * FROM %I WHERE codpadre = %L AND codhijo = %L ON CONFLICT DO NOTHING',
			tablacopiarmediciones,
			tablamedicion,
			_codigopadre,
			_codigos[I]);		
		--selecciono los hijos de cada hijo y llamo de nuevo a la funcion
		EXECUTE FORMAT('SELECT array_agg(codhijo) from %I WHERE codpadre = %L',
			tablarelacion,_codigos[I]) INTO arraycodigoshijos;
		PERFORM copiar(_nombretabla,_codigos[I], arraycodigoshijos,'FALSE');		
	END LOOP;
END IF;
END;
$$;


ALTER FUNCTION public.copiar(_nombretabla character varying, _codigopadre character varying, _codigos character varying[], _primer_paso boolean) OWNER TO postgres;

--
-- TOC entry 288 (class 1255 OID 26129)
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
-- TOC entry 246 (class 1255 OID 68341)
-- Name: crear_tabla_conceptos(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.crear_tabla_conceptos(codigo character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
cadena text;
BEGIN
EXECUTE format ('CREATE TABLE IF NOT EXISTS %I OF tp_concepto (PRIMARY KEY (codigo))',codigo||'_Conceptos');		
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
-- TOC entry 293 (class 1255 OID 27302)
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
EXECUTE format ('CREATE TABLE IF NOT EXISTS %I OF tp_medicion (PRIMARY KEY (id))',tablamedicion);
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
-- TOC entry 292 (class 1255 OID 27293)
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
EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I OF tp_relacion (PRIMARY KEY (id))',tablarelacion);
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
-- TOC entry 291 (class 1255 OID 26373)
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
-- TOC entry 303 (class 1255 OID 43477)
-- Name: es_precio_bloqueado(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.es_precio_bloqueado(nombretabla character varying, codigo character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
tablaconceptos character varying := nombretabla || '_Conceptos';
resultado boolean;
BEGIN
EXECUTE FORMAT ('SELECT preciobloq IS NOT NULL FROM %I WHERE codigo = %s',tablaconceptos,quote_literal(codigo)) INTO resultado;
RETURN resultado;
END;
$$;


ALTER FUNCTION public.es_precio_bloqueado(nombretabla character varying, codigo character varying) OWNER TO postgres;

--
-- TOC entry 298 (class 1255 OID 30876)
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
-- TOC entry 289 (class 1255 OID 26370)
-- Name: existe_hermano(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.existe_hermano(nombretabla character varying, codigopadre character varying, codigohijo character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
--r relacion%ROWTYPE;
r character varying;

BEGIN
RAISE NOTICE 'FUNCION EXISTE HERMANO CON %-%-%',nombretabla,codigopadre,codigohijo;
FOR r in EXECUTE FORMAT ('SELECT codhijo FROM %I WHERE codpadre = %s', nombretabla||'_Relacion', codigopadre)
 LOOP
 	RAISE NOTICE 'Estudio el par : %-%',r,codigohijo;
 	IF quote_literal(r) = codigohijo THEN 	
 	RETURN TRUE;
 	END IF;
 END LOOP;
RETURN FALSE;
END;
$$;


ALTER FUNCTION public.existe_hermano(nombretabla character varying, codigopadre character varying, codigohijo character varying) OWNER TO postgres;

--
-- TOC entry 282 (class 1255 OID 29562)
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
-- TOC entry 296 (class 1255 OID 29561)
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
-- TOC entry 253 (class 1255 OID 68682)
-- Name: hay_descomposicion(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.hay_descomposicion(_nombretabla character varying, _codigo character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
tablarelacion character varying := _nombretabla || '_Relacion';
resultado boolean;
BEGIN
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM %I WHERE codpadre = %L )',tablarelacion , _codigo) INTO resultado;
RETURN resultado;
END;
$$;


ALTER FUNCTION public.hay_descomposicion(_nombretabla character varying, _codigo character varying) OWNER TO postgres;

--
-- TOC entry 254 (class 1255 OID 68683)
-- Name: hay_medicion(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.hay_medicion(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
tablamedicion character varying := _nombretabla || '_Mediciones';
resultado boolean;
BEGIN
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM %I WHERE codpadre = %L AND codhijo = %L)',
tablamedicion, _codigopadre, _codigohijo) INTO resultado;
RETURN resultado;
END;
$$;


ALTER FUNCTION public.hay_medicion(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying) OWNER TO postgres;

--
-- TOC entry 280 (class 1255 OID 21364)
-- Name: insertar_concepto(character varying, character varying, character varying, character varying, numeric, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertar_concepto(nombretabla character varying, codigopadre character varying, u character varying DEFAULT ''::character varying, resumen character varying DEFAULT ''::character varying, precio numeric DEFAULT 0, nat integer DEFAULT 7, fec character varying DEFAULT ''::character varying) RETURNS void
    LANGUAGE plpgsql
    AS $_$

DECLARE
tablaconceptos character varying := nombretabla || '_Conceptos';
fecha date;
existe boolean;

BEGIN
fecha = procesar_cadena_fecha(fec);
EXECUTE FORMAT ('SELECT NOT EXISTS (SELECT codigo FROM %I WHERE codigo = %L)', tablaconceptos, codigopadre) INTO existe;
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
-- TOC entry 262 (class 1255 OID 94094)
-- Name: insertar_medicion(character varying, character varying, character varying, integer, integer, character varying, numeric, numeric, numeric, numeric, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertar_medicion(nombretabla character varying, codigopadre character varying, codigohijo character varying, posicion integer DEFAULT (- (1)::smallint), tipo integer DEFAULT 0, comentario character varying DEFAULT NULL::character varying, ud numeric DEFAULT (0)::numeric, longitud numeric DEFAULT (0)::numeric, anchura numeric DEFAULT (0)::numeric, altura numeric DEFAULT (0)::numeric, formula character varying DEFAULT NULL::character varying, idfila integer DEFAULT NULL::integer) RETURNS integer
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
--RAISE NOTICE 'INSERTAR EN % LA UD: %, LA LANOGITUD %, LA ANCHURA % Y LA ALTURA %', tablamediciones, ud,longitud,anchura,altura;
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


ALTER FUNCTION public.insertar_medicion(nombretabla character varying, codigopadre character varying, codigohijo character varying, posicion integer, tipo integer, comentario character varying, ud numeric, longitud numeric, anchura numeric, altura numeric, formula character varying, idfila integer) OWNER TO postgres;

--
-- TOC entry 263 (class 1255 OID 94640)
-- Name: insertar_partida(character varying, character varying, character varying, numeric, smallint, character varying, character varying, text, numeric, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertar_partida(nombretabla character varying, codigopadre character varying, codigohijo character varying, cantidad numeric DEFAULT 1, pos smallint DEFAULT (- (1)::smallint), u character varying DEFAULT ''::character varying, res character varying DEFAULT ''::character varying, texto text DEFAULT ''::text, precio numeric DEFAULT 0, nat integer DEFAULT 7, fec character varying DEFAULT ''::character varying) RETURNS integer
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
RAISE NOTICE 'HE LLEGADO HASTA AQUI y voy con la cantidad: %',cantidad;
PERFORM insertar_relacion(nombretabla, codigopadre, codigohijo, cantidad, pos);
PERFORM actualizar_desde_nodo(nombretabla,codigopadre);
RETURN 0;
END;
$_$;


ALTER FUNCTION public.insertar_partida(nombretabla character varying, codigopadre character varying, codigohijo character varying, cantidad numeric, pos smallint, u character varying, res character varying, texto text, precio numeric, nat integer, fec character varying) OWNER TO postgres;

--
-- TOC entry 268 (class 1255 OID 112713)
-- Name: insertar_registro_guardarconcepto(character varying, integer, integer, public.tp_concepto); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertar_registro_guardarconcepto(_nombretabla character varying, _paso integer, _tipoaccion integer, _dato public.tp_concepto) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
EXECUTE FORMAT ('INSERT INTO %I VALUES
	(CASE WHEN (SELECT MAX(idguardar) FROM %I) IS NULL THEN 0 ELSE (SELECT MAX(idguardar)+1 FROM %I) END,
	%L,
	%L,
	(%L,%L,%L,%L,%L,%s,%L,%L,%L,%s))',_nombretabla,_nombretabla,_nombretabla,
	_paso,
	_tipoaccion,
	_dato.codigo,
	_dato.resumen,
	COALESCE(_dato.descripcion,''),
	COALESCE(_dato.descripcionhtml,''),
	_dato.preciomed,
	COALESCE(_dato.preciobloq::varchar,'NULL'),
	_dato.naturaleza,
	_dato.fecha,
	COALESCE(_dato.ud,''),
	COALESCE(_dato.preciocert::varchar,'NULL')
	);
END;
$$;


ALTER FUNCTION public.insertar_registro_guardarconcepto(_nombretabla character varying, _paso integer, _tipoaccion integer, _dato public.tp_concepto) OWNER TO postgres;

--
-- TOC entry 272 (class 1255 OID 112804)
-- Name: insertar_registro_guardarmedicion(character varying, integer, integer, public.tp_medicion); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertar_registro_guardarmedicion(_nombretabla character varying, _paso integer, _tipoaccion integer, _dato public.tp_medicion) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
EXECUTE FORMAT ('INSERT INTO %I VALUES
	(CASE WHEN (SELECT MAX(idguardar) FROM %I) IS NULL THEN 0 ELSE (SELECT MAX(idguardar)+1 FROM %I) END,
	%L,
	%L,
	(%L,%s,%s,%L,%s,%s,%s,%s,%L,%L,%L,%s))',_nombretabla,_nombretabla,_nombretabla,
	_paso,
	_tipoaccion,
	_dato.id,
	COALESCE(_dato.fase::varchar,'NULL'),
	COALESCE(_dato.tipo::varchar,'NULL'),
	COALESCE(_dato.comentario,''),
	COALESCE(_dato.ud::varchar,'NULL'),
	COALESCE(_dato.longitud::varchar,'NULL'),
	COALESCE(_dato.anchura::varchar,'NULL'),
	COALESCE(_dato.altura::varchar,'NULL'),
	COALESCE(_dato.formula,''),
	_dato.codpadre,
	_dato.codhijo,
	COALESCE(_dato.posicion::varchar,'NULL')
	);
END;
$$;


ALTER FUNCTION public.insertar_registro_guardarmedicion(_nombretabla character varying, _paso integer, _tipoaccion integer, _dato public.tp_medicion) OWNER TO postgres;

--
-- TOC entry 267 (class 1255 OID 112671)
-- Name: insertar_registro_guardarrelacion(character varying, integer, integer, public.tp_relacion); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertar_registro_guardarrelacion(_nombretabla character varying, _paso integer, _tipoaccion integer, _dato public.tp_relacion) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
EXECUTE FORMAT ('INSERT INTO %I VALUES(
	CASE WHEN (SELECT MAX(idguardar) FROM %I) IS NULL THEN 0 ELSE (SELECT MAX(idguardar)+1 FROM %I) END,
	%L,
	%L,
	(%L,%L,%L,%L,%L,%L))',_nombretabla,_nombretabla,_nombretabla,
	_paso,
	_tipoaccion,
	_dato.id,
	_dato.codpadre,
	_dato.codhijo,
	_dato.canpres,
	COALESCE(_dato.cancert,0),
	_dato.posicion
	);
END;
$$;


ALTER FUNCTION public.insertar_registro_guardarrelacion(_nombretabla character varying, _paso integer, _tipoaccion integer, _dato public.tp_relacion) OWNER TO postgres;

--
-- TOC entry 258 (class 1255 OID 77533)
-- Name: insertar_registro_medicion(character varying, integer, public.tp_medicion); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertar_registro_medicion(_nombretabla character varying, _paso integer, _dato public.tp_medicion) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
EXECUTE FORMAT ('INSERT INTO %I VALUES
	(CASE WHEN (SELECT MAX(idborrar) FROM %I) IS NULL THEN 0 ELSE (SELECT MAX(idborrar)+1 FROM %I) END,
	%L,
	(%L,%s,%s,%L,%s,%s,%s,%s,%L,%L,%L,%s))',_nombretabla,_nombretabla,_nombretabla,
	_paso,
	_dato.id,
	COALESCE(_dato.fase::varchar,'NULL'),
	COALESCE(_dato.tipo::varchar,'NULL'),
	COALESCE(_dato.comentario,''),
	COALESCE(_dato.ud::varchar,'NULL'),
	COALESCE(_dato.longitud::varchar,'NULL'),
	COALESCE(_dato.anchura::varchar,'NULL'),
	COALESCE(_dato.altura::varchar,'NULL'),
	COALESCE(_dato.formula,''),
	_dato.codpadre,
	_dato.codhijo,
	COALESCE(_dato.posicion::varchar,'NULL')
	);
END;
$$;


ALTER FUNCTION public.insertar_registro_medicion(_nombretabla character varying, _paso integer, _dato public.tp_medicion) OWNER TO postgres;

--
-- TOC entry 260 (class 1255 OID 77539)
-- Name: insertar_registro_relacion(character varying, integer, public.tp_relacion); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertar_registro_relacion(_nombretabla character varying, _paso integer, _dato public.tp_relacion) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
EXECUTE FORMAT ('INSERT INTO %I VALUES(
	CASE WHEN (SELECT MAX(idborrar) FROM %I) IS NULL THEN 0 ELSE (SELECT MAX(idborrar)+1 FROM %I) END,
	%L,
	(%L,%L,%L,%L,%L,%L))',_nombretabla,_nombretabla,_nombretabla,
	_paso,
	_dato.id,
	_dato.codpadre,
	_dato.codhijo,
	_dato.canpres,
	COALESCE(_dato.cancert,0),
	_dato.posicion
	);
END;
$$;


ALTER FUNCTION public.insertar_registro_relacion(_nombretabla character varying, _paso integer, _dato public.tp_relacion) OWNER TO postgres;

--
-- TOC entry 285 (class 1255 OID 26466)
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
--RAISE NOTICE 'insertar_relacion con % - % en la posicion: % y cantidad: %',codigopadre,codigohijo,pos,cantidad;
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
-- TOC entry 252 (class 1255 OID 68663)
-- Name: insertar_texto(character varying, character varying, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertar_texto(_nombretabla character varying, _cod character varying, _texto text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
tablaconceptos character varying := _nombretabla||'_Conceptos';
BEGIN
EXECUTE FORMAT ('UPDATE %I SET descripcion = %L WHERE codigo = %L',tablaconceptos,_texto,_cod);
END;
$$;


ALTER FUNCTION public.insertar_texto(_nombretabla character varying, _cod character varying, _texto text) OWNER TO postgres;

--
-- TOC entry 276 (class 1255 OID 113848)
-- Name: insertar_tipo_concepto(character varying, public.tp_concepto); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertar_tipo_concepto(nombretabla character varying, _dato public.tp_concepto) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
tablaconceptos character varying := nombretabla || '_Conceptos';
existe boolean := true;
BEGIN
EXECUTE FORMAT ('SELECT EXISTS (SELECT codigo FROM %I WHERE codigo = %L)', tablaconceptos, _dato.codigo) INTO existe;
IF existe = FALSE THEN
	EXECUTE FORMAT ('INSERT INTO %I (codigo,resumen,descripcion,descripcionhtml,preciomed,preciobloq,naturaleza,fecha,ud,preciocert) VALUES
			($1,$2,$3,$4,$5,$6,$7,$8,$9,$10)',tablaconceptos)
			USING		
			_dato.codigo,
			_dato.resumen,
			COALESCE(_dato.descripcion,''),
			COALESCE(_dato.descripcionhtml,''),
			_dato.preciomed,
			_dato.preciobloq,
			_dato.naturaleza,
			_dato.fecha,
			COALESCE(_dato.ud,''),
			_dato.preciocert
			;	
END IF;
RETURN existe;
END;
$_$;


ALTER FUNCTION public.insertar_tipo_concepto(nombretabla character varying, _dato public.tp_concepto) OWNER TO postgres;

--
-- TOC entry 279 (class 1255 OID 113849)
-- Name: insertar_tipo_medicion(character varying, public.tp_medicion); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertar_tipo_medicion(_nombretabla character varying, _dato public.tp_medicion) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
tablamedicion character varying := _nombretabla || '_Mediciones';
existe boolean := true;
BEGIN
--EXECUTE FORMAT ('SELECT EXISTS (SELECT codigo FROM %I WHERE codigo = %L)', tablaconceptos, _dato.codigo) INTO existe;
--IF existe = FALSE THEN
		/*EXECUTE FORMAT ('INSERT INTO %I VALUES(%L,%s,%s,%L,%s,%s,%s,%s,%L,%L,%L,%s)',tablamedicion,
	m.id,
	COALESCE(m.fase::varchar,'NULL'),
	COALESCE(m.tipo::varchar,'NULL'),
	COALESCE(m.comentario,''),
	COALESCE(m.ud::varchar,'NULL'),
	COALESCE(m.longitud::varchar,'NULL'),
	COALESCE(m.anchura::varchar,'NULL'),
	COALESCE(m.altura::varchar,'NULL'),
	COALESCE(m.formula,''),
	m.codpadre,
	m.codhijo,				
	COALESCE(m.posicion::varchar,'NULL')
	);*/
RAISE NOTICE 'INSERTAR TIPO MEDICION %-%',_dato.codpadre,_dato.codhijo;
EXECUTE FORMAT ('INSERT INTO %I VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12)',tablamedicion)
	USING
	_dato.id,
	COALESCE(_dato.fase,NULL),
	COALESCE(_dato.tipo,NULL),
	COALESCE(_dato.comentario,''),
	COALESCE(_dato.ud,NULL),
	COALESCE(_dato.longitud,NULL),
	COALESCE(_dato.anchura,NULL),
	COALESCE(_dato.altura,NULL),	
	COALESCE(_dato.formula,''),
	_dato.codpadre,
	_dato.codhijo,				
	COALESCE(_dato.posicion,NULL)
	;
--END IF;
RETURN existe;
END;
$_$;


ALTER FUNCTION public.insertar_tipo_medicion(_nombretabla character varying, _dato public.tp_medicion) OWNER TO postgres;

--
-- TOC entry 278 (class 1255 OID 113885)
-- Name: insertar_tipo_relacion(character varying, public.tp_relacion); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insertar_tipo_relacion(_nombretabla character varying, _dato public.tp_relacion) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
tablarelacion character varying := _nombretabla || '_Relacion';
existe boolean := true;
BEGIN
--EXECUTE FORMAT ('SELECT EXISTS (SELECT codigo FROM %I WHERE codigo = %L)', tablaconceptos, _dato.codigo) INTO existe;
--IF existe = FALSE THEN
	EXECUTE FORMAT ('INSERT INTO %I VALUES($1,$2,$3,$4,$5,$6)',tablarelacion)
	USING
	_dato.id,
	_dato.codpadre,
	_dato.codhijo,
	_dato.canpres,
	COALESCE(_dato.cancert,0),
	_dato.posicion
	;
--END IF;
RETURN existe;
END;
$_$;


ALTER FUNCTION public.insertar_tipo_relacion(_nombretabla character varying, _dato public.tp_relacion) OWNER TO postgres;

--
-- TOC entry 295 (class 1255 OID 27226)
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
-- TOC entry 299 (class 1255 OID 29146)
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
-- TOC entry 247 (class 1255 OID 68664)
-- Name: modificar_codigo(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.modificar_codigo(_nombretabla character varying, _codigoantiguo character varying, _codigonuevo character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
tablaconceptos character varying := _nombretabla||'_Conceptos';
tablarelacion character varying := _nombretabla||'_Relacion';
existe boolean;
BEGIN
EXECUTE FORMAT ('SELECT EXISTS(SELECT codigo FROM %I WHERE codigo = %L)',tablaconceptos, _codigonuevo) INTO existe;
IF existe IS FALSE THEN
    EXECUTE FORMAT ('UPDATE %I SET codigo = %L WHERE codigo = %L',tablaconceptos,_codigonuevo, _codigoantiguo);
    EXECUTE FORMAT ('UPDATE %I SET codpadre = %L WHERE codpadre = %L',tablarelacion,_codigonuevo, _codigoantiguo);
    EXECUTE FORMAT ('UPDATE %I SET codhijo = %L WHERE codhijo = %L',tablarelacion,_codigonuevo, _codigoantiguo);
END IF;
RETURN existe;
END;
$$;


ALTER FUNCTION public.modificar_codigo(_nombretabla character varying, _codigoantiguo character varying, _codigonuevo character varying) OWNER TO postgres;

--
-- TOC entry 249 (class 1255 OID 68665)
-- Name: modificar_naturaleza(character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.modificar_naturaleza(_nombretabla character varying, _cod character varying, _nat integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
tablaconceptos character varying := _nombretabla||'_Conceptos';
BEGIN
EXECUTE FORMAT ('UPDATE %I SET naturaleza = %s WHERE codigo = %L', tablaconceptos, _nat , _cod);
END;  
$$;


ALTER FUNCTION public.modificar_naturaleza(_nombretabla character varying, _cod character varying, _nat integer) OWNER TO postgres;

--
-- TOC entry 300 (class 1255 OID 42060)
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
-- TOC entry 251 (class 1255 OID 68662)
-- Name: modificar_resumen(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.modificar_resumen(_nombretabla character varying, _cod character varying, _res character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
tablaconceptos character varying := _nombretabla||'_Conceptos';
BEGIN
EXECUTE FORMAT ('UPDATE %I SET resumen = %L WHERE codigo = %L', tablaconceptos,_res,_cod);
END;
$$;


ALTER FUNCTION public.modificar_resumen(_nombretabla character varying, _cod character varying, _res character varying) OWNER TO postgres;

--
-- TOC entry 245 (class 1255 OID 68610)
-- Name: modificar_texto(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.modificar_texto(nombretabla character varying, cod character varying, textoplano character varying, textohtml character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN

EXECUTE FORMAT ('UPDATE %I SET descripcion = %s WHERE codigo = %s',nombretabla||'_Conceptos' ,quote_literal(textoplano),quote_literal(cod));
EXECUTE FORMAT ('UPDATE %I SET descripcionhtml = %s WHERE codigo = %s',nombretabla||'_Conceptos' ,quote_literal(textohtml),quote_literal(cod));
END;
$$;


ALTER FUNCTION public.modificar_texto(nombretabla character varying, cod character varying, textoplano character varying, textohtml character varying) OWNER TO postgres;

--
-- TOC entry 250 (class 1255 OID 68661)
-- Name: modificar_unidad(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.modificar_unidad(_nombretabla character varying, _cod character varying, _ud character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN
EXECUTE FORMAT ('UPDATE %I SET ud = %L WHERE codigo = %L',_nombretabla||'_Conceptos' ,_ud,_cod);

END;
$$;


ALTER FUNCTION public.modificar_unidad(_nombretabla character varying, _cod character varying, _ud character varying) OWNER TO postgres;

--
-- TOC entry 248 (class 1255 OID 68652)
-- Name: mostrar_ruta(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mostrar_ruta(tabla character varying, codigo character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
DECLARE
existe boolean;
tablarelacion character varying := tabla || '_Relacion';
codigopadre character varying;
ruta character varying := $2;
BEGIN
EXECUTE FORMAT ('SELECT codpadre FROM %I WHERE codhijo = %L', tablarelacion , codigo) INTO codigopadre;
--SI NO ESTAMOS EN EL NODO RAIZ:
/*IF codigopadre IS NOT NULL THEN
	EXECUTE FORMAT('SELECT mostrar_ruta(%I,%L)',tabla,codigopadre);*/
ruta := ruta || '/' || codigopadre;
--END IF;
RETURN ruta;
END;
$_$;


ALTER FUNCTION public.mostrar_ruta(tabla character varying, codigo character varying) OWNER TO postgres;

--
-- TOC entry 275 (class 1255 OID 112965)
-- Name: pegar(character varying, character varying, smallint, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.pegar(_nombretabla character varying, _codigodestino character varying, OUT nodos_insertados character varying, _pos smallint DEFAULT (- (1)::smallint), _primer_paso boolean DEFAULT true) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$ 
DECLARE
R tp_relacion%ROWTYPE;
C tp_concepto%ROWTYPE;
M tp_medicion%ROWTYPE;
tablacopiar character varying := '__CopiarRelacion';
tablaconceptos character varying :='__CopiarConceptos';
tablacopiarmediciones character varying := '__CopiarMediciones';
codpadre character varying;
resultado integer;
posicion smallint := _pos;
existe boolean;
existe_concepto boolean;
BEGIN
nodos_insertados :='';
IF _primer_paso IS TRUE THEN
	codpadre := ' IS NULL';
	_primer_paso := FALSE;
ELSE
	codpadre := ' = '||quote_literal(_codigodestino);	
END IF;
FOR R IN EXECUTE FORMAT ('SELECT * FROM %I WHERE codpadre %s ORDER BY posicion',tablacopiar,codpadre)
LOOP
	--insertar el concepto (solo lo hara si no existe en la tabla. ademas retornara falso si no existia)
	EXECUTE FORMAT ('SELECT * FROM %I WHERE codigo = %L',tablaconceptos,R.codhijo) INTO C;	
	EXECUTE FORMAT ('SELECT insertar_tipo_concepto($1,$2)') USING _nombretabla, C INTO existe_concepto;	
	--insertar la partida (se insertará la relacion, el concepto se ha hecho anteriormente)
	SELECT insertar_partida(_nombretabla,_codigodestino,R.codhijo,R.canpres,posicion) INTO resultado;
	posicion = posicion +1;
	--Solo si no existia el concepto insertado seguimos adelante con las ediciones e hijos de ese concepto.
	IF resultado = 0 THEN
		FOR M IN EXECUTE FORMAT('SELECT * FROM %I WHERE codpadre %s AND codhijo = %L',tablacopiarmediciones,codpadre,R.codhijo) LOOP
			PERFORM insertar_medicion(_nombretabla,_codigodestino,R.codhijo,M.posicion,M.tipo,M.comentario,M.ud,M.longitud,M.anchura,M.altura,M.formula);
		END LOOP;
	END IF;
	IF existe_concepto IS FALSE THEN	
		nodos_insertados := nodos_insertados || C.codigo||',';
		RAISE NOTICE 'LOS NODOS SON: %' ,C.codigo;
		
		--ver si cada conceptos insertado tiene hijos
		EXECUTE FORMAT ('SELECT EXISTS (SELECT codhijo FROM %I WHERE codpadre = %L)', tablacopiar, R.codhijo) INTO existe;
		IF existe IS TRUE THEN 
			PERFORM pegar(_nombretabla,R.codhijo,'0',_primer_paso);
		END IF;
	END IF;
END LOOP;
nodos_insertados := left(nodos_insertados,-1);
END;
$_$;


ALTER FUNCTION public.pegar(_nombretabla character varying, _codigodestino character varying, OUT nodos_insertados character varying, _pos smallint, _primer_paso boolean) OWNER TO postgres;

--
-- TOC entry 297 (class 1255 OID 29560)
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
-- TOC entry 270 (class 1255 OID 21024)
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
-- TOC entry 274 (class 1255 OID 22185)
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
-- TOC entry 304 (class 1255 OID 59884)
-- Name: recorrer_principal(character varying, character varying, integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.recorrer_principal(nombretabla character varying, codigopadre character varying DEFAULT NULL::character varying, _nivel integer DEFAULT 0, primer_elemento boolean DEFAULT true) RETURNS TABLE(codigo character varying, naturaleza integer, ud character varying, resumen character varying, preciomed numeric, nivel integer)
    LANGUAGE plpgsql
    AS $$ 
DECLARE
tablaconceptos character varying := nombretabla || '_Conceptos';
tablarelacion character varying := nombretabla || '_Relacion';
existe boolean;
nombre_codigo character varying;
codpadre character varying := codigopadre;
c tp_concepto%ROWTYPE;
indice integer;
str_null_case character varying;
BEGIN
IF (codigopadre = '') IS NOT FALSE THEN
	str_null_case := ' IS NULL';	
ELSE
	str_null_case := ' = '||quote_literal(codigopadre);
END IF;
--ELEMENTO RAIZ
IF primer_elemento IS TRUE THEN
	EXECUTE FORMAT ('SELECT codhijo FROM %I WHERE codpadre %s',tablarelacion,str_null_case) INTO nombre_codigo;
	EXECUTE FORMAT ('SELECT * FROM %I WHERE codigo = %s',tablaconceptos, quote_literal(nombre_codigo)) INTO c;
	codigo := c.codigo;
	nivel := _nivel;
	ud := c.ud;
	naturaleza := c.naturaleza;
	resumen := c.resumen;
	preciomed := c.preciomed;
	RETURN NEXT;
	codpadre := c.codigo;--si es el primer nivel cambio codpadre a este en lugar de al parametro de la funcion
END IF;
--EMPIEZO A ITERAR
FOR nombre_codigo in EXECUTE FORMAT ('SELECT codhijo FROM %I WHERE codpadre = %s', tablarelacion, quote_literal(codpadre))
LOOP
 	EXECUTE FORMAT ('SELECT * FROM %I WHERE codigo = %s', tablaconceptos, quote_literal(nombre_codigo)) INTO c;
	codigo := nombre_codigo;
	nivel := _nivel+1;
	ud := c.ud;
	naturaleza := c.naturaleza;
	resumen := c.resumen;
	preciomed := c.preciomed;
	RETURN NEXT;
	EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM %I WHERE codpadre = %s )', tablarelacion , quote_literal(nombre_codigo)) INTO existe;
	--SI QUEDAN MAS HIJOS:	
	IF existe = TRUE THEN
		RETURN QUERY SELECT * FROM recorrer_principal(nombretabla,nombre_codigo,nivel,'false');				
	END IF;	
 END LOOP;
END;
$$;


ALTER FUNCTION public.recorrer_principal(nombretabla character varying, codigopadre character varying, _nivel integer, primer_elemento boolean) OWNER TO postgres;

--
-- TOC entry 277 (class 1255 OID 112040)
-- Name: restaurar_lineas_borradas(character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.restaurar_lineas_borradas(_nombretabla character varying, _tipotabla integer DEFAULT 0) RETURNS void
    LANGUAGE plpgsql
    AS $_$ 
DECLARE
num_paso integer;
tablaconceptos character varying := _nombretabla || '_Conceptos';
tablarelacion character varying := _nombretabla || '_Relacion';
tablamedicion character varying := _nombretabla || '_Mediciones';
tablaguardarconceptos character varying := _nombretabla || '_GuardarConceptos';
tablaguardarrelacion character varying := _nombretabla || '_GuardarRelaciones';
tablaguardarmedicion character varying := _nombretabla || '_GuardarMediciones';
existe boolean;

c tp_concepto%ROWTYPE;
cg tp_guardarconcepto%ROWTYPE;
r tp_relacion%ROWTYPE;
rg tp_guardarrelacion%ROWTYPE;
m tp_medicion%ROWTYPE;
mg tp_guardarmedicion%ROWTYPE;
BEGIN
--PRIMER PASO, HALLAR EL PASO MAS ALTO DE LAS TRES TABLAS
EXECUTE FORMAT('SELECT ultimo_paso(%L,%s)',_nombretabla,_tipotabla) INTO num_paso;
RAISE NOTICE 'ULTIMO PASO: %',num_paso;
--AHORA VOY RESTAURANDO ELEMENTOS DE CADA TABLA. SIEMPRE COMPRUEBO PRIMERO SI EXISTEN.
--TABLA RELACION
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = %s)', quote_literal(tablaguardarrelacion)) INTO existe;
IF existe IS TRUE THEN
    FOR rg IN EXECUTE FORMAT ('SELECT * FROM %I WHERE paso = $1',tablaguardarrelacion) USING num_paso
	LOOP
	    r=rg.r;
	    /*EXECUTE FORMAT ('INSERT INTO %I VALUES(%s,%L,%L,%s,%s,%s)',tablarelacion,
	    r.id, r.codpadre, r.codhijo, r.canpres,r.cancert,r.posicion);*/
	    PERFORM insertar_tipo_relacion(_nombretabla,r);
	END LOOP;
    EXECUTE FORMAT ('DELETE FROM %I WHERE paso = %s',tablaguardarrelacion,num_paso);
END IF;
--TABLA CONCEPTOS
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = %s)', quote_literal(tablaguardarconceptos)) INTO existe;
IF existe IS TRUE THEN
    FOR cg IN EXECUTE FORMAT ('SELECT * FROM %I WHERE paso = $1',tablaguardarconceptos) USING num_paso
	LOOP
	    c=cg.c;	
	    PERFORM insertar_tipo_concepto(_nombretabla,c);
	    PERFORM actualizar_desde_nodo(_nombretabla,c.codigo);
	END LOOP;
    EXECUTE FORMAT ('DELETE FROM %I WHERE paso = %s',tablaguardarconceptos,num_paso);
END IF;
--TABLA MEDICIONES
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = %s)', quote_literal(tablaguardarmedicion)) INTO existe;
IF existe IS TRUE THEN
    FOR mg IN EXECUTE FORMAT ('SELECT * FROM %I WHERE paso = $1',tablaguardarmedicion) USING num_paso
	LOOP
	m=mg.m;
	PERFORM insertar_tipo_medicion(_nombretabla,m);
	END LOOP;
	--PERFORM actualizar_desde_nodo(_nombretabla,m.codpadre);
	PERFORM modificar_cantidad(_nombretabla,m.codpadre,m.codhijo);
    EXECUTE FORMAT ('DELETE FROM %I WHERE paso = %s',tablaguardarmedicion,num_paso);
END IF;
END;
$_$;


ALTER FUNCTION public.restaurar_lineas_borradas(_nombretabla character varying, _tipotabla integer) OWNER TO postgres;

--
-- TOC entry 273 (class 1255 OID 112856)
-- Name: ultimo_paso(character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ultimo_paso(_nombretabla character varying, _tipoaccion integer DEFAULT 0) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
tablaguardarconceptos character varying := _nombretabla || '_GuardarConceptos';
tablaguardarrelacion character varying := _nombretabla || '_GuardarRelaciones';
tablaguardarmedicion character varying := _nombretabla || '_GuardarMediciones';

ultimo_paso_conceptos integer :=0;
ultimo_paso_relacion integer :=0;
ultimo_paso_mediciones integer :=0;
ultimo_paso integer;
existe boolean;
BEGIN
--maximo paso tabla conceptos
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = %s)', quote_literal(tablaguardarconceptos)) INTO existe;
IF existe IS TRUE THEN
	EXECUTE FORMAT ('SELECT MAX(paso) FROM %I WHERE tipoaccion = %s',tablaguardarconceptos,_tipoaccion) INTO ultimo_paso_conceptos;	
END IF;
--maximo paso tabla relacion
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = %s)', quote_literal(tablaguardarrelacion)) INTO existe;
IF existe IS TRUE THEN
	EXECUTE FORMAT ('SELECT MAX(paso) FROM %I WHERE tipoaccion = %s',tablaguardarrelacion,_tipoaccion) INTO ultimo_paso_relacion;	
END IF;
--maximo paso tabla medicion
EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM pg_catalog.pg_tables where tablename = %s)', quote_literal(tablaguardarmedicion)) INTO existe;
IF existe IS TRUE THEN
	EXECUTE FORMAT ('SELECT MAX(paso) FROM %I WHERE tipoaccion = %s',tablaguardarmedicion,_tipoaccion) INTO ultimo_paso_mediciones;	
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


ALTER FUNCTION public.ultimo_paso(_nombretabla character varying, _tipoaccion integer) OWNER TO postgres;

--
-- TOC entry 256 (class 1255 OID 68823)
-- Name: ver_anterior(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ver_anterior(nombretabla character varying, codpadre character varying, codhijo character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
tablarelacion character varying := nombretabla||'_Relacion';
str_null_case character varying;
codigo_anterior character varying;
BEGIN
IF (codpadre = '') IS NOT FALSE THEN
	str_null_case := 'codpadre IS NULL';
ELSE
	str_null_case := 'codpadre = '||quote_literal(codpadre);
END IF;
EXECUTE FORMAT ('SELECT codhijo FROM %I WHERE %s AND posicion = (SELECT posicion FROM %I WHERE %s AND codhijo = %L)- 1',
tablarelacion,str_null_case,tablarelacion,str_null_case,codhijo) INTO codigo_anterior;
IF codigo_anterior = '' IS NOT FALSE THEN codigo_anterior = codhijo; END IF;
RETURN codigo_anterior;
END;
$$;


ALTER FUNCTION public.ver_anterior(nombretabla character varying, codpadre character varying, codhijo character varying) OWNER TO postgres;

--
-- TOC entry 287 (class 1255 OID 43474)
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
        canpres := CASE WHEN (hay_medicion(nombretabla, codigohijo, var_r.codigo)) IS TRUE THEN
			array_length(enum_range(NULL, 'DESCOMPUESTO'::color), 1)
		ELSE 
			array_length(enum_range(NULL, 'NORMAL'::color), 1)
		END;
        cancert := array_length(enum_range(NULL, 'NORMAL'::color), 1);
        portcertpres := array_length(enum_range(NULL, 'DESCOMPUESTO'::color), 1);
        preciomed := CASE WHEN (es_precio_bloqueado(nombretabla, var_r.codigo)) IS TRUE THEN 
			array_length(enum_range(NULL, 'BLOQUEADO'::color), 1)
		     --ELSE 
			WHEN (hay_descomposicion(nombretabla, var_r.codigo)) IS TRUE THEN 
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
-- TOC entry 301 (class 1255 OID 43467)
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
-- TOC entry 284 (class 1255 OID 114520)
-- Name: ver_lineas_medicion(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ver_lineas_medicion(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying) RETURNS TABLE(tipo integer, comentario character varying, ud numeric, longitud numeric, anchura numeric, altura numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
idpadre integer;
idhijo integer;
var_r record;
tablamediciones character varying := _nombretabla || '_Mediciones';
tablaconceptos character varying := _nombretabla || '_Conceptos';
str_null_case character varying;
BEGIN
--construimos la cadena del padre
IF _codigopadre = '' IS NOT FALSE THEN
	str_null_case := quote_ident(tablamediciones)||'.codpadre IS NULL';
ELSE
	str_null_case := quote_ident(tablamediciones)||'.codpadre = '||quote_literal(_codigopadre);
END IF;
--RAISE NOTICE 'lOS DATOS SON: %, %',idpadre,idhijo;

FOR var_r IN EXECUTE 'SELECT ' || 
        quote_ident(tablamediciones) ||'.tipo,'||
	quote_ident(tablamediciones) ||'.comentario,'||
	quote_ident(tablamediciones) ||'.ud,'||
	quote_ident(tablamediciones) ||'.longitud,'||
	quote_ident(tablamediciones) ||'.anchura,'|| 
	quote_ident(tablamediciones) ||'.altura'||
 ' FROM '||quote_ident(tablamediciones)||
 ' WHERE '||quote_ident(tablamediciones)||'.codhijo = '||quote_literal(_codigohijo)||
 ' AND '||str_null_case||
 ' ORDER BY '||quote_ident(tablamediciones)||'.id'
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


ALTER FUNCTION public.ver_lineas_medicion(_nombretabla character varying, _codigopadre character varying, _codigohijo character varying) OWNER TO postgres;

--
-- TOC entry 294 (class 1255 OID 28187)
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
        --RAISE NOTICE 'El parcial es: %',parcial;
        acum = acum+parcial;
        IF var_r.tipo =1 or var_r.tipo =2 THEN subtotal = acum; ELSE subtotal = NULL; END IF;
        id :=var_r.id;
        pos := var_r.posicion;
        RETURN NEXT;
 END LOOP;
 END; $$;


ALTER FUNCTION public.ver_mediciones(nombretabla character varying, codigopadre character varying, codigohijo character varying) OWNER TO postgres;

--
-- TOC entry 257 (class 1255 OID 68822)
-- Name: ver_siguiente(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ver_siguiente(nombretabla character varying, codpadre character varying, codhijo character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
tablarelacion character varying := nombretabla||'_Relacion';
str_null_case character varying;
cod_siguiente character varying;
BEGIN
IF (codpadre = '') IS NOT FALSE THEN
	str_null_case := 'codpadre IS NULL';
ELSE
	str_null_case := 'codpadre = '||quote_literal(codpadre);
END IF;
EXECUTE FORMAT ('SELECT codhijo FROM %I WHERE %s AND posicion = (SELECT posicion FROM %I WHERE %s AND codhijo = %L)+ 1',
tablarelacion,str_null_case,tablarelacion,str_null_case,codhijo) INTO cod_siguiente;
IF cod_siguiente = '' IS NOT FALSE THEN cod_siguiente = codhijo; END IF;
return cod_siguiente;
END;
$$;


ALTER FUNCTION public.ver_siguiente(nombretabla character varying, codpadre character varying, codhijo character varying) OWNER TO postgres;

--
-- TOC entry 290 (class 1255 OID 27225)
-- Name: ver_texto(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ver_texto(nombretabla character varying, cod character varying) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
tablaconceptos character varying := nombretabla||'_Conceptos';
texto_partida text;
BEGIN
EXECUTE FORMAT ('SELECT descripcionhtml FROM %I WHERE codigo = %L',tablaconceptos,cod) INTO texto_partida;
return texto_partida;
END;
$$;


ALTER FUNCTION public.ver_texto(nombretabla character varying, cod character varying) OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 114660)
-- Name: CENZANO_Certificaciones_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."CENZANO_Certificaciones_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."CENZANO_Certificaciones_id_seq" OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 230 (class 1259 OID 114652)
-- Name: CENZANO_Certificaciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."CENZANO_Certificaciones" OF public.tp_certificacion (
    id WITH OPTIONS DEFAULT nextval('public."CENZANO_Certificaciones_id_seq"'::regclass) NOT NULL
);


ALTER TABLE public."CENZANO_Certificaciones" OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 95143)
-- Name: CENZANO_Conceptos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."CENZANO_Conceptos" OF public.tp_concepto (
    codigo WITH OPTIONS NOT NULL
);


ALTER TABLE public."CENZANO_Conceptos" OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 95170)
-- Name: CENZANO_Mediciones_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."CENZANO_Mediciones_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."CENZANO_Mediciones_id_seq" OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 95162)
-- Name: CENZANO_Mediciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."CENZANO_Mediciones" OF public.tp_medicion (
    id WITH OPTIONS DEFAULT nextval('public."CENZANO_Mediciones_id_seq"'::regclass) NOT NULL
);


ALTER TABLE public."CENZANO_Mediciones" OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 95159)
-- Name: CENZANO_Relacion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."CENZANO_Relacion_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."CENZANO_Relacion_id_seq" OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 95151)
-- Name: CENZANO_Relacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."CENZANO_Relacion" OF public.tp_relacion (
    id WITH OPTIONS DEFAULT nextval('public."CENZANO_Relacion_id_seq"'::regclass) NOT NULL
);


ALTER TABLE public."CENZANO_Relacion" OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 113522)
-- Name: PRUEBASCOMP_Conceptos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PRUEBASCOMP_Conceptos" OF public.tp_concepto (
    codigo WITH OPTIONS NOT NULL
);


ALTER TABLE public."PRUEBASCOMP_Conceptos" OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 113549)
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
-- TOC entry 215 (class 1259 OID 113541)
-- Name: PRUEBASCOMP_Mediciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PRUEBASCOMP_Mediciones" OF public.tp_medicion (
    id WITH OPTIONS DEFAULT nextval('public."PRUEBASCOMP_Mediciones_id_seq"'::regclass) NOT NULL
);


ALTER TABLE public."PRUEBASCOMP_Mediciones" OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 113538)
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
-- TOC entry 213 (class 1259 OID 113530)
-- Name: PRUEBASCOMP_Relacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PRUEBASCOMP_Relacion" OF public.tp_relacion (
    id WITH OPTIONS DEFAULT nextval('public."PRUEBASCOMP_Relacion_id_seq"'::regclass) NOT NULL
);


ALTER TABLE public."PRUEBASCOMP_Relacion" OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 114640)
-- Name: PRUEBA_Certificaciones_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."PRUEBA_Certificaciones_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."PRUEBA_Certificaciones_id_seq" OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 114632)
-- Name: PRUEBA_Certificaciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PRUEBA_Certificaciones" OF public.tp_certificacion (
    id WITH OPTIONS DEFAULT nextval('public."PRUEBA_Certificaciones_id_seq"'::regclass) NOT NULL
);


ALTER TABLE public."PRUEBA_Certificaciones" OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 114038)
-- Name: PRUEBA_Conceptos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PRUEBA_Conceptos" OF public.tp_concepto (
    codigo WITH OPTIONS NOT NULL
);


ALTER TABLE public."PRUEBA_Conceptos" OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 114395)
-- Name: PRUEBA_GuardarConceptos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PRUEBA_GuardarConceptos" OF public.tp_guardarconcepto (
    idguardar WITH OPTIONS NOT NULL
);


ALTER TABLE public."PRUEBA_GuardarConceptos" OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 114403)
-- Name: PRUEBA_GuardarMediciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PRUEBA_GuardarMediciones" OF public.tp_guardarmedicion (
    idguardar WITH OPTIONS NOT NULL
);


ALTER TABLE public."PRUEBA_GuardarMediciones" OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 114387)
-- Name: PRUEBA_GuardarRelaciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PRUEBA_GuardarRelaciones" OF public.tp_guardarrelacion (
    idguardar WITH OPTIONS NOT NULL
);


ALTER TABLE public."PRUEBA_GuardarRelaciones" OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 114541)
-- Name: PRUEBA_ListadoCertificaciones_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."PRUEBA_ListadoCertificaciones_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."PRUEBA_ListadoCertificaciones_id_seq" OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 114536)
-- Name: PRUEBA_ListadoCertificaciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PRUEBA_ListadoCertificaciones" (
    num_certificacion integer DEFAULT nextval('public."PRUEBA_ListadoCertificaciones_id_seq"'::regclass) NOT NULL,
    fecha date
);


ALTER TABLE public."PRUEBA_ListadoCertificaciones" OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 114065)
-- Name: PRUEBA_Mediciones_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."PRUEBA_Mediciones_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."PRUEBA_Mediciones_id_seq" OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 114057)
-- Name: PRUEBA_Mediciones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PRUEBA_Mediciones" OF public.tp_medicion (
    id WITH OPTIONS DEFAULT nextval('public."PRUEBA_Mediciones_id_seq"'::regclass) NOT NULL
);


ALTER TABLE public."PRUEBA_Mediciones" OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 114054)
-- Name: PRUEBA_Relacion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."PRUEBA_Relacion_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."PRUEBA_Relacion_id_seq" OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 114046)
-- Name: PRUEBA_Relacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."PRUEBA_Relacion" OF public.tp_relacion (
    id WITH OPTIONS DEFAULT nextval('public."PRUEBA_Relacion_id_seq"'::regclass) NOT NULL
);


ALTER TABLE public."PRUEBA_Relacion" OWNER TO postgres;

--
-- TOC entry 2307 (class 2606 OID 114659)
-- Name: CENZANO_Certificaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CENZANO_Certificaciones"
    ADD CONSTRAINT "CENZANO_Certificaciones_pkey" PRIMARY KEY (id);


--
-- TOC entry 2279 (class 2606 OID 95150)
-- Name: CENZANO_Conceptos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CENZANO_Conceptos"
    ADD CONSTRAINT "CENZANO_Conceptos_pkey" PRIMARY KEY (codigo);


--
-- TOC entry 2283 (class 2606 OID 95169)
-- Name: CENZANO_Mediciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CENZANO_Mediciones"
    ADD CONSTRAINT "CENZANO_Mediciones_pkey" PRIMARY KEY (id);


--
-- TOC entry 2281 (class 2606 OID 95158)
-- Name: CENZANO_Relacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."CENZANO_Relacion"
    ADD CONSTRAINT "CENZANO_Relacion_pkey" PRIMARY KEY (id);


--
-- TOC entry 2285 (class 2606 OID 113529)
-- Name: PRUEBASCOMP_Conceptos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PRUEBASCOMP_Conceptos"
    ADD CONSTRAINT "PRUEBASCOMP_Conceptos_pkey" PRIMARY KEY (codigo);


--
-- TOC entry 2289 (class 2606 OID 113548)
-- Name: PRUEBASCOMP_Mediciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PRUEBASCOMP_Mediciones"
    ADD CONSTRAINT "PRUEBASCOMP_Mediciones_pkey" PRIMARY KEY (id);


--
-- TOC entry 2287 (class 2606 OID 113537)
-- Name: PRUEBASCOMP_Relacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PRUEBASCOMP_Relacion"
    ADD CONSTRAINT "PRUEBASCOMP_Relacion_pkey" PRIMARY KEY (id);


--
-- TOC entry 2305 (class 2606 OID 114639)
-- Name: PRUEBA_Certificaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PRUEBA_Certificaciones"
    ADD CONSTRAINT "PRUEBA_Certificaciones_pkey" PRIMARY KEY (id);


--
-- TOC entry 2291 (class 2606 OID 114045)
-- Name: PRUEBA_Conceptos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PRUEBA_Conceptos"
    ADD CONSTRAINT "PRUEBA_Conceptos_pkey" PRIMARY KEY (codigo);


--
-- TOC entry 2299 (class 2606 OID 114402)
-- Name: PRUEBA_GuardarConceptos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PRUEBA_GuardarConceptos"
    ADD CONSTRAINT "PRUEBA_GuardarConceptos_pkey" PRIMARY KEY (idguardar);


--
-- TOC entry 2301 (class 2606 OID 114410)
-- Name: PRUEBA_GuardarMediciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PRUEBA_GuardarMediciones"
    ADD CONSTRAINT "PRUEBA_GuardarMediciones_pkey" PRIMARY KEY (idguardar);


--
-- TOC entry 2297 (class 2606 OID 114394)
-- Name: PRUEBA_GuardarRelaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PRUEBA_GuardarRelaciones"
    ADD CONSTRAINT "PRUEBA_GuardarRelaciones_pkey" PRIMARY KEY (idguardar);


--
-- TOC entry 2303 (class 2606 OID 114540)
-- Name: PRUEBA_ListadoCertificaciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PRUEBA_ListadoCertificaciones"
    ADD CONSTRAINT "PRUEBA_ListadoCertificaciones_pkey" PRIMARY KEY (num_certificacion);


--
-- TOC entry 2295 (class 2606 OID 114064)
-- Name: PRUEBA_Mediciones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PRUEBA_Mediciones"
    ADD CONSTRAINT "PRUEBA_Mediciones_pkey" PRIMARY KEY (id);


--
-- TOC entry 2293 (class 2606 OID 114053)
-- Name: PRUEBA_Relacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."PRUEBA_Relacion"
    ADD CONSTRAINT "PRUEBA_Relacion_pkey" PRIMARY KEY (id);


--
-- TOC entry 2429 (class 0 OID 0)
-- Dependencies: 6
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2019-02-23 10:55:09 CET

--
-- PostgreSQL database dump complete
--


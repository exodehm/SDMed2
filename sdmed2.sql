PGDMP     '                
    v            SDMed    9.5.14    9.5.14 O    	           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            	           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            	           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            	           1262    17925    SDMed    DATABASE     y   CREATE DATABASE "SDMed" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'es_ES.UTF-8' LC_CTYPE = 'es_ES.UTF-8';
    DROP DATABASE "SDMed";
             postgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false            	           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    6            	           0    0    SCHEMA public    ACL     �   REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;
                  postgres    false    6                        3079    12435    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false            		           0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1            �           1247    29607    concepto    TYPE       CREATE TYPE public.concepto AS (
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
    DROP TYPE public.concepto;
       public       postgres    false    6            �           1247    31544    borrarconcepto    TYPE     _   CREATE TYPE public.borrarconcepto AS (
	idborrar integer,
	paso integer,
	c public.concepto
);
 !   DROP TYPE public.borrarconcepto;
       public       postgres    false    6    660            t           1247    27919    medicion    TYPE     0  CREATE TYPE public.medicion AS (
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
    DROP TYPE public.medicion;
       public       postgres    false    6            �           1247    41003    borrarmedicion    TYPE     _   CREATE TYPE public.borrarmedicion AS (
	idborrar integer,
	paso integer,
	m public.medicion
);
 !   DROP TYPE public.borrarmedicion;
       public       postgres    false    6    628            �           1247    27346    relacion    TYPE     �   CREATE TYPE public.relacion AS (
	id integer,
	codpadre character varying,
	codhijo character varying,
	canpres numeric(7,3),
	cancert numeric(7,3),
	posicion smallint
);
    DROP TYPE public.relacion;
       public       postgres    false    6            �           1247    31547    borrarrelacion    TYPE     _   CREATE TYPE public.borrarrelacion AS (
	idborrar integer,
	paso integer,
	r public.relacion
);
 !   DROP TYPE public.borrarrelacion;
       public       postgres    false    6    648            �           1247    28184    lineamedicion    TYPE     �   CREATE TYPE public.lineamedicion AS (
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
     DROP TYPE public.lineamedicion;
       public       postgres    false    6            q           1247    25498    partida    TYPE       CREATE TYPE public.partida AS (
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
    DROP TYPE public.partida;
       public       postgres    false    6            �            1255    29869 ;   actualizar_desde_nodo(character varying, character varying)    FUNCTION       CREATE FUNCTION public.actualizar_desde_nodo(nombretabla character varying, codigonodo character varying) RETURNS void
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
    texto text;
    borrar numeric;

BEGIN
borrar = (SELECT preciomed FROM "PRUEBASCOMP_Conceptos"  WHERE codigo = 'P02');
RAISE NOTICE 'FUNCION ACTUALIZAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAR DESDE NODO CON %-%-%: ',nombretabla,codigonodo,borrar;


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
    nuevo_precio = bloqueado;RAISE NOTICE 'NUEVO PRECIOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO 1: %',nuevo_precio;
ELSE
    EXECUTE FORMAT ('SELECT EXISTS (SELECT codpadre FROM %I WHERE codpadre %s)',tablarelacion,str_null_case) INTO existe;
    IF existe = FALSE
        THEN
		texto := FORMAT ('SELECT preciomed FROM %I WHERE codigo %s',tablaconceptos,str_null_case);
		raise notice '%',texto;
            EXECUTE FORMAT ('SELECT preciomed FROM %I WHERE codigo %s',tablaconceptos,str_null_case) INTO nuevo_precio;
		RAISE NOTICE 'NUEVO PRECIOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO 2: %',nuevo_precio;
        ELSE
            EXECUTE FORMAT ('SELECT SUM(importe) FROM (SELECT C.codigo, C.resumen, C.preciomed, R.canpres, C.preciomed * R.canpres AS "importe"
		FROM %I AS C,%I AS R 
		WHERE codpadre %s AND R.codhijo = C.codigo) AS subtotal',
		tablaconceptos,tablarelacion, str_null_case) INTO nuevo_precio;
		RAISE NOTICE 'NUEVO PRECIOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO  3: %',nuevo_precio;
    END IF;
END IF;
RAISE NOTICE 'NUEVO PRECIOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO: %',nuevo_precio;
EXECUTE FORMAT ('UPDATE %I SET preciomed = %s WHERE codigo %s', tablaconceptos, quote_literal(nuevo_precio), str_null_case);
RAISE NOTICE 'El valor del nodo es: %', nuevo_precio;
EXECUTE FORMAT ('SELECT EXISTS (SELECT codhijo FROM %I WHERE codhijo %s)', tablarelacion, str_null_case) INTO existe;
IF existe = TRUE THEN
	FOR r IN EXECUTE FORMAT ('SELECT * FROM %I WHERE codhijo %s', tablarelacion, str_null_case)
	LOOP
		RAISE NOTICE 'Hay que seguir para arriba con: %,%',r.codpadre,r.codhijo;
		EXECUTE FORMAT ('SELECT actualizar_desde_nodo(%s,%s)', quote_literal(nombretabla), 
		CASE WHEN r.codpadre IS NULL THEN 'null' ELSE quote_literal(r.codpadre) END);
	END LOOP;
END IF;
END;
$$;
 i   DROP FUNCTION public.actualizar_desde_nodo(nombretabla character varying, codigonodo character varying);
       public       postgres    false    1    6            �            1255    18492    actualizar_parcial()    FUNCTION       CREATE FUNCTION public.actualizar_parcial() RETURNS trigger
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
 +   DROP FUNCTION public.actualizar_parcial();
       public       postgres    false    1    6            �            1255    18986    actualizar_partida()    FUNCTION     �   CREATE FUNCTION public.actualizar_partida() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

DECLARE
BEGIN
RAISE NOTICE 'Actualizar desde nodo: %',OLD.id;
PERFORM (actualizar_desde_nodo(OLD.id));
RETURN NEW;
END;
$$;
 +   DROP FUNCTION public.actualizar_partida();
       public       postgres    false    1    6            �            1255    20163 ;   anadir_obra_a_listado(character varying, character varying)    FUNCTION     B  CREATE FUNCTION public.anadir_obra_a_listado(codigo character varying, resumen character varying) RETURNS integer
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
 a   DROP FUNCTION public.anadir_obra_a_listado(codigo character varying, resumen character varying);
       public       postgres    false    6    1                        1255    32040 V   borrar_descompuesto1(character varying, character varying, character varying, boolean)    FUNCTION     {  CREATE FUNCTION public.borrar_descompuesto1(nombretabla character varying, codigopadre character varying, codigohijo character varying, restaurar boolean DEFAULT false) RETURNS void
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
 �   DROP FUNCTION public.borrar_descompuesto1(nombretabla character varying, codigopadre character varying, codigohijo character varying, restaurar boolean);
       public       postgres    false    6    1                       1255    40923 N   borrar_hijos(character varying, character varying, character varying, boolean)    FUNCTION     '  CREATE FUNCTION public.borrar_hijos(nombretabla character varying, codigopadre character varying, codigohijos character varying DEFAULT NULL::character varying, restaurar boolean DEFAULT false) RETURNS void
    LANGUAGE plpgsql
    AS $$ 
DECLARE
num_paso integer;
tablarelacion character varying := nombretabla || '_Relacion';
tablaborrarconceptos character varying := nombretabla || '_BorrarConceptos';
tablaborrarrelacion character varying := nombretabla || '_BorrarRelacion';
tablaborrarmedicion character varying := nombretabla || '_BorrarMediciones';
arraycodigoshijos character varying[];
r relacion%ROWTYPE;
BEGIN
IF codigohijos IS NULL THEN --SI NO HAY ARRAY DE CODIGOS HIJO BORRO TODOS LOS QUE PENDEN DEL PADRE
	EXECUTE FORMAT('SELECT array_agg(codhijo) from %I WHERE codpadre = %s',
			tablarelacion,quote_literal(codigopadre)) INTO arraycodigoshijos;	
ELSE --SI HAY CADENA DE ARRAY DE CODIGOS, LOS METO EN EL ARRAY DE LA FUNCION
	arraycodigoshijos = string_to_array(codigohijos,',');	
END IF;
--FINALMENTE EJECUTO LA FUNCION
PERFORM borrar_lineas_principal(nombretabla,codigopadre,arraycodigoshijos);
--pongo el numero de paso en la tabla de borrar
EXECUTE FORMAT ('SELECT MAX(paso)+1 FROM %I',tablaborrarrelacion) INTO num_paso;
IF num_paso IS NULL THEN num_paso = 0; END IF;
EXECUTE FORMAT ('UPDATE %I SET paso = %s WHERE paso IS NULL',tablaborrarrelacion,num_paso);
EXECUTE FORMAT ('UPDATE %I SET paso = %s WHERE paso IS NULL',tablaborrarconceptos,num_paso);
EXECUTE FORMAT ('UPDATE %I SET paso = %s WHERE paso IS NULL',tablaborrarmedicion,num_paso);
END;
$$;
 �   DROP FUNCTION public.borrar_hijos(nombretabla character varying, codigopadre character varying, codigohijos character varying, restaurar boolean);
       public       postgres    false    6    1            �            1255    41005 4   borrar_lineas_medicion(character varying, integer[])    FUNCTION     �  CREATE FUNCTION public.borrar_lineas_medicion(nombretabla character varying, ids integer[]) RETURNS void
    LANGUAGE plpgsql
    AS $$ 
DECLARE
    tamanno integer := array_length(ids, 1);
    indice integer := 1;
    tablamediciones character varying := nombretabla || '_Mediciones';
    tablamedicionesborrar character varying := nombretabla || '_BorrarMediciones';
    codigopadre character varying;
    codigohijo character varying;
    m medicion%ROWTYPE;
    --nuevacantidad numeric;    
BEGIN	
    IF tamanno IS NOT NULL THEN	
	EXECUTE FORMAT ('SELECT codpadre FROM %I WHERE id = %s',tablamediciones,ids[indice]) INTO codigopadre;
	EXECUTE FORMAT ('SELECT codhijo FROM %I WHERE id = %s',tablamediciones,ids[indice]) INTO codigohijo;
	EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I OF borrarmedicion (PRIMARY KEY (idborrar))',tablamedicionesborrar);
	
	WHILE indice <= tamanno LOOP
	    EXECUTE FORMAT ('SELECT * FROM %I WHERE %I.id = %s',tablamediciones,tablamediciones,quote_literal(ids[indice])) INTO m;
            --EXECUTE FORMAT ('INSERT INTO %I SELECT * FROM %I WHERE %I.id = %s',tablamedicionesborrar,tablamediciones,tablamediciones,quote_literal(ids[indice])); 
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
            EXECUTE FORMAT ('DELETE FROM %I WHERE %I.id = %s',tablamediciones,tablamediciones,quote_literal(ids[indice]));
            PERFORM modificar_cantidad(nombretabla,codigopadre,codigohijo);
            indice = indice + 1;
       END LOOP;
   END IF;    
   END;
$$;
 [   DROP FUNCTION public.borrar_lineas_medicion(nombretabla character varying, ids integer[]);
       public       postgres    false    6    1                       1255    40799 R   borrar_lineas_principal(character varying, character varying, character varying[])    FUNCTION     8  CREATE FUNCTION public.borrar_lineas_principal(nombretabla character varying, codigopadre character varying, codigoshijo character varying[]) RETURNS void
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
--CREO LA TABLA DE RELACIONES BORRAR
EXECUTE FORMAT ('CREATE TABLE IF NOT EXISTS %I OF borrarrelacion (PRIMARY KEY (idborrar))',tablarelacionborrar);
IF codigoshijo IS NOT NULL THEN
	--ITERO SOBRE EL ARRAY DE CODIGOS HIJO
	FOR I IN array_lower(codigoshijo, 1)..array_upper(codigoshijo, 1) LOOP
		--METO LA RELACION PADRE HIJO EN LA TABLA DE RELACION EN UN REGISTRO
		EXECUTE FORMAT ('SELECT * FROM %I WHERE codpadre = %s AND codhijo = %s',
				tablarelacion,
				quote_literal(codigopadre),
				quote_literal(codigoshijo[I])) 
				INTO r;
		--METO ESE REGISTRO EN LA TABLA DE RELACION BORRAR
		EXECUTE FORMAT ('INSERT INTO %I VALUES(CASE WHEN (SELECT MAX(idborrar) FROM %I) IS NULL THEN 0 ELSE (SELECT MAX(idborrar)+1 FROM %I) END
				,NULL,(%s,%s,%s,%s,%s,%s))',tablarelacionborrar,tablarelacionborrar,tablarelacionborrar,
				r.id,quote_literal(r.codpadre),quote_literal(r.codhijo),r.canpres,COALESCE(r.cancert,0),r.posicion);
		--BORRO LA RELACION PADRE-HIJO EN LA TABLA ORIGINAL
		EXECUTE FORMAT ('DELETE FROM %I WHERE codpadre = %s AND codhijo = %s', tablarelacion,quote_literal(codigopadre),quote_literal(codigoshijo[I]));
		--VEO SI QUEDAN MAS HIJOS EN LA TABLA RELACION
		EXECUTE FORMAT ('SELECT EXISTS (SELECT * FROM %I WHERE codhijo = %s )',	tablarelacion , quote_literal(codigoshijo[I])) INTO existe;
		--SI NO QUEDAN MAS HIJOS:
		IF existe = FALSE THEN
		   --CREO LA TABLA DE CONCEPTOS BORRAR Y METO EL CONCEPTO Y LO BORRO DE LA TABLA DE CONCEPTOS
			
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
			EXECUTE FORMAT ('DELETE FROM %I WHERE codigo = %s', tablaconceptos, quote_literal(codigoshijo[I]));
			--METO LOS HIJOS EN UN ARRAY Y LLAMO DE NUEVO A LA FUNCION
			EXECUTE FORMAT('SELECT array_agg(codhijo) from %I WHERE codpadre = %s',
				tablarelacion,quote_literal(codigoshijo[I])) INTO arraycodigoshijos;			
				PERFORM borrar_lineas_principal(nombretabla, codigoshijo[I], arraycodigoshijos);			
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
 �   DROP FUNCTION public.borrar_lineas_principal(nombretabla character varying, codigopadre character varying, codigoshijo character varying[]);
       public       postgres    false    6    1            �            1255    21783    borrar_obra(character varying)    FUNCTION     J  CREATE FUNCTION public.borrar_obra(nombretabla character varying) RETURNS void
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
 A   DROP FUNCTION public.borrar_obra(nombretabla character varying);
       public       postgres    false    1    6            �            1255    21039 4   borrar_relacion(character varying, integer, integer)    FUNCTION     �  CREATE FUNCTION public.borrar_relacion(nombretabla character varying, idpadre integer, idhijo integer) RETURNS void
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
 f   DROP FUNCTION public.borrar_relacion(nombretabla character varying, idpadre integer, idhijo integer);
       public       postgres    false    6    1            �            1255    26129 0   crear_obra(character varying, character varying)    FUNCTION     �  CREATE FUNCTION public.crear_obra(codigo character varying, resumen character varying) RETURNS integer
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
 V   DROP FUNCTION public.crear_obra(codigo character varying, resumen character varying);
       public       postgres    false    6    1            �            1255    26130 (   crear_tabla_conceptos(character varying)    FUNCTION     �  CREATE FUNCTION public.crear_tabla_conceptos(codigo character varying) RETURNS integer
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
 F   DROP FUNCTION public.crear_tabla_conceptos(codigo character varying);
       public       postgres    false    1    6            �            1255    27302 )   crear_tabla_mediciones(character varying)    FUNCTION     �  CREATE FUNCTION public.crear_tabla_mediciones(codigo character varying) RETURNS integer
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
 G   DROP FUNCTION public.crear_tabla_mediciones(codigo character varying);
       public       postgres    false    1    6            �            1255    27293 '   crear_tabla_relacion(character varying)    FUNCTION     �  CREATE FUNCTION public.crear_tabla_relacion(codigo character varying) RETURNS integer
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
 E   DROP FUNCTION public.crear_tabla_relacion(codigo character varying);
       public       postgres    false    6    1            �            1255    26373 D   es_ancestro(character varying, character varying, character varying)    FUNCTION     L  CREATE FUNCTION public.es_ancestro(nombretabla character varying, codigopadre character varying, codigohijo character varying) RETURNS boolean
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
 ~   DROP FUNCTION public.es_ancestro(nombretabla character varying, codigopadre character varying, codigohijo character varying);
       public       postgres    false    1    6            �            1255    30876 3   existe_codigo(character varying, character varying)    FUNCTION     �  CREATE FUNCTION public.existe_codigo(nombretabla character varying, codigo character varying) RETURNS boolean
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
 ]   DROP FUNCTION public.existe_codigo(nombretabla character varying, codigo character varying);
       public       postgres    false    6    1            �            1255    26370 G   existe_hermano(character varying, character varying, character varying)    FUNCTION       CREATE FUNCTION public.existe_hermano(nombretabla character varying, codigopadre character varying, codigohijo character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
r character varying;

BEGIN
FOR r in EXECUTE FORMAT ('SELECT codhijo FROM %I WHERE codpadre = $1', nombretabla||'_Relacion') USING codigopadre
LOOP
	--RAISE NOTICE 'Estudio el par : %-%',r,idhijo;
	IF r = codigohijo THEN
	--RAISE NOTICE 'Existe la relacion : %-%',idpadre,idhijo;
	RETURN TRUE;
	END IF;
END LOOP;
RETURN FALSE;
END;
$_$;
 �   DROP FUNCTION public.existe_hermano(nombretabla character varying, codigopadre character varying, codigohijo character varying);
       public       postgres    false    1    6            �            1255    29562    exportarbc3(character varying)    FUNCTION     B  CREATE FUNCTION public.exportarbc3(tabla character varying) RETURNS text
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
 ;   DROP FUNCTION public.exportarbc3(tabla character varying);
       public       postgres    false    6    1            �            1255    29561    fecha_a_bc3(date)    FUNCTION     �  CREATE FUNCTION public.fecha_a_bc3(fecha date) RETURNS character varying
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
 .   DROP FUNCTION public.fecha_a_bc3(fecha date);
       public       postgres    false    6    1            �            1255    24015 8   hay_descomposicion(character varying, character varying)    FUNCTION     �  CREATE FUNCTION public.hay_descomposicion(nombretabla character varying, codigo character varying) RETURNS boolean
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
 b   DROP FUNCTION public.hay_descomposicion(nombretabla character varying, codigo character varying);
       public       postgres    false    6    1            �            1255    29144 E   hay_medicion(character varying, character varying, character varying)    FUNCTION     �  CREATE FUNCTION public.hay_medicion(nombretabla character varying, codigopadre character varying, codigohijo character varying) RETURNS boolean
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
    DROP FUNCTION public.hay_medicion(nombretabla character varying, codigopadre character varying, codigohijo character varying);
       public       postgres    false    6    1            �            1255    21364 �   insertar_concepto(character varying, character varying, character varying, character varying, numeric, integer, character varying)    FUNCTION     �  CREATE FUNCTION public.insertar_concepto(nombretabla character varying, codigopadre character varying, u character varying DEFAULT ''::character varying, resumen character varying DEFAULT ''::character varying, precio numeric DEFAULT 0, nat integer DEFAULT 7, fec character varying DEFAULT ''::character varying) RETURNS void
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
 �   DROP FUNCTION public.insertar_concepto(nombretabla character varying, codigopadre character varying, u character varying, resumen character varying, precio numeric, nat integer, fec character varying);
       public       postgres    false    6    1            �            1255    29208 �   insertar_medicion(character varying, character varying, character varying, smallint, integer, character varying, numeric, numeric, numeric, numeric, character varying, integer)    FUNCTION     v  CREATE FUNCTION public.insertar_medicion(nombretabla character varying, codigopadre character varying, codigohijo character varying, posicion smallint DEFAULT (- (1)::smallint), tipo integer DEFAULT 0, comentario character varying DEFAULT NULL::character varying, ud numeric DEFAULT (0)::numeric, longitud numeric DEFAULT (0)::numeric, anchura numeric DEFAULT (0)::numeric, altura numeric DEFAULT (0)::numeric, formula character varying DEFAULT NULL::character varying, idfila integer DEFAULT NULL::integer) RETURNS integer
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
 -  DROP FUNCTION public.insertar_medicion(nombretabla character varying, codigopadre character varying, codigohijo character varying, posicion smallint, tipo integer, comentario character varying, ud numeric, longitud numeric, anchura numeric, altura numeric, formula character varying, idfila integer);
       public       postgres    false    1    6            �            1255    25944 �   insertar_partida(character varying, character varying, character varying, smallint, character varying, character varying, text, numeric, numeric, integer, character varying)    FUNCTION     _
  CREATE FUNCTION public.insertar_partida(nombretabla character varying, codigopadre character varying, codigohijo character varying, pos smallint DEFAULT (- (1)::smallint), u character varying DEFAULT ''::character varying, res character varying DEFAULT ''::character varying, texto text DEFAULT ''::text, precio numeric DEFAULT 0, cantidad numeric DEFAULT 1, nat integer DEFAULT 7, fec character varying DEFAULT ''::character varying) RETURNS integer
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
	--RAISE NOTICE 'LLEGO HASTA LO DE LOS HERMANOS';
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
   DROP FUNCTION public.insertar_partida(nombretabla character varying, codigopadre character varying, codigohijo character varying, pos smallint, u character varying, res character varying, texto text, precio numeric, cantidad numeric, nat integer, fec character varying);
       public       postgres    false    6    1            �            1255    26466 ]   insertar_relacion(character varying, character varying, character varying, numeric, smallint)    FUNCTION     l  CREATE FUNCTION public.insertar_relacion(nombretabla character varying, codigopadre character varying, codigohijo character varying, cantidad numeric, pos smallint) RETURNS void
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
 �   DROP FUNCTION public.insertar_relacion(nombretabla character varying, codigopadre character varying, codigohijo character varying, cantidad numeric, pos smallint);
       public       postgres    false    6    1            �            1255    22230 :   insertar_texto(character varying, character varying, text)    FUNCTION       CREATE FUNCTION public.insertar_texto(tabla character varying, cod character varying, texto text) RETURNS void
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
 a   DROP FUNCTION public.insertar_texto(tabla character varying, cod character varying, texto text);
       public       postgres    false    1    6            �            1255    27226 v   modificar_campo_medicion(character varying, character varying, character varying, character varying, integer, integer)    FUNCTION     e  CREATE FUNCTION public.modificar_campo_medicion(nombretabla character varying, codigopadre character varying, codigohijo character varying, valor character varying, idfila integer, columna integer) RETURNS void
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
 �   DROP FUNCTION public.modificar_campo_medicion(nombretabla character varying, codigopadre character varying, codigohijo character varying, valor character varying, idfila integer, columna integer);
       public       postgres    false    1    6            �            1255    29146 T   modificar_cantidad(character varying, character varying, character varying, numeric)    FUNCTION     �  CREATE FUNCTION public.modificar_cantidad(nombretabla character varying, codigopadre character varying, codigohijo character varying, cantidad numeric DEFAULT NULL::numeric) RETURNS void
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
 �   DROP FUNCTION public.modificar_cantidad(nombretabla character varying, codigopadre character varying, codigohijo character varying, cantidad numeric);
       public       postgres    false    1    6            �            1255    25236 I   modificar_codigo(character varying, character varying, character varying)    FUNCTION     �  CREATE FUNCTION public.modificar_codigo(nombretabla character varying, codigoantiguo character varying, codigonuevo character varying) RETURNS boolean
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
 �   DROP FUNCTION public.modificar_codigo(nombretabla character varying, codigoantiguo character varying, codigonuevo character varying);
       public       postgres    false    1    6            �            1255    23081 C   modificar_naturaleza(character varying, character varying, integer)    FUNCTION     ,  CREATE FUNCTION public.modificar_naturaleza(nombretabla character varying, cod character varying, nat integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN

EXECUTE FORMAT ('UPDATE %I SET naturaleza = %s WHERE codigo = %s',nombretabla||'_Conceptos' ,nat , quote_literal(cod));
END;
$$;
 n   DROP FUNCTION public.modificar_naturaleza(nombretabla character varying, cod character varying, nat integer);
       public       postgres    false    6    1            �            1255    32620 d   modificar_precio(character varying, character varying, character varying, numeric, integer, boolean)    FUNCTION     �  CREATE FUNCTION public.modificar_precio(nombretabla character varying, codpadre character varying, codhijo character varying, precio numeric, opcion integer, restaurar boolean DEFAULT false) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
tablaborrarconceptos character varying;
tablaborrarrelacion character varying;
BEGIN
tablaborrarconceptos = nombretabla || '_BorrarConceptos';
tablaborrarrelacion = nombretabla || '_BorrarRelacion';
IF opcion = 2 THEN--bloquear el precio
	IF restaurar = FALSE THEN 
	    EXECUTE FORMAT ('UPDATE %I SET preciobloq = %s WHERE codigo=%s',tabla||'_Conceptos',quote_literal(precio),quote_literal(codhijo));
	ELSE
	    EXECUTE FORMAT ('UPDATE %I SET preciobloq = NULL WHERE codigo=%s',tabla||'_Conceptos',quote_literal(codhijo));
	END IF;
ELSE
	RAISE NOTICE 'MODIFICAR EL PRECIO E YA';
	--IF hay_descomposicion(tabla,codhijo) THEN
	    --RAISE NOTICE 'Borrar hijos yaaaaa';
	    PERFORM borrar_hijos(nombretabla,codhijo);
	--END IF;
	--por ultimo actualizo el campo precio	
	EXECUTE FORMAT ('UPDATE %I SET preciomed = %s WHERE codigo=%s',nombretabla||'_Conceptos',quote_literal(precio),quote_literal(codhijo));	
END IF;
PERFORM actualizar_desde_nodo(nombretabla,codhijo);
END;
$$;
 �   DROP FUNCTION public.modificar_precio(nombretabla character varying, codpadre character varying, codhijo character varying, precio numeric, opcion integer, restaurar boolean);
       public       postgres    false    6    1            �            1255    21028 J   modificar_resumen(character varying, character varying, character varying)    FUNCTION     =  CREATE FUNCTION public.modificar_resumen(nombretabla character varying, cod character varying, res character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN

EXECUTE FORMAT ('UPDATE %I SET resumen = %s WHERE codigo = %s',nombretabla||'_Conceptos' ,quote_literal(res),quote_literal(cod));
END;
$$;
 u   DROP FUNCTION public.modificar_resumen(nombretabla character varying, cod character varying, res character varying);
       public       postgres    false    6    1            �            1255    23517 I   modificar_unidad(character varying, character varying, character varying)    FUNCTION     4  CREATE FUNCTION public.modificar_unidad(nombretabla character varying, cod character varying, ud character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE

BEGIN
EXECUTE FORMAT ('UPDATE %I SET ud = %s WHERE codigo = %s',nombretabla||'_Conceptos' ,quote_literal(ud),quote_literal(cod));
END;
$$;
 s   DROP FUNCTION public.modificar_unidad(nombretabla character varying, cod character varying, ud character varying);
       public       postgres    false    1    6            �            1255    29560 7   poner_almohadilla(character varying, character varying)    FUNCTION     �  CREATE FUNCTION public.poner_almohadilla(tabla character varying, codigo character varying) RETURNS character varying
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
 [   DROP FUNCTION public.poner_almohadilla(tabla character varying, codigo character varying);
       public       postgres    false    1    6            �            1255    21024 (   procesar_cadena_fecha(character varying)    FUNCTION     F  CREATE FUNCTION public.procesar_cadena_fecha(cadenafecha character varying DEFAULT ''::character varying) RETURNS date
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
 K   DROP FUNCTION public.procesar_cadena_fecha(cadenafecha character varying);
       public       postgres    false    6    1            �            1255    22185 N   procesar_linea_medicion(numeric, numeric, numeric, numeric, character varying)    FUNCTION     �  CREATE FUNCTION public.procesar_linea_medicion(unidad numeric, longitud numeric, anchura numeric, altura numeric, formula character varying) RETURNS numeric
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
 �   DROP FUNCTION public.procesar_linea_medicion(unidad numeric, longitud numeric, anchura numeric, altura numeric, formula character varying);
       public       postgres    false    1    6            �            1255    26745 B   ver_hijos(character varying, character varying, character varying)    FUNCTION     A
  CREATE FUNCTION public.ver_hijos(nombretabla character varying, codigopadre character varying, codigohijo character varying) RETURNS TABLE(codigo character varying, naturaleza integer, ud character varying, resumen character varying, canpres numeric, cancert numeric, portcertpres numeric, preciomed numeric, preciocert numeric, imppres numeric, impcert numeric)
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
	'R.cancert / R.canpres AS portcertpres,'||
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
	'R.cancert/R.canpres AS portcertpres,'||
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
 |   DROP FUNCTION public.ver_hijos(nombretabla character varying, codigopadre character varying, codigohijo character varying);
       public       postgres    false    6    1            �            1255    26841 L   ver_lineas_medicion(character varying, character varying, character varying)    FUNCTION     �  CREATE FUNCTION public.ver_lineas_medicion(nombretabla character varying, codigopadre character varying, codigohijo character varying) RETURNS TABLE(tipo integer, comentario character varying, ud numeric, longitud numeric, anchura numeric, altura numeric)
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
 �   DROP FUNCTION public.ver_lineas_medicion(nombretabla character varying, codigopadre character varying, codigohijo character varying);
       public       postgres    false    1    6            �            1255    28187 G   ver_mediciones(character varying, character varying, character varying)    FUNCTION     p  CREATE FUNCTION public.ver_mediciones(nombretabla character varying, codigopadre character varying, codigohijo character varying) RETURNS TABLE(fase integer, comentario character varying, ud numeric, longitud numeric, anchura numeric, altura numeric, formula character varying, parcial numeric, subtotal numeric, id integer, pos integer)
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
 �   DROP FUNCTION public.ver_mediciones(nombretabla character varying, codigopadre character varying, codigohijo character varying);
       public       postgres    false    1    6            �            1255    27225 /   ver_texto(character varying, character varying)    FUNCTION        CREATE FUNCTION public.ver_texto(nombretabla character varying, cod character varying) RETURNS text
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
 V   DROP FUNCTION public.ver_texto(nombretabla character varying, cod character varying);
       public       postgres    false    1    6            �            1259    41372    PRUEBASCOMP_BorrarConceptos    TABLE     s   CREATE TABLE public."PRUEBASCOMP_BorrarConceptos" OF public.borrarconcepto (
    idborrar WITH OPTIONS NOT NULL
);
 1   DROP TABLE public."PRUEBASCOMP_BorrarConceptos";
       public         postgres    false    660    6    654            �            1259    41364    PRUEBASCOMP_BorrarMediciones    TABLE     t   CREATE TABLE public."PRUEBASCOMP_BorrarMediciones" OF public.borrarmedicion (
    idborrar WITH OPTIONS NOT NULL
);
 2   DROP TABLE public."PRUEBASCOMP_BorrarMediciones";
       public         postgres    false    645    6    628            �            1259    41356    PRUEBASCOMP_BorrarRelacion    TABLE     r   CREATE TABLE public."PRUEBASCOMP_BorrarRelacion" OF public.borrarrelacion (
    idborrar WITH OPTIONS NOT NULL
);
 0   DROP TABLE public."PRUEBASCOMP_BorrarRelacion";
       public         postgres    false    657    648    6            �            1259    41165    PRUEBASCOMP_Conceptos    TABLE     e   CREATE TABLE public."PRUEBASCOMP_Conceptos" OF public.concepto (
    codigo WITH OPTIONS NOT NULL
);
 +   DROP TABLE public."PRUEBASCOMP_Conceptos";
       public         postgres    false    660    6            �            1259    41192    PRUEBASCOMP_Mediciones_id_seq    SEQUENCE     �   CREATE SEQUENCE public."PRUEBASCOMP_Mediciones_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public."PRUEBASCOMP_Mediciones_id_seq";
       public       postgres    false    6            �            1259    41184    PRUEBASCOMP_Mediciones    TABLE     �   CREATE TABLE public."PRUEBASCOMP_Mediciones" OF public.medicion (
    id WITH OPTIONS DEFAULT nextval('public."PRUEBASCOMP_Mediciones_id_seq"'::regclass) NOT NULL
);
 ,   DROP TABLE public."PRUEBASCOMP_Mediciones";
       public         postgres    false    203    6    628            �            1259    41181    PRUEBASCOMP_Relacion_id_seq    SEQUENCE     �   CREATE SEQUENCE public."PRUEBASCOMP_Relacion_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public."PRUEBASCOMP_Relacion_id_seq";
       public       postgres    false    6            �            1259    41173    PRUEBASCOMP_Relacion    TABLE     �   CREATE TABLE public."PRUEBASCOMP_Relacion" OF public.relacion (
    id WITH OPTIONS DEFAULT nextval('public."PRUEBASCOMP_Relacion_id_seq"'::regclass) NOT NULL
);
 *   DROP TABLE public."PRUEBASCOMP_Relacion";
       public         postgres    false    201    6    648             	          0    41372    PRUEBASCOMP_BorrarConceptos 
   TABLE DATA               J   COPY public."PRUEBASCOMP_BorrarConceptos" (idborrar, paso, c) FROM stdin;
    public       postgres    false    206   �!      �          0    41364    PRUEBASCOMP_BorrarMediciones 
   TABLE DATA               K   COPY public."PRUEBASCOMP_BorrarMediciones" (idborrar, paso, m) FROM stdin;
    public       postgres    false    205   �"      �          0    41356    PRUEBASCOMP_BorrarRelacion 
   TABLE DATA               I   COPY public."PRUEBASCOMP_BorrarRelacion" (idborrar, paso, r) FROM stdin;
    public       postgres    false    204   <#      �          0    41165    PRUEBASCOMP_Conceptos 
   TABLE DATA               �   COPY public."PRUEBASCOMP_Conceptos" (codigo, resumen, descripcion, descripcionhtml, preciomed, preciobloq, naturaleza, fecha, ud, preciocert) FROM stdin;
    public       postgres    false    199   �#      �          0    41184    PRUEBASCOMP_Mediciones 
   TABLE DATA               �   COPY public."PRUEBASCOMP_Mediciones" (id, fase, tipo, comentario, ud, longitud, anchura, altura, formula, codpadre, codhijo, posicion) FROM stdin;
    public       postgres    false    202   I$      
	           0    0    PRUEBASCOMP_Mediciones_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public."PRUEBASCOMP_Mediciones_id_seq"', 6, true);
            public       postgres    false    203            �          0    41173    PRUEBASCOMP_Relacion 
   TABLE DATA               c   COPY public."PRUEBASCOMP_Relacion" (id, codpadre, codhijo, canpres, cancert, posicion) FROM stdin;
    public       postgres    false    200   f$      	           0    0    PRUEBASCOMP_Relacion_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public."PRUEBASCOMP_Relacion_id_seq"', 12, true);
            public       postgres    false    201            �           2606    41379     PRUEBASCOMP_BorrarConceptos_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."PRUEBASCOMP_BorrarConceptos"
    ADD CONSTRAINT "PRUEBASCOMP_BorrarConceptos_pkey" PRIMARY KEY (idborrar);
 j   ALTER TABLE ONLY public."PRUEBASCOMP_BorrarConceptos" DROP CONSTRAINT "PRUEBASCOMP_BorrarConceptos_pkey";
       public         postgres    false    206    206            �           2606    41371 !   PRUEBASCOMP_BorrarMediciones_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."PRUEBASCOMP_BorrarMediciones"
    ADD CONSTRAINT "PRUEBASCOMP_BorrarMediciones_pkey" PRIMARY KEY (idborrar);
 l   ALTER TABLE ONLY public."PRUEBASCOMP_BorrarMediciones" DROP CONSTRAINT "PRUEBASCOMP_BorrarMediciones_pkey";
       public         postgres    false    205    205            �           2606    41363    PRUEBASCOMP_BorrarRelacion_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."PRUEBASCOMP_BorrarRelacion"
    ADD CONSTRAINT "PRUEBASCOMP_BorrarRelacion_pkey" PRIMARY KEY (idborrar);
 h   ALTER TABLE ONLY public."PRUEBASCOMP_BorrarRelacion" DROP CONSTRAINT "PRUEBASCOMP_BorrarRelacion_pkey";
       public         postgres    false    204    204            |           2606    41172    PRUEBASCOMP_Conceptos_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public."PRUEBASCOMP_Conceptos"
    ADD CONSTRAINT "PRUEBASCOMP_Conceptos_pkey" PRIMARY KEY (codigo);
 ^   ALTER TABLE ONLY public."PRUEBASCOMP_Conceptos" DROP CONSTRAINT "PRUEBASCOMP_Conceptos_pkey";
       public         postgres    false    199    199            �           2606    41191    PRUEBASCOMP_Mediciones_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public."PRUEBASCOMP_Mediciones"
    ADD CONSTRAINT "PRUEBASCOMP_Mediciones_pkey" PRIMARY KEY (id);
 `   ALTER TABLE ONLY public."PRUEBASCOMP_Mediciones" DROP CONSTRAINT "PRUEBASCOMP_Mediciones_pkey";
       public         postgres    false    202    202            ~           2606    41180    PRUEBASCOMP_Relacion_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public."PRUEBASCOMP_Relacion"
    ADD CONSTRAINT "PRUEBASCOMP_Relacion_pkey" PRIMARY KEY (id);
 \   ALTER TABLE ONLY public."PRUEBASCOMP_Relacion" DROP CONSTRAINT "PRUEBASCOMP_Relacion_pkey";
       public         postgres    false    200    200             	   �   x�m�1�0��9�%��k���ڎE�JqtQ���I��j�L���KP�Z��`�n��6]�L:��`��T��p�RSj��]Ȟ���Q�OEd1V<��}�YQ�h�H�z���;�ȥ(Z,ִ�ֱr�G�M�l�?�vU-�%�e�R*/��}X���~pJ�      �   �   x�m��
�0���)B��rwi����>�K������K�Pqɒ��G��! 8�9 ����{<L�,LH��&�9���Z���e��;/��`1X�j\��-]�s�k�p��>�[Ɖ��{�]���S�{���cX�cˈ�uW�T'/�P;��F9�\:��l'=(      �   �   x�U�1� ��NQeJ$�������ν�9ST`	�?�?�ح��z�*f���<��@�RH�͋��^��u��h wI������kH��}�HFR=��Α��ށ�#�"�4�$9�E�9��P���'x��>�      �   ]   x�svP0�tv�	��2c�@�H��� �0�420��54�5��
p�*!4A5����������	Ul���P��"����� >��      �      x������ � �      �   =   x�3����
uurv���4�300��\��(�Ύ
�PI�>����Bސ+F��� =��     
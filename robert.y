
%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
extern FILE* yyin;
extern char* yytext;
int yylineno;

struct var 
{
	int value;
        float floatvalue;
	char name[256];
	char type[256];
	char message[256];
	bool existent_value;
	bool constant;
	bool global;
};

struct functions 
{
	char name[256];
	char arg[256];
	char type[256];
	bool metoda;
};

struct expresii 
{
 char tip[256];
 int nr_id;
 bool id_notint;
};

struct var variabile[200]; 
struct functions funct[200];
struct expresii expresiones[200];
int constants[200];
int contor_var=0;
int contor_fun=0;
int contor_expr=0;
char eroare[256];

void declaratie1(char* tip, char* nume, bool constant, bool global)
{	
	printf("Am intrat in functia declaratie1\n");
	bool ok = true;
	for (int i = 0; i < contor_var; i++)
	{
		if (!strcmp(variabile[i].name, nume))
			ok = false;
	}
	if (ok == true)
	{
		strcpy(variabile[contor_var].name, nume);
		strcpy(variabile[contor_var].type, tip);
                variabile[contor_var].constant=constant;
                variabile[contor_var].global=global;
		contor_var++;
	}
	else
		
        {  
                sprintf(eroare,"Variabila %s a mai fost declarata", nume);
                yyerror(eroare);
                exit(0);
        }
 	

}

void declaratie2_tip(char* tip, char* nume1, char *nume2, bool constant, bool global)
{
  bool ok = false;
  int poz=0;
	for (int i = 0; i < contor_var; i++)
	{
		if(!strcmp(variabile[i].name, nume2))
			{
                         ok = true;
			 poz=i;
		        }
	}
    printf("Pozitia lui %s este %d", nume2, poz);
     if(variabile[poz].constant!=constant)
     { 
       sprintf(eroare, "Nu se poate asigna o constanta unei neconstante si invers\n");
       yyerror(eroare);
       exit(0);
     }
	if (ok == false)
     {
       sprintf(eroare, "Variabila %s nu a fost declarata", nume2);
       yyerror(eroare);
       exit(0);
     }
        if(strcmp(tip, variabile[poz].type))
   {
        sprintf(eroare, "Variabila %s nu este de acelasi tip cu variabila %s", nume2, nume1);
	yyerror(eroare);
        exit(0);
   }
      if (variabile[poz].existent_value==0)
    {
      sprintf(eroare, "Variabila %s nu a fost initializata", nume2);
      yyerror(eroare);
      exit(0);
    }
      strcpy(variabile[contor_var].name, nume1);
      strcpy(variabile[contor_var].type, tip);
		
     if((!strcmp(variabile[contor_var].type, "_rstring"))||(!strcmp(variabile[contor_var].type, "_rchar")))
    {
      strcpy(variabile[contor_var].message, variabile[poz].message);
    }
     if((!strcmp(variabile[contor_var].type, "_rint"))||(!strcmp(variabile[contor_var].type, "_rbool")))
    {
      variabile[contor_var].value=variabile[poz].value;
    }
     if(!strcmp(variabile[contor_var].type, "_rfloat"))
    {
      variabile[contor_var].floatvalue=variabile[poz].floatvalue;
    }
      variabile[contor_var].constant=constant;
      variabile[contor_var].existent_value=1;
      variabile[contor_var].global=global;
      contor_var++;

}

void declaratie2(char* nume1, char *nume2)
{
  bool ok = false;
  int poz1=0;
	for (int i = 0; i < contor_var; i++)
	{
		if(!strcmp(variabile[i].name, nume1))
			{
                         ok = true;
			 poz1=i;
		        }
	}
    if(ok == false)
    {
      sprintf(eroare,"Variabila %s nu a fost declarata", nume1);
      yyerror(eroare);
      exit(0);
    }
    ok = false;
    int poz2=0;
	for (int i = 0; i < contor_var; i++)
	{
		if(!strcmp(variabile[i].name, nume2))
			{
                         ok = true;
			 poz2=i;
		        }
	}
     if(ok == false)
    {
      sprintf(eroare,"Variabila %s nu a fost declarata", nume2);
      yyerror(eroare);
      exit(0);
    }
     if(strcmp(variabile[poz1].type, variabile[poz2].type))
   {
        sprintf(eroare, "Variabila %s nu este de acelasi tip cu variabila %s", nume2, nume1);
	yyerror(eroare);
        exit(0);
   }

     if(variabile[poz1].constant||variabile[poz2].constant)
     { 
       sprintf(eroare, "Nu se poate folosi o constanta in asignare\n");
       yyerror(eroare);
       exit(0);     
     }

      if (variabile[poz2].existent_value==0)
    {
      sprintf(eroare, "Variabila %s nu a fost initializata", nume2);
      yyerror(eroare);
      exit(0);
    }
    	
     if((!strcmp(variabile[poz1].type, "_rstring"))||(!strcmp(variabile[poz1].type, "_rchar")))
    {
      strcpy(variabile[poz1].message, variabile[poz2].message);
    }
    if((!strcmp(variabile[poz1].type, "_rint"))||(!strcmp(variabile[poz1].type, "_rbool")))
     {
        variabile[poz1].value=variabile[poz2].value;
     }
	variabile[poz1].constant=1;
        variabile[poz1].existent_value=1;
        variabile[poz1].global=variabile[poz2].global;
      
}

void declaratie2_string(char* tip, char* nume, char* mesaj, bool constant, bool global )
{
       if(strcmp(tip, "_rstring"))
     {  
       sprintf(eroare, "Variabila %s trebuie sa fie de tip _rstring", nume);
       yyerror(eroare);
       exit(0);
     }
	bool ok = true;
	for (int i = 0; i < contor_var; i++)
	{
		if(!strcmp(variabile[i].name, nume))
			ok = false;
	}
	if (ok == true)
	{
		strcpy(variabile[contor_var].name, nume);
		strcpy(variabile[contor_var].type, tip);
		strcpy(variabile[contor_var].message, mesaj);
		variabile[contor_var].constant=constant;
	        variabile[contor_var].existent_value=1;
		variabile[contor_var].global=global;
                contor_var++;
	}
	else
		{
                  sprintf(eroare,"Variabila %s a mai fost declarata", nume);
                  yyerror(eroare);
		  exit(0);
                }

}

void declaratie2_char(char* tip, char* nume, char* simbol, bool constant, bool global)
{
	printf("Am intrat in declaratie2_char\n");
       if(strcmp(tip, "_rchar"))
     {  
       sprintf(eroare, "Variabila %s trebuie sa fie de tip _rchar", nume);
       yyerror(eroare);
       exit(0);
     }
        bool ok = true;
	for (int i = 0; i < contor_var; i++)
	{
		if (!strcmp(variabile[i].name, nume))
			ok = false;
	}
	if (ok == true)
	{
		strcpy(variabile[contor_var].name, nume);
		strcpy(variabile[contor_var].type, tip);
		strcpy(variabile[contor_var].message, simbol);
		variabile[contor_var].constant=constant;
		variabile[contor_var].existent_value=1;
		variabile[contor_var].global=global;
                contor_var++;
		
	}
	else
		{
                  sprintf(eroare,"Variabila %s a mai fost declarata", nume);
                  yyerror(eroare);
		  exit(0);
                }    
}

void declaratie2_int(char* tip, char* nume, int valoare, bool constant, bool global)
{
	printf("Am intrat in declaratie2_int\n");
      if(strcmp(tip, "_rint"))
     {  
       sprintf(eroare, "Variabila %s trebuie sa fie de tip _rint", nume);
       yyerror(eroare); 
       exit(0);
     }	
	bool ok = true;
	for (int i = 0; i < contor_var; i++)
	{
		if (!strcmp(variabile[i].name, nume))
			ok = false;
	}
	if (ok == true)
	{
		strcpy(variabile[contor_var].name, nume);
		strcpy(variabile[contor_var].type, tip);
		variabile[contor_var].value = valoare;
		variabile[contor_var].constant=constant;
		variabile[contor_var].existent_value=1;
		variabile[contor_var].global=global;
                contor_var++;
		
	}
	else
	    {	
                sprintf(eroare,"Variabila %s a mai fost declarata", nume);
	        yyerror(eroare);
		exit(0);
            }
}

void declaratie2_float(char* tip, char* nume, float valoare, bool constant, bool global)
{
	printf("Am intrat in declaratie2_float\n");
      if(strcmp(tip, "_rfloat"))
     {  
       sprintf(eroare, "Variabila %s trebuie sa fie de tip _float", nume);
       yyerror(eroare); 
       exit(0);
     }	
	bool ok = true;
	for (int i = 0; i < contor_var; i++)
	{
		if (!strcmp(variabile[i].name, nume))
			ok = false;
	}
	if (ok == true)
	{
		strcpy(variabile[contor_var].name, nume);
		strcpy(variabile[contor_var].type, tip);
		variabile[contor_var].floatvalue = valoare;
		variabile[contor_var].constant=constant;
		variabile[contor_var].existent_value=1;
		variabile[contor_var].global=global;
                contor_var++;
		
	}
	else
	    {	
                sprintf(eroare,"Variabila %s a mai fost declarata", nume);
	        yyerror(eroare);
		exit(0);
            }
}


void declaratie2_bool(char* tip, char* nume, int valoare, bool constant, bool global)
{
	printf("Am intrat in declaratie2_bool\n");
      if(strcmp(tip, "_rbool"))
     {  
       sprintf(eroare, "Variabila %s trebuie sa fie de tip _rbool", nume);
       yyerror(eroare);
       exit(0);
     }	
	bool ok = true;
	for (int i = 0; i < contor_var; i++)
	{
		if (!strcmp(variabile[i].name, nume))
			ok = false;
	}
	if (ok == true)
	{
		strcpy(variabile[contor_var].name, nume);
		strcpy(variabile[contor_var].type, tip);
		variabile[contor_var].value = valoare;
		variabile[contor_var].constant=constant;
		variabile[contor_var].existent_value=1;
		variabile[contor_var].global=global;
		contor_var++;
	}
	else
	    {	
                sprintf(eroare,"Variabila %s a mai fost declarata", nume);
	        yyerror(eroare);
                exit(0);
            }
}
void assign_int(char* nume, int val)
{
	int poz = -1;
	for (int i = 0; i < contor_var; i++)
		if (!strcmp(variabile[i].name, nume))
			poz=i;
          if(poz==-1)
	{
         sprintf(eroare, "Variabila %s nu a fost declarata",nume);
	 yyerror(eroare);
         exit(0);
	}
         if(strcmp(variabile[poz].type,"_rint"))
        {
	   sprintf(eroare, "Variabila %s trebuie sa fie de tipul _rint pentru a putea avea asignat un numar fara virgula",nume);
           yyerror(eroare);
	   exit(0);
        } 
         if(variabile[poz].constant==1)
        {
          sprintf(eroare, "Variabila de tip const nu poate fi modificata");
	  yyerror(eroare);
          exit(0);
	}

	variabile[poz].value = val;
}

void assign_float(char* nume, float val)
{
	int poz = -1;
	for (int i = 0; i < contor_var; i++)
		if (!strcmp(variabile[i].name, nume))
			poz=i;
          if(poz==-1)
	{
         sprintf(eroare, "Variabila %s nu a fost declarata",nume);
	 yyerror(eroare);
         exit(0);
	}
         if(strcmp(variabile[poz].type,"_rfloat"))
        {
	   sprintf(eroare, "Variabila %s trebuie sa fie de tipul _rfloat pentru a putea avea asignat un numar cu virgula",nume);
           yyerror(eroare);
	   exit(0);
        } 
         if(variabile[poz].constant==1)
        {
          sprintf(eroare, "Variabila de tip const nu poate fi modificata");
	  yyerror(eroare);
          exit(0);
	}

	variabile[poz].floatvalue = val;
}


void assign_char(char* nume, char* simbol)
{
  int poz = -1;
	for (int i = 0; i < contor_var; i++)
		if (!strcmp(variabile[i].name, nume))
			poz=i;
        if(poz==-1)
       {  
        sprintf(eroare,"Variabila %s nu a fost declarata",nume);
        yyerror(eroare);
	exit(0);
       }


        if(strcmp(variabile[poz].type,"_rchar"))
        {
	   sprintf(eroare, "Variabila %s trebuie sa fie de tipul _rchar pentru a putea avea asignat un simbol",nume);
        }
        if(variabile[poz].constant==1)
        {
          sprintf(eroare, "Variabila de tip const nu poate fi modificata");
	  yyerror(eroare);
          exit(0);
	}
	strcpy(variabile[poz].message,simbol);
}

void assign_bool (char* nume, int value)
   {
    int poz = -1;
	for (int i = 0; i < contor_var; i++)
		if (!strcmp(variabile[i].name, nume))
			poz=i;
          if(poz==-1)
	{
         sprintf(eroare, "Variabila %s nu a fost declarata",nume);
	 yyerror(eroare);
         exit(0);
	}
         if(strcmp(variabile[poz].type,"_rbool"))
        {
	   sprintf(eroare, "Variabila %s trebuie sa fie de tipul _rint pentru a putea avea asignat true/false",nume);
           yyerror(eroare);
           exit(0);
        }
        if(variabile[poz].constant==1)
        {
          sprintf(eroare, "Variabila de tip const nu poate fi modificata");
	  yyerror(eroare);
          exit(0);
	} 
	variabile[poz].value = value;
}

void assign_string(char* nume, char *mesaj)
{
  int poz = -1;
	for (int i = 0; i < contor_var; i++)
		if (!strcmp(variabile[i].name, nume))
			poz=i;
        if(poz==-1)
       {  
        sprintf(eroare,"Variabila %s nu a fost declarata", nume);
        yyerror(eroare);
        exit(0);
       }

        if(strcmp(variabile[poz].type,"_rstring"))
        {
	   sprintf(eroare, "Variabila %s trebuie sa fie de tipul _rstring pentru a putea avea asignat un mesaj", nume);
           yyerror(eroare);
        }
        if(variabile[poz].constant==1)
        {
          sprintf(eroare, "Variabila de tip const nu poate fi modificata");
	  yyerror(eroare);
	}
	strcpy(variabile[poz].message, mesaj);
}
  
void assign_op(char* nume, char *op, int val)
{
	int poz = -1;
	for (int i = 0; i < contor_var; i++)
		if (!strcmp(variabile[i].name, nume))
			poz=i;
	if (poz == -1)
		{
                 sprintf(eroare, "Variabila %s nu a fost gasita", nume);
                 yyerror(eroare);
                 exit(0);
                }
	if (strcmp(variabile[poz].type, "_rint"))
		{		
		 sprintf(eroare, "Variabila trebuie sa fie de tip int");
                 yyerror(eroare);
                 exit(0);
                }
	if(!strcmp(op, "_r+="))
		variabile[poz].value += val;
	else if (!strcmp(op, "_r-="))
		variabile[poz].value -= val;
	else if (!strcmp(op, "_r/="))
		variabile[poz].value /= val;
	else if (!strcmp(op, "_r*="))
		variabile[poz].value *= val;

}

char* arg_list(char* argumente)
{
	argumente[strlen(argumente) - 1] = 0;
	return argumente;
}

void declare_function(char* tip, char* nume, char* argumente, bool metoda)
{
	char* arg = arg_list(argumente);
	bool ok = true;
	for (int i = 0; i < contor_fun; i++)
		if (!strcmp(funct[i].name, nume)&&!strcmp(funct[i].arg, arg))
			ok = false;
	if (ok == false)
		printf("Functia %s cu aceleasi argumente a fost deja declarata", nume);
	else
	{
		strcpy(funct[contor_fun].name, nume);
		strcpy(funct[contor_fun].arg, arg);
		strcpy(funct[contor_fun].type, tip);
                funct[contor_fun].metoda = metoda;
		contor_fun++;
	}
   
}

void incdec(char* nume, char *op)
{
	int poz=-1;
	for (int i = 0; i < contor_var; i++)
	{
		if (!strcmp(variabile[i].name, nume))
			poz = i;

	}
        if(poz == -1)
         {
           sprintf(eroare, "Variabila nu a fost declarata");
           yyerror(eroare);
           exit(0);
         }
        if(variabile[poz].existent_value == 0)
         {
           sprintf(eroare, "Variabila nu a fost initializata");
           yyerror(eroare);
	   exit(0);
         }
	if (strcmp(variabile[poz].type, "_rint"))
	 {
          sprintf(eroare, "Nu se poate incrementa/decrementa o variabila care nu este int");
          yyerror(eroare);
          exit(0);
         }
	if (!strcmp(op, "_r++"))
		variabile[poz].value++;
	if (!strcmp(op, "_r--"))
		variabile[poz].value--;
}

void check1(char* nume)
{
	int poz=-1;
	for (int i = 0; i < contor_var; i++)
	{
		if (!strcmp(variabile[i].name, nume))
			poz = i;

	}
        if(poz == -1)
         {
           sprintf(eroare, "Variabila nu a fost declarata");
           yyerror(eroare);
           exit(0);
         }
        if(variabile[poz].existent_value == 0)
         {
           sprintf(eroare, "Variabila %s nu a fost initializata", nume);
           yyerror(eroare);
           exit(0);
         }
       if(strcmp(variabile[poz].type, "_rint"))
         {
           sprintf(eroare, "Variabila %s nu este de tip _rint", nume);
           yyerror(eroare);
           exit(0);
         }
}

void check2(char* nume1, char* nume2)
{
	int poz1=-1;
	for (int i = 0; i < contor_var; i++)
	{
		if (!strcmp(variabile[i].name, nume1))
			poz1 = i;

	}
        if(poz1 == -1)
         {
           sprintf(eroare, "Variabila %s nu a fost declarata", nume1);
           yyerror(eroare);
           exit(0);
         }
        if(variabile[poz1].existent_value == 0)
         {
           sprintf(eroare, "Variabila %s nu a fost initializata", nume1);
           yyerror(eroare);
           exit(0);
         }
 
        int poz2=-1;
	for (int i = 0; i < contor_var; i++)
	{
		if (!strcmp(variabile[i].name, nume2))
			poz2 = i;

	}
        if(poz2 == -1)
         {
           sprintf(eroare, "Variabila %s nu a fost declarata", nume2);
           yyerror(eroare);
           exit(0);
         }
        if(variabile[poz2].existent_value == 0)
         {
           sprintf(eroare, "Variabila %s nu a fost initializata", nume2);
           yyerror(eroare);
           exit(0);
         }
       if(!strcmp(variabile[poz1].type, variabile[poz2].type))
         {
          sprintf(eroare, "Variabilele %s si %s nu sunt de acelasi tip", nume1, nume2);
          yyerror(eroare);
          exit(0);
         }
}

int value(char* nume)
{
  int poz=-1;
  for (int i = 0; i < contor_var; i++)
		if (!strcmp(variabile[i].name, nume))
			poz=i;
        if(poz==-1)
       {  
        sprintf(eroare,"Variabila %s nu a fost declarata", nume);
        yyerror(eroare);
        exit(0);
       }
   if(strcmp(variabile[poz].type, "_rint") && expresiones[contor_expr].nr_id>1)
    {
     sprintf(eroare, "Nu se poate construi o expresie cu variabile care nu sunt de tip _rint");
     yyerror(eroare);
     exit(0);
    }
   return variabile[poz].value;
} 

char* return_type_functie(char* nume, char* argumente)
{
  int poz=-1;
  for(int i=0; i < contor_fun; i++)
     if(!strcmp(funct[i].name, nume)&&!strcmp(funct[i].arg, argumente))
      poz=i;

 if(poz == -1)
 { 
  sprintf(eroare, "Functia %s cu argumentele %s nu a fost declarata", nume, argumente);
  yyerror(eroare);
  exit(0);
 }

 return funct[poz].type;

}
  

void tip_expresie(char* id)
{
  int poz=-1;
  for (int i = 0; i < contor_var; i++)
		if (!strcmp(variabile[i].name, id))
			poz=i;
        if(poz==-1)
       {  
        sprintf(eroare,"Variabila %s nu a fost declarata", id);
        yyerror(eroare);
	exit(0);
       }
        if(expresiones[contor_expr].nr_id > 1 && strcmp(expresiones[contor_expr].tip, "_rint"))
    {
      sprintf(eroare, "Nu se poate construi o expresie cu variabile care nu sunt de tip _rint");
     yyerror(eroare);
     exit(0);
    }
    
        if(!strcmp(variabile[poz].type, "_rchar"))
        {
          strcpy(expresiones[contor_expr].tip, "_rchar");
	  expresiones[contor_expr].id_notint=1;
        }
  else  if(!strcmp(variabile[poz].type, "_rstring"))
        {
          strcpy(expresiones[contor_expr].tip, "_rstring");
          expresiones[contor_expr].id_notint=1;
        }
  else  if(!strcmp(variabile[poz].type, "_rbool"))
        {
          strcpy(expresiones[contor_expr].tip, "_rbool");
	  expresiones[contor_expr].id_notint=1;
        }
  else  if(!strcmp(variabile[poz].type, "_rfloat"))
        {
          strcpy(expresiones[contor_expr].tip, "_rfloat");
	  expresiones[contor_expr].id_notint=1;
        }
  else  if(!strcmp(variabile[poz].type, "_rint") && expresiones[contor_expr].id_notint==0)
        strcpy(expresiones[contor_expr].tip, "_rint");
  }


void Eval(char* nume)
{
  int poz=-1;
  for (int i = 0; i < contor_var; i++)
		if (!strcmp(variabile[i].name, nume))
			poz=i;
        if(poz==-1)
       {  
        sprintf(eroare,"Variabila %s nu a fost declarata", nume);
        yyerror(eroare);
	exit(0);
       }
        if(variabile[poz].existent_value == 0)
        {
           sprintf(eroare, "Variabila %s nu a fost initializata", nume);
           yyerror(eroare);
	   exit(0);
        }
        if(strcmp(variabile[poz].type, "_rint"))
         {
           sprintf(eroare, "Variabila %s nu este de tip _rint", nume);
           yyerror(eroare);
	   exit(0);
         }
     printf("Valaorea lui %s este %d", variabile[poz].name, variabile[poz].value);
   }

void assign_tip_string_plus(char* tip, char* nume, char* nume1, char *nume2)
{
   if(strcmp(tip, "_rstring"))
  {
    sprintf(eroare,"Variabila %s trebuie sa fie de tip _rstring", nume);
    yyerror(eroare);
    exit(0);
  }
   int poz1=-1;
  for (int i = 0; i < contor_var; i++)
		if (!strcmp(variabile[i].name, nume1))
			poz1=i;
        if(poz1==-1)
       {  
        sprintf(eroare,"Variabila %s nu a fost declarata", nume1);
        yyerror(eroare);
	exit(0);
       }
  int poz2=-1;
  for (int i = 0; i < contor_var; i++)
		if (!strcmp(variabile[i].name, nume2))
			poz2=i;
        if(poz2==-1)
       {  
        sprintf(eroare,"Variabila %s nu a fost declarata", nume2);
        yyerror(eroare);
	exit(0);
       }
   if(variabile[poz1].existent_value == 0)
        {
           sprintf(eroare, "Variabila %s nu a fost initializata", nume1);
           yyerror(eroare);
	   exit(0);
        }
  if(variabile[poz2].existent_value == 0)
        {
           sprintf(eroare, "Variabila %s nu a fost initializata", nume2);
           yyerror(eroare);
	   exit(0);
        }

   strcpy(variabile[contor_var].name, nume);
   strcpy(variabile[contor_var].type, tip);
   strcpy(variabile[contor_var].message, variabile[poz1].message);
   strcat(variabile[contor_var].message, variabile[poz2].message); 
   variabile[contor_var].constant=0;
   variabile[contor_var].existent_value=1;
   variabile[contor_var].global=1;
   contor_var++;
}
   
void assign_string_plus(char* nume, char* nume1, char* nume2)
{
  int poz=-1;
  for (int i = 0; i < contor_var; i++)
		if (!strcmp(variabile[i].name, nume1))
			poz=i;
        if(poz==-1)
       {  
        sprintf(eroare,"Variabila %s nu a fost declarata", nume);
        yyerror(eroare);
	exit(0);
       }
    if(strcmp(variabile[poz].type, "_rstring"))
       {  
        sprintf(eroare,"Variabila %s nu este de tip _rstring", nume);
        yyerror(eroare);
	exit(0);
       }
  int poz1=-1;
  for (int i = 0; i < contor_var; i++)
		if (!strcmp(variabile[i].name, nume1))
			poz1=i;
        if(poz1==-1)
       {  
        sprintf(eroare,"Variabila %s nu a fost declarata", nume1);
        yyerror(eroare);
	exit(0);
       }
  int poz2=-1;
  for (int i = 0; i < contor_var; i++)
		if (!strcmp(variabile[i].name, nume2))
			poz2=i;
        if(poz2==-1)
       {  
        sprintf(eroare,"Variabila %s nu a fost declarata", nume2);
        yyerror(eroare);
	exit(0);
       }
   if(variabile[poz1].existent_value == 0)
        {
           sprintf(eroare, "Variabila %s nu a fost initializata", nume1);
           yyerror(eroare);
	   exit(0);
        }
  if(variabile[poz2].existent_value == 0)
        {
           sprintf(eroare, "Variabila %s nu a fost initializata", nume2);
           yyerror(eroare);
	   exit(0);
        }


   strcpy(variabile[poz].message, variabile[poz1].message);
   strcat(variabile[poz].message, variabile[poz2].message); 
   variabile[poz].existent_value=1;
}

void assign_tip_string_mult(char* tip, char* nume, char* nume1, char value) 
{
  if(strcmp(tip, "_rstring"))
  {
    sprintf(eroare,"Variabila %s trebuie sa fie de tip _rstring", nume);
    yyerror(eroare);
    exit(0);
  }
  int poz1=-1;
  for (int i = 0; i < contor_var; i++)
		if (!strcmp(variabile[i].name, nume1))
			poz1=i;
        if(poz1==-1)
       {  
        sprintf(eroare,"Variabila %s nu a fost declarata", nume1);
        yyerror(eroare);
	exit(0);
       }
 
       if(variabile[poz1].existent_value == 0)
        {
           sprintf(eroare, "Variabila %s nu a fost initializata", nume1);
           yyerror(eroare);
	   exit(0);
        }
   strcpy(variabile[contor_var].name, nume);
   strcpy(variabile[contor_var].type, tip);
   for(int i=0; i < value; i++) 
   strcat(variabile[contor_var].message, variabile[poz1].message); 
   variabile[contor_var].constant=0;
   variabile[contor_var].existent_value=1;
   variabile[contor_var].global=1;
   contor_var++;
}

void assign_string_mult(char* nume, char* nume1, char value)
{
  int poz=-1;
  for (int i = 0; i < contor_var; i++)
		if (!strcmp(variabile[i].name, nume1))
			poz=i;
        if(poz==-1)
       {  
        sprintf(eroare,"Variabila %s nu a fost declarata", nume);
        yyerror(eroare);
	exit(0);
       }
    if(strcmp(variabile[poz].type, "_rstring"))
       {  
        sprintf(eroare,"Variabila %s nu este de tip _rstring", nume);
        yyerror(eroare);
	exit(0);
       }
  int poz1=-1;
  for (int i = 0; i < contor_var; i++)
		if (!strcmp(variabile[i].name, nume1))
			poz1=i;
        if(poz1==-1)
       {  
        sprintf(eroare,"Variabila %s nu a fost declarata", nume1);
        yyerror(eroare);
	exit(0);
       }
   if(variabile[poz1].existent_value == 0)
        {
           sprintf(eroare, "Variabila %s nu a fost initializata", nume1);
           yyerror(eroare);
	   exit(0);
        }

   strcpy(variabile[poz].message, variabile[poz1].message);
   for(int i=0; i < value-1; i++) 
   strcat(variabile[poz].message, variabile[poz1].message); 
   variabile[poz].existent_value=1;
}

void assign_tip_string_minus(char* tip, char* nume, char* nume1, char *nume2)
{
   if(strcmp(tip, "_rstring"))
  {
    sprintf(eroare,"Variabila %s trebuie sa fie de tip _rstring", nume);
    yyerror(eroare);
    exit(0);
  }
   int poz1=-1;
  for (int i = 0; i < contor_var; i++)
		if (!strcmp(variabile[i].name, nume1))
			poz1=i;
        if(poz1==-1)
       {  
        sprintf(eroare,"Variabila %s nu a fost declarata", nume1);
        yyerror(eroare);
	exit(0);
       }
  int poz2=-1;
  for (int i = 0; i < contor_var; i++)
		if (!strcmp(variabile[i].name, nume2))
			poz2=i;
        if(poz2==-1)
       {  
        sprintf(eroare,"Variabila %s nu a fost declarata", nume2);
        yyerror(eroare);
	exit(0);
       }
   if(variabile[poz1].existent_value == 0)
        {
           sprintf(eroare, "Variabila %s nu a fost initializata", nume1);
           yyerror(eroare);
	   exit(0);
        }
  if(variabile[poz2].existent_value == 0)
        {
           sprintf(eroare, "Variabila %s nu a fost initializata", nume2);
           yyerror(eroare);
	   exit(0);
        }

   strcpy(variabile[contor_var].name, nume);
   strcpy(variabile[contor_var].type, tip);
   bool ok = true;
   int  i=0, j=0, inc = 0, sf = 0;
 for (i = 0; i < strlen(variabile[poz1].message); i++)
 {
   int contor = 0;
   ok = true;
   for (j = i; j < i+ strlen(variabile[poz2].message); j++)
   {
     if (variabile[poz1].message[j] != variabile[poz2].message[contor])
        ok = false;
     contor++;
   }
   if (ok == true)
  {
  inc = i;
  sf = j+1;
  break;
  }
}
   strcpy(variabile[contor_var].message, variabile[poz1].message);
   strcpy(variabile[contor_var].message + inc, variabile[poz2].message + sf);
 
   variabile[contor_var].constant=0;
   variabile[contor_var].existent_value=1;
   variabile[contor_var].global=1;
   contor_var++;
}

void assign_string_minus(char* nume, char* nume1, char* nume2)
{
  int poz=-1;
  for (int i = 0; i < contor_var; i++)
		if (!strcmp(variabile[i].name, nume))
			poz=i;
        if(poz==-1)
       {  
        sprintf(eroare,"Variabila %s nu a fost declarata", nume);
        yyerror(eroare);
	exit(0);
       }
    if(strcmp(variabile[poz].type, "_rstring"))
       {  
        sprintf(eroare,"Variabila %s nu este de tip _rstring", nume);
        yyerror(eroare);
	exit(0);
       }
  int poz1=-1;
  for (int i = 0; i < contor_var; i++)
		if (!strcmp(variabile[i].name, nume1))
			poz1=i;
        if(poz1==-1)
       {  
        sprintf(eroare,"Variabila %s nu a fost declarata", nume1);
        yyerror(eroare);
	exit(0);
       }
   if(variabile[poz1].existent_value == 0)
        {
           sprintf(eroare, "Variabila %s nu a fost initializata", nume1);
           yyerror(eroare);
	   exit(0);
        }

   int poz2=-1;
  for (int i = 0; i < contor_var; i++)
		if (!strcmp(variabile[i].name, nume2))
			poz2=i;
        if(poz2==-1)
       {  
        sprintf(eroare,"Variabila %s nu a fost declarata", nume2);
        yyerror(eroare);
	exit(0);
       }
   if(variabile[poz2].existent_value == 0)
        {
           sprintf(eroare, "Variabila %s nu a fost initializata", nume2);
           yyerror(eroare);
	   exit(0);
        }

   bool ok = true;
   int  i=0, j=0, inc = 0, sf = 0;
 for (i = 0; i < strlen(variabile[poz1].message); i++)
{
   int contor = 0;
   ok = true;
   for (j = i; j < i+ strlen(variabile[poz2].message); j++)
   {
     if (variabile[poz1].message[j]!= variabile[poz2].message[contor])
        ok = false;
     contor++;
   }
   if (ok == true)
  {
   inc = i;
   sf = j;
   break;
  }
}  
   strcpy(variabile[poz].message, variabile[poz1].message);
   strcpy(variabile[poz].message + inc, variabile[poz1].message + sf);

   variabile[poz].existent_value=1;
} 
 
%}

%token TIP ID MAIN ASSIGN NR FLOAT IF ELSE WHILE FOR OP INC DEC LP AND OR PLUS MINUS PRODUS IMPARTIRE VOID DISPLAY CLASS CONST TRUE FALSE PUBLIC PRIVATE PROTECTED LITERA RETURN PLUSSTR MINUSSTR MULTSTR EVAL
%start s


%left '+' '-'
%left '*' '/'
%left INC DEC
%left OR
%left AND

%union
{
  int intval;
  char *strval;
  float floatval;
  
}

%type <intval> expresie NR
%type <strval> TIP VOID ID LITERA INC DEC PRODUS IMPARTIRE PLUS MINUS parametri parametru arg call_list call_lists call_functions
%type <floatval> FLOAT

%%

s: progr {printf("input acceptat!\n");}

progr: declaratii main
     | main
     | declaratii clase main
     | clase main
     ;


arg: '(' ')' {$$=malloc(256); }
   | '(' parametri ')' {$$=$2;}
   ;

parametri: parametru {$$=$1; strcat($$, ",");}
	 | parametru ',' parametri {$$=$1; strcat($$, ","); strcat($$, $3);}
	 ;

parametru: TIP ID {$$=$1;}
	 ;

clase: clasa
     | clase clasa
     ;

clasa: CLASS ID '{' declaratii_clase '}' LP
     | CLASS ID '{' declaratii_clase functions '}' LP
     | CLASS ID '{' functions '}' LP
     ;

functions: function
	 | function functions
	 ;

function: TIP ID arg '{' instructiuni RETURN ID LP '}' {declare_function($1, $2, $3,1);}
	| PUBLIC ':' TIP ID arg '{' instructiuni RETURN ID LP '}' {declare_function($3, $4, $5,1);}
	| PUBLIC ':' TIP ID arg '{' instructiuni RETURN TRUE LP '}' {declare_function($3, $4, $5,1);}	
        | PUBLIC ':' TIP ID arg '{' instructiuni RETURN FALSE LP '}' {declare_function($3, $4, $5,1);}
	| PRIVATE ':' TIP ID arg '{' instructiuni RETURN ID LP '}' {declare_function($3, $4, $5,1);}
	| PRIVATE ':' TIP ID arg '{' instructiuni RETURN TRUE LP '}' {declare_function($3, $4, $5,1);}
	| PRIVATE ':' TIP ID arg '{' instructiuni RETURN FALSE LP '}' {declare_function($3, $4, $5,1);}
	| PROTECTED ':' TIP ID arg '{' instructiuni RETURN ID LP '}' {declare_function($3, $4, $5,1);}
	| PROTECTED ':' TIP ID arg '{' instructiuni RETURN TRUE LP '}' {declare_function($3, $4, $5,1);}
	| PROTECTED ':' TIP ID arg '{' instructiuni RETURN FALSE LP '}' {declare_function($3, $4, $5,1);}
	;

declaratii_clase: declaratii_clas
		| declaratii_clase declaratii_clas
		;

declaratii_clas: PUBLIC ':' declar LP
	       | PRIVATE ':' declar LP
	       | PROTECTED ':' declar LP
	       | declar LP
	       ;

declar : TIP ID {declaratie1($1, $2, 0, 0);}
       | TIP ID ASSIGN NR {declaratie2_int($1, $2, $4, 0, 0);}
       | TIP ID ASSIGN FLOAT {declaratie2_float($1, $2, $4, 0, 0);}
       | TIP ID ASSIGN ID {declaratie2_tip($1, $2, $4, 0, 0);}
       | CONST TIP ID ASSIGN ID {declaratie2_tip($2, $3, $5, 1, 0);} 
       | ID ASSIGN NR {assign_int($1, $3);}
       | ID ASSIGN FLOAT {assign_float($1, $3);}
       | ID ASSIGN ID {declaratie2($1, $3);}
       | CONST TIP ID {declaratie1($2, $3, 1, 0);}
       | TIP ID ASSIGN LITERA {declaratie2_char($1, $2, $4, 0, 0);}
       | ID ASSIGN LITERA {assign_char($1, $3);}
       | TIP ID ASSIGN '"' ID '"' {declaratie2_string($1, $2, $5, 0, 0);}
       | TIP ID ASSIGN ID PLUSSTR ID {assign_tip_string_plus($1, $2, $4, $6);}
       | TIP ID ASSIGN ID MINUSSTR ID {assign_tip_string_minus($1, $2, $4, $6);}
       | TIP ID ASSIGN ID MULTSTR NR {assign_tip_string_mult($1, $2, $4, $6);}
       | ID ASSIGN '"' ID '"' {assign_string($1, $4);}
       | ID ASSIGN ID PLUSSTR ID {assign_string_plus($1, $3, $5);}
       | ID ASSIGN ID MINUSSTR ID {assign_string_minus($1, $3, $5);}
       | ID ASSIGN ID MULTSTR NR {assign_string_mult($1, $3, $5);}
       | TIP ID ASSIGN TRUE {declaratie2_bool($1, $2, 1, 0, 0);}
       | TIP ID ASSIGN FALSE {declaratie2_bool($1, $2, 0, 0, 0);}
       | ID ASSIGN TRUE {assign_bool($1,1);}
       | ID ASSIGN FALSE {assign_bool($1,0);}
       | CONST TIP ID ASSIGN NR {declaratie2_int($2, $3, $5, 1, 1);}
       | CONST TIP ID ASSIGN '"' ID '"' {declaratie2_string($2, $3, $6, 1, 1);}
       | CONST TIP ID ASSIGN LITERA {declaratie2_char($2, $3, $5, 1, 1);}
       | CONST TIP ID ASSIGN TRUE {declaratie2_bool($2, $3, 1, 1, 1);}
       | CONST TIP ID ASSIGN FALSE {declaratie2_bool($2, $3, 0, 1, 1);}
       | TIP ID '[' vectori ']'
       | TIP ID arg '{' instructiuni RETURN ID LP '}' {declare_function($1, $2, $3,1);}
       | TIP ID arg '{' instructiuni RETURN NR LP '}' {declare_function($1, $2, $3,1);}
       | TIP ID arg '{' instructiuni RETURN TRUE LP '}' {declare_function($1, $2, $3,1);}
       | TIP ID arg '{' instructiuni RETURN FALSE LP '}' {declare_function($1, $2, $3,1);}
       | VOID ID arg '{' instructiuni '}' {declare_function($1, $2, $3,1);}
       ;

declaratii: declaratie LP
	  | declaratii declaratie LP 
	  ;

declaratie: TIP ID {declaratie1($1, $2, 0, 1);}
      	  | TIP ID ASSIGN NR {declaratie2_int($1, $2, $4, 0, 1);}
          | TIP ID ASSIGN FLOAT {declaratie2_float($1, $2, $4, 0, 1);}
      	  | TIP ID ASSIGN ID {declaratie2_tip($1, $2, $4, 0, 1);}
	  | CONST TIP ID ASSIGN ID {declaratie2_tip($2, $3, $5, 1, 1);} 
     	  | ID ASSIGN NR {assign_int($1, $3);}
          | ID ASSIGN FLOAT {assign_float($1, $3);}
      	  | ID ASSIGN ID {declaratie2($1, $3);}
      	  | CONST TIP ID {declaratie1($2, $3, 1, 1);}
      	  | TIP ID ASSIGN LITERA {declaratie2_char($1, $2, $4, 0, 1);}
      	  | ID ASSIGN LITERA {assign_char($1, $3);}
      	  | TIP ID ASSIGN '"' ID '"' {declaratie2_string($1, $2, $5, 0, 1);}
	  | TIP ID ASSIGN ID PLUSSTR ID {assign_tip_string_plus($1, $2, $4, $6);}
          | TIP ID ASSIGN ID MINUSSTR ID {assign_tip_string_minus($1, $2, $4, $6);}
          | TIP ID ASSIGN ID MULTSTR NR {assign_tip_string_mult($1, $2, $4, $6);}
          | ID ASSIGN '"' ID '"' {assign_string($1, $4);}
          | ID ASSIGN ID PLUSSTR ID {assign_string_plus($1, $3, $5);}
          | ID ASSIGN ID MINUSSTR ID {assign_string_minus($1, $3, $5);}
          | ID ASSIGN ID MULTSTR NR {assign_string_mult($1, $3, $5);}
          | TIP ID ASSIGN TRUE {declaratie2_bool($1, $2, 1, 0, 1);}
          | TIP ID ASSIGN FALSE {declaratie2_bool($1, $2, 0, 0, 1);}
	  | ID ASSIGN TRUE {assign_bool($1,1);}
	  | ID ASSIGN FALSE {assign_bool($1,0);}
	  | CONST TIP ID ASSIGN NR {declaratie2_int($2, $3, $5, 1, 1);}
          | CONST TIP ID ASSIGN '"' ID '"' {declaratie2_string($2, $3, $6, 1, 1);}
          | CONST TIP ID ASSIGN LITERA {declaratie2_char($2, $3, $5, 1, 1);}
          | CONST TIP ID ASSIGN TRUE {declaratie2_bool($2, $3, 1, 1, 1);}
          | CONST TIP ID ASSIGN FALSE {declaratie2_bool($2, $3, 0, 1, 1);}
          | TIP ID '[' vectori ']'
	  | TIP ID arg '{' instructiuni RETURN ID LP '}' {declare_function($1, $2, $3,0);}
          | TIP ID arg '{' instructiuni RETURN NR LP '}' {declare_function($1, $2, $3,0);}
          | TIP ID arg '{' instructiuni RETURN TRUE LP '}' {declare_function($1, $2, $3,0);}
          | TIP ID arg '{' instructiuni RETURN FALSE LP '}' {declare_function($1, $2, $3,0);}
          | VOID ID arg '{' instructiuni '}' {declare_function($1, $2, $3,0);}
          ;

vectori: NR
       | vectori NR
       ;

main: TIP MAIN '(' ')' '{' instructiuni '}'
    ;

instructiuni: instructiune 
	    | instructiuni instructiune  
	    ;

instructiune: instr LP
	    | if
	    | while
	    | for
	    | call_functions LP
	    | declaration LP
            | eval LP
	    ;

eval: EVAL '(' ID ')' {Eval($3);}
    ;

declaration: TIP ID ASSIGN NR {declaratie2_int($1, $2, $4, 0, 0);}
	   | TIP ID {declaratie1($1, $2, 0, 0);}
	   | TIP ID ASSIGN TRUE {declaratie2_bool($1, $2, 1, 0, 0);}
	   | TIP ID ASSIGN FALSE {declaratie2_int($1, $2, 0, 0, 0);}
	   | TIP ID ASSIGN '"' ID '"' {declaratie2_string($1, $2, $5, 0, 0);}
	   | TIP ID '[' vectori ']'
	   | CONST TIP ID ASSIGN NR {declaratie2_int($2, $3, $5, 1, 0);}
	   | CONST TIP ID {declaratie1($2, $3, 0, 0);}
	   | CONST TIP ID ASSIGN TRUE {declaratie2_bool($2, $3, 1, 1, 0);}
	   | CONST TIP ID ASSIGN FALSE {declaratie2_int($2, $3, 0, 1, 0);}
	   | CONST TIP ID ASSIGN '"' ID '"' {declaratie2_string($2, $3, $6, 1, 0);}
	   | CONST TIP ID '[' vectori ']'	 
	   ;

call_functions : ID '(' call_lists ')' {$$ = return_type_functie($1, $3); printf("Argumentele sunt: %s\n", $3); printf("contor_expr: %d\n", contor_expr);}
               ;

call_lists: call_list {$$=$1; printf("regula 1\n");}
	  | call_lists ',' call_list {$$=$1; strcat($$, ","); strcat($$, $3);printf("regula 2\n"); printf("%s\n", $$);}
          ;
call_list : expresie {$$=malloc(256); strcpy($$, expresiones[contor_expr].tip); printf("regula 3\n"); contor_expr++;} 
	  | call_functions {$$=$1;printf("regula 4\n");}
          ;

for : FOR '(' initializare ';' conditie ';' incrementare ')' '{' execute '}'
    ;

while : WHILE '(' conditie ')' '{' execute '}'
      ;

if: IF '(' conditie ')' '{' execute '}' 
  | IF '(' conditie ')' '{' execute '}' ELSE '{' execute '}'
  ;

initializare: ID ASSIGN NR {assign_int($1, $3);}
	    ;

incrementare: ID INC {incdec($1, $2);}
	    | ID DEC {incdec($1, $2);}
	    ;

conditie: cond 
        | conditie AND cond
	| conditie OR cond
	;

cond: ID OP ID {check2($1,$3);}
    | ID OP NR {check1($1);}
    ;

execute: instr LP
       | execute instr LP
       ;

instr : ID ASSIGN expresie {assign_int($1,$3);}
      | ID INC {incdec($1, $2);}
      | ID DEC {incdec($1, $2);}
      | ID PLUS expresie {assign_op($1, $2, $3);}
      | ID MINUS expresie {assign_op($1, $2, $3);}
      | ID PRODUS expresie {assign_op($1, $2, $3);}
      | ID IMPARTIRE expresie {assign_op($1, $2, $3);}
      ;

expresie : NR {$$=$1; expresiones[contor_expr].nr_id++; if(expresiones[contor_expr].nr_id==1) strcpy(expresiones[contor_expr].tip, "_rint"); printf("regula 5\n");}
	 | ID {expresiones[contor_expr].nr_id++; tip_expresie($1); $$=value($1); printf("bla bla %s\n", expresiones[contor_expr].tip); printf("regula 6\n");}
	 | expresie '+' expresie {$$=$1+$3; printf("regula 7\n");}
	 | expresie '-' expresie {$$=$1-$3; printf("regula 8\n");}
	 | expresie '*' expresie {$$=$1*$3; printf("regula 9\n");}
	 | expresie '/' expresie {$$=$1/$3; printf("regula 10\n");}
	 | '(' expresie ')' {$$=$2; printf("regula 11\n");}  
	 ;

%%

int yyerror(char * s)
{
 printf("eroare la linia %d: %s\n",yylineno,s);
}

int main(int argc,char **argv)
{
 yyin=fopen(argv[1],"r");
 yyparse();
 FILE *fd=fopen("symbol_table.txt","w");
 printf("Contor_var este: %d\n", contor_var);
 printf("Contor_fun este: %d\n", contor_fun);
 /*char *tipuletz;
 tipuletz=tip_functie(funct[0].name,funct[0].arg);
 printf("tip_functie este: %s\n", tipuletz); */
 for(int i=0; i<contor_var;i++)
   fprintf(fd, "%s %s %d %s %d exista:%d\n", variabile[i].name, variabile[i].type, variabile[i].value, variabile[i].message, variabile[i].constant, variabile[i].existent_value);
  for(int i=0; i<contor_fun;i++)
    fprintf(fd, "%s %s %s\n", funct[i].name, funct[i].type, funct[i].arg);
    fclose(fd);
    for(int i=0; i<contor_expr;i++)
    printf("%s %d\n", expresiones[i].tip, expresiones[i].nr_id);
}

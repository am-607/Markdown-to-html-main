%{

#include <stdio.h>
       
#include <string.h>
       
extern int yylex(void);
        
extern int yyparse(void);
        void yyerror(char *s){
        fprintf(stderr, "error: %s",s);
}
        int image_began=0, url_began=0,para_begin=0, ol=0, ul=0,h=0;

%}


        
%token PARA LINEBREAK SOFTBREAK TEXT BOLD1 
        BOLD2 ITALIC1 ITALIC2 BOLDITALIC1 BOLDITALIC2 STRIKE
        HEADING1 HEADING2 HEADING3 HEADING4 HEADING5  HEADING6
        BOLD_ITALIC_1O BOLD_ITALIC_1C BOLD_ITALIC_2O 
        BOLD_ITALIC_2C BI1_O BI1_C BI2_O BI2_C SBO SBC BO BC 
        IMG_ST ORDLIST_LIST UNORDLIST_LIST 

       
%union{
        char *str;
}

        
%type <str> PARA LINEBREAK SOFTBREAK TEXT   BOLD1 
        BOLD2 ITALIC1 ITALIC2 BOLDITALIC1 BOLDITALIC2 STRIKE
        HEADING1 HEADING2 HEADING3 HEADING4 HEADING5  HEADING6
        BOLD_ITALIC_1O BOLD_ITALIC_1C BOLD_ITALIC_2O
        BOLD_ITALIC_2C
        BI1_O BI1_C BI2_O BI2_C SBO SBC BO BC IMG_ST 
        programs sections section text bold_italic_text 
        bold_text italic_text
        strike url image  headings olist ulist 

        
%start programs;


%%
 
        
programs: 
        SOFTBREAK programs|

        PARA programs|

        {printf("<!DOCTYPE html>\n");}

        {printf("<html>\n");}

        {printf("<head>\n");}

        {printf("       <title>\n");}

        {printf("       </title>\n");}

        {printf("</head>\n");}

        {printf("<body>\n");}

          sections

        {printf("</body>\n");}

        {printf("</html>\n");}

;

sections:  
        section whitespace sections

        |  section  enddd
;


enddd:  

        %empty {if(para_begin==1) {para_begin=0; printf("</p>\n");}
        if(ol==1){ol=0;printf("</ol>\n");}
        if(ul==1){ul=0;printf("</ul>\n");}
        }

        | SOFTBREAK {if(para_begin==1) {para_begin=0; printf("</p>\n");}
        if(ol==1){ol=0;printf("</ol>\n");}
        if(ul==1){ul=0;printf("</ul>\n");}
        
        }
        |PARA {if(para_begin==1) {para_begin=0; printf("</p>\n");}
        if(ol==1){ol=0;printf("</ol>\n");}
        if(ul==1){ul=0;printf("</ul>\n");}
        
        }
;
whitespace:

        LINEBREAK {printf("<br>\n");}

        |PARA {if(para_begin==1){printf("</p>\n");para_begin=0;}   
        if(ol==1){printf("</ol>\n");ol=0;}  
        if(ul==1){printf("</ul>\n");ul=0;}     
        }
         

        |SOFTBREAK
        |%empty
;


section:

        bold_italic_text
        |bold_text
        |italic_text
        | strike


        |headings

        |url

        |olist
        |ulist

        | image

        | text {$$=$1;
        if(para_begin==0 && ol==0 && ul==0 && h==0){printf("<p>");para_begin=1;}

        if(image_began==0 && url_began==0)
        printf("%s",$1);}
        ;



olist: ORDLIST_LIST  {
        if(para_begin==1){
                printf("</p>\n");
                para_begin=0;
        }
        if(ol==1){
                printf("<li>"); 
        }
        else{ol=1;
                printf("<ol>\n<li>");
        }
} section {printf("</li>\n");}
;

ulist : UNORDLIST_LIST {
        if(para_begin==1){
                printf("</p>\n");
                para_begin=0;
        }
        if(ul==1){
                printf("<li>"); 
        }
         else{ul=1;
                printf("<ul>\n<li>");
        }
}
        section {printf("</li>\n");}




headings: HEADING1 {
        if(para_begin==1){
                printf("</p>\n");para_begin=0;
        }
        if(ol==1){
                printf("</ol>\n");ol=0;
        } 
        if(ul==1){
                printf("</ul>\n");ul=0;
        } 
        h=1; printf("<h1>");} section {h=0;printf("</h1>\n");}
        | HEADING2 {
        if(para_begin==1){
                printf("</p>\n");para_begin=0;
        }
        if(ol==1){
                printf("</ol>\n");ol=0;
        } 
        if(ul==1){
                printf("</ul>\n");ul=0;
        } h=1;printf("<h2>");}section {h=0; printf("</h2>\n");}
        | HEADING3 {
        if(para_begin==1){
                printf("</p>\n");para_begin=0;
        }
        if(ol==1){
                printf("</ol>\n");ol=0;
        } 
        if(ul==1){
                printf("</ul>\n");ul=0;
        } h=1;printf("<h3>");} section {h=0;printf("</h3>\n");}
        | HEADING4 {
        if(para_begin==1){
                printf("</p>\n");para_begin=0;
        }
        if(ol==1){
                printf("</ol>\n");ol=0;
        }
        if(ul==1){
                printf("</ul>\n");ul=0;
        }  h=1;printf("<h4>");}section {h=0;printf("</h4>\n");}
        | HEADING5 {
        if(para_begin==1){
                printf("</p>\n");para_begin=0;
        }
        if(ol==1){
                printf("</ol>\n");ol=0;
        } 
        if(ul==1){
                printf("</ul>\n");ul=0;
        } h=1;printf("<h5>");}section {h=0;printf("</h5>\n");}
        | HEADING6 {
        if(para_begin==1){
                printf("</p>\n");para_begin=0;
        }
        if(ol==1){
                printf("</ol>\n");ol=0;
        } 
        if(ul==1){
                printf("</ul>\n");ul=0;
        } h=1;printf("<h6>");}section {h=0;printf("</h6>\n");}
;



bold_italic_text:BOLDITALIC1  { if(para_begin==0 && h==0 && ul==0 && ol==0){para_begin=1;printf("<p>"); }printf("<strong><em>");}section BOLDITALIC1  {printf("</em></strong>\n");}
                |BOLDITALIC2  { if(para_begin==0 && h==0 && ul==0 && ol==0){para_begin=1;printf("<p>");}printf("<strong><em>");}section BOLDITALIC2  {printf("</em></strong>\n");}
;

bold_text: BOLD1{ if(para_begin==0 && h==0 && ul==0 && ol==0){para_begin=1;printf("<p>"); }printf("<strong>");} section BOLD1 {printf("</strong>\n");}
          |BOLD2  { if(para_begin==0 && h==0 && ul==0 && ol==0){para_begin=1;printf("<p>"); }printf("<strong>");} section BOLD2 {printf("</strong>\n");}

;
italic_text: 
        ITALIC1 { if(para_begin==0 && h==0 && ul==0 && ol==0){para_begin=1;printf("<p>"); }printf("</em>");}section ITALIC1 {printf("</em>\n");}
        |  ITALIC2 { if(para_begin==0 && h==0 && ul==0 && ol==0){para_begin=1;printf("<p>"); }printf("</em>");}section ITALIC2 {printf("</em>\n");}
;

strike: STRIKE { if(para_begin==0 && h==0 && ul==0 && ol==0){para_begin=1;printf("<p>"); }printf("</del>");}section STRIKE {printf("</del>\n");}





url: SBO {url_began=1;}section SBC BO section BC 
{                                       
        printf("<a href= \"%s\" ><strong>%s</strong></a>",$6,$3);
        url_began=0;
}
;


image:IMG_ST {image_began=1;}SBO section SBC BO section BC {
        printf("<img src=\"%s\"  alt=%s>",$7,$4);
        image_began=0;
}

;


text: TEXT {$$=$1;};

%%

int main() {
    yyparse();
    return 0;
}

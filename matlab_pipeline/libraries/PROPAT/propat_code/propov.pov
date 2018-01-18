// PoVRay 3.7 Scene File " propat.pov"
// author:  Valdemir Carrara
// date:    01/02/2012
//------------------------------------------------------------------------
#version 3.6;
#default{ finish{ ambient 0.1 diffuse 0.9 }} 
    global_settings{ assumed_gamma 1.0 }
    background { color <1.000,1.000,1.000>*0 }

//------------------------------------------------------------------------
#include "colors.inc"
#include "textures.inc"
#include "math.inc"
#include "transforms.inc"
#include "propov.inc"

//------------------------------------------------------------------------ 
// Camera: right handed Coordinate system z up 
#declare Camera_0 = camera {/*ultra_wide_angle*/ angle 55  // front view from x+
                            sky z
                            location  <1.0 , 0.0 , 0.1>
                            right    -x*image_width/image_height
                            look_at   <0.0 , 0.0 , 1.0>}
#declare Camera_1 = camera {angle 20  // diagonal view
                            sky x
                            right    -x*image_width/image_height
                            //location  <250, 300, 300 >
                            //location  <500, 1, 0 >
                            //location  <25.0, 0.01, 0.01 >
                            location  <2.5, 3.0, 3.0 >
                            look_at   <0.0 , 0 , 0.0> }
#declare Camera_2 = camera {/*ultra_wide_angle*/ angle 55  //right side view from y-
                            sky z
                            location  <0.0 ,-10.0 , 1.0>
                            right    -x*image_width/image_height
                            look_at   <0.0 , 0.0 , 1.0>}
#declare Camera_3 = camera {/*ultra_wide_angle*/ angle 65   // top view from z- (x right y up )
                            sky z 
                            location  < 0,-0.001, 10>
                            right    -x*image_width/image_height
                            look_at   <0.0 , 0.0 , 1.0>}
#declare Camera_Ortho = camera { orthographic angle 20  // orthografic
                            sky z
                            right    -x*image_width/image_height
                            location  <.0, 5.0, 0 >
                            look_at   <0.0 , 0 , 0.0> }
//------------------------------------------------------------------------

// sun -------------------------------------------------------------------
//    light_source {<1000., 1400, 500> color rgb <1.000, 1.000, 1.000>}

// sky -------------------------------------------------------------------
//    sky_sphere{ pigment {color rgb <.7,.8, 1>} }

//------------------------------------------------------------------------
// Macro para efetuar rotações a partir de um vetor contendo os ângulos de Euler da atitude
// argumento vet = <ang1, ang2, ang3> - ângulos de Euler
// Rotação X-Y-Z 
#macro rotacxyz (vet) // macro para efetuar uma rotação de atitude xyz (ângulos em graus)
  rotate vet.z*z
  rotate vet.y*y
  rotate vet.x*x
#end
// Rotação Z-X-Z
#macro rotaczxz (vet) // macro para efetuar uma rotação de atitude zxz (ângulos em graus)
  rotate vet.z*z
  rotate vet.y*x
  rotate vet.x*z
#end
//------------------------------------------------------------------------

camera{Camera_1}

//------------------------------------------------------------------------
//------------------------------------------------------------------------
// macros

#macro eixo_1 (comp, rade)
    union {
        cylinder { <0, 0, 0>, <0, 0, comp>, rade }
        cone { <0, 0, comp>, 0.03, <0, 0, comp+0.1>, 0.0 }
    }
#end

#macro eixo_2 (veco, rade)
    #declare veno = vnormalize(veco);
    #if (vdot(veno, veno) != 0)
        union {
            cylinder { <0, 0, 0>, veco, rade }
            cone { veco, 0.03, veco + 0.1*vnormalize(veco), 0.0 }
        }
    #end
#end
//------------------------------------------------------------------------
// Leitura do arquivo contendo as informações da atitude

#declare myfile = "propov.txt" // nome do arquivo (deve estar no mesmo diretório do script de pov)
#fopen MecFile myfile read
#read(MecFile, tstep, tend)

// #declare tstep = 1/15;
// #declare tend = 0.2;
#declare ntimes = int(tend/tstep + 0.0001);  // número de medidas da atitude

#declare time = clock*tend;
#declare indi = int(clock*ntimes + 0.0001);                           

// #warning concat(str(indi,10,3),"\n")

// há dois problemas: aparentemente a órbita está inclinada de 82 graus ao invés de 98
// aparentemente o satélite passa exatamente sobre o pólo norte ao invés de deslocado de 8 graus.

#declare tsim = -0.00001;
//#declare time = 1470;

#while (tsim < time)
  #read(MecFile, tsim, vecatt, vecbst, vectar, vecine) 
#end

//#warning concat("Value is:",str(tsim,7,0),"\n")

#declare tsim = tsim - 10;
#declare hour = int(tsim/3600);
#declare minu = int(tsim/60) - 60*hour;
#declare segu = tsim - 3600*hour - 60*minu;
#declare myst = concat(str(hour, -2, 0), ":", str(minu, -2, 0), ":", str(segu, -2, 0));

#warning concat("Value is:",myst,"\n")

//------------------------------------------------------------------------
// sun
#declare sun_iner = <1369.453 562.396 243.809>;
#declare rt_frame = <180, 0, 0>;

//cylinder { <0., 0., 0.> sun_iner, 10 material {b_yellow}         
//      rotate rt_frame
//       rotacxyz(vecine)
//}

light_source{sun_iner  color <1, 1, 1>  parallel
       rotate rt_frame
       rotacxyz(vecine)
  rotate 90*x
}
//------------------------------------------------------------------------

object {
//  text { ttf "digital.ttf", myst 0.001, 0 }
  text { ttf "ocraext.ttf", myst 0.001, 0 }
  rotate <0, 0, -90>  scale 0.02
  material { led }
  //translate .2*x
  rotate 30*y rotate -45*x 
  translate <2.18, 2.48, 2.52>
}

//declare vecatt = <0, 0, 0>;

//#declare vecatt = arratt[indi];     // atitude do instante atual
//------------------------------------------------------------------------
#declare cubo = union {
   difference {
     box { <-1., -1., -1.>   < 1.,  1.,  1.>  }
     plane { x, -0.5     material { b_red }  }  
     plane {-x, -0.5     material { b_red }  }
     plane { y, -0.5     material { b_green }  }  
     plane {-y, -0.5     material { b_green }  }
     plane { z, -0.5     material { b_blue } }  
     plane {-z, -0.5     material { b_blue } }
   }

   cylinder { <-0.48, 0.48, 0.48> <-1, 1, 1>, 0.03 material {b_yellow} }
   cylinder { <-0.48, -0.48, 0.48> <-1, -1, 1>, 0.03 material {b_yellow} }
   cylinder { <-0.48, 0.48, -0.48> <-1, 1, -1>, 0.03 material {b_yellow} }
   cylinder { <-0.48, -0.48, -0.48> <-1, -1, -1>, 0.03 material {b_yellow} }
   no_shadow
}
//------------------------------------------------------------------------

#declare comp = 0.6;    // comprimento do eixo
#declare rade = 0.01;   // raio do eixo

//#declare eixo_ = union {
//  cylinder { <0, 0, 0>, <0, 0, comp>, rade }
//  cone { 
//  <0, 0, comp>, 0.03, <0, 0, comp+0.1>, 0.0
//  }
//}



#declare eixos = union { 
  object { eixo_1(comp, rade)
    material { PDB_blue }
  }
  object { eixo_1(comp, rade)
    material { PDB_blue }
    rotate -90.0*x
    material { PDB_green }
  }
  object { eixo_1(comp, rade)
    material { PDB_blue }
    rotate 90.0*y
    material { PDB_red }
  }
  no_shadow
}


//#declare myobject = box { <-0.5, -0.5, -0.5>, < 0.5, 0.5, 0.5> 
//        scale <1, 1, 1>*0.4
//        material { PDB_Tex_CG2  }
//  }

union {
    //object { myobject
    object { cubo scale .4
        
    }

    object { eixos  }
    rotacxyz(vecatt)
}

object { eixos }

#declare rt = 6378.155/100;
#declare h  = 630./100;

//------------------------------------------------------------------
// Terra 
#declare tetp = 4.178075e-3;

object {  // Terra
  sphere { <0, 0, 0> rt 
  texture { 
    pigment {
        image_map {
            jpeg "land_ocean_ice_cloud_2048.jpg"
            map_type 1
        }
        scale <-1, 1, 1>    
    }
   finish { ambient 0.001 diffuse 0.8 specular 0.01 }
   //finish { ambient 1 diffuse 0 specular 0.01 }
  //PDB_Tex_CG2 scale 10
  }
  scale 1
  rotate tetp*tsim*y 
  rotate rt_frame
  rotacxyz(vecine)
  rotate 90*x
  translate -(rt+h)*x
  }
}

//------------------------------------------------------------------
// Atmosfera 

#declare atmo = 0;

# if (atmo = 0)
object {  // Atmosfera
    sphere { <0, 0, 0> 1 hollow on }
   
    texture { pigment { color rgbt <0, 0, 0, 1> } finish {ambient 0 diffuse 0} } // end of texture 

    interior {
        media {    // atmospheric media sample
           intervals 5
           scattering { 1, color <0.2, 0.5, 0.9>  }
           samples 1, 1
           confidence 0.9999
           variance 1/100
           ratio 0.9
           density { spherical density_map { [0  color <0.0, 0.0, 0.0>] [.10  color <0.2, 0.5, 0.9>] [.11  color <0., 0., 0.>] [1  color <0, 0, 0>]} }
        }
    }
   scale rt + 0.5 
   translate -(rt+h)*x
  // translate etc.
}
#end

//------------------------------------------------------------------
// campo magnético 

object { eixo_2(vecbst*0.02, rade)
    texture { pigment { color rgb <.4, .5, .7> } finish {ambient .3 diffuse .5 specular 0.7266 roughness 0.006139} }
    scale 0.5
    translate <.6, .6, 0>
    no_shadow
}

//------------------------------------------------------------------
// Torque de controle 
object { eixo_2(vectar*0.002, rade)
    texture { pigment { color rgb <.8, .3, .2> } finish {ambient .3 diffuse .5 specular 0.7266 roughness 0.006139} }
    scale 0.5
    translate <.6, .6, 0>
    no_shadow
}

/*
object { 
    cylinder { <0, 0, 0> <0, 80, 0>, 1 material {b_yellow} }
  rotate tetp*tsim*y 
  rotate rt_frame
  rotacxyz(vecine)
  rotate 90*x
   translate -(rt+h)*x
}
*/
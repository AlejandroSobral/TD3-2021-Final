SECTIONS
{

    .init16 0xFFFF0000 : /*VMA*/
        AT( 0xFFFF0000)  /*LMA*/
        {
            *(.init16);     /*Secciones de entrada*/
            *(.entry);      /*It's ok to put my section here?*/

        }
    .init32 0xFFFF4000 : /*VMA*/
        AT( 0xFFFF4000)
        {
            *(.init32);
        }

    .reset 0xFFFFFFF0 :
            AT( 0xFFFFFFF0)
        {
            *(.reset);
        }
}
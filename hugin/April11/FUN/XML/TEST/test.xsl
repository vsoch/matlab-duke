<xsl:stylesheet xmlns:ssl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:strip-space elements="*"/>
<xslutput method="text"/>

<xsl:template match="/">
<xsl:apply-templates select="bxh"/>
</xsl:template>

<xsl:template match="bxh">
<xsl:apply-templates select="datarec"/>
<xsl:apply-templates select="acquisitiondata"/>
<xsl:apply-templates select="subject"/>
<xsl:apply-templates select="history"/>
</xsl:template>


<xsl:template match="datarec">
    <xsl:text>Dimensions</xsl:text>
    <xsl:apply-templates select="dimension"/>
    <xsl:text>YDim:</xsl:text>
</xsl:template>
    
   
<xsl:template match="dimension">
    <xsl:text>Name:</xsl:text>
    <xsl:value-of select="bxh/datarec/dimension/@type"/>
    <xsl:text>,Units:</xsl:text>
    <xsl:value-of select="units"/>
    <xsl:text>,Size:</xsl:text>
    <xsl:value-of select="size"/>
    <xsl:text>,Origin:</xsl:text>
    <xsl:value-of select="origin"/>
    <xsl:text>,Gap</xsl:text>
    <xsl:value-of select="gap"/>
    <xsl:text>,Spacing:</xsl:text>
    <xsl:value-of select="spacing"/>
    <xsl:text>,Direction:</xsl:text>
    <xsl:value-of select="direction"/>
</xsl:template>

<xsl:template match="acquisitiondata">
    <xsl:text>Exam Number:</xsl:text>
    <xsl:value-of select="examnumber"/>
    <xsl:text>,Study ID:</xsl:text>
    <xsl:value-of select="studyid"/>
    <xsl:text>,Description:</xsl:text>
    <xsl:value-of select="description"/>
</xsl:template>

<xsl:template match="subjectdata">
    <xsl:text>DNS ID</xsl:text>
    <xsl:value-of select="name"/>
    <xsl:text>,Weight:</xsl:text>
    <xsl:value-of select="weight"/>
</xsl:template>

<xsl:template match="history">
    <xsl:text>Date:</xsl:text>
    <xsl:value-of select="entry/date"/>
</xsl:template>

</xsl:stylesheet>

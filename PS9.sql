/*****************************************************************************************
Purpose	: HCIT PS9 ORDER VC VIEW
Author	: Wen Zhu
Date	: 16/04/2016
Note	: To keep the view as similar to the table without changing the destination table, 
		  we're going to have a lot of alias for it
*****************************************************************************************/
Alter View [IDL].[vwIDLTransactionsHCITOrdersVC]
As
Select 
		107 As DataSrcId
	,	Replace(LTrim(RTrim(finL.ord_no)),Char(10),'')ord_no
	,	Replace(LTrim(RTrim(finL.ord_lin_no)),Char(10),'')order_line_no
	,	detL.sales_rep_nm
	,	detL.sales_rep_no
	,	prdL.prod_id As item
	,	prdL.prod_desc As item_desc
	,	prdl.psi_modality
	,	prdl.prod_desc As psi_long_desc
	,	detL.ord_status
	,	regDim.Levl7_Key As sales_area_cd
	,	regDim.Levl7_Key As ord_area_cd
	,	modDim.LEVL4_KEY As Child_Modality
	,	modDim.Globl_SEGMNT5_Desc As Local_Modality_Desc
	,	modDim.globl_segmnt5_key As L6_GPH_modality_desc
	,	modDim.LEVL4_DESC As A_lvl_modality_desc
	,	detL.trans_typ
	,	modDim.GLOBL_SEGMNT5_KEY As Glb_Modality
	,	acctDim.LEVL8_KEY As e_lvl_acct
	,	orgDim.LEVL7_KEY As j_lvl_org
	,	regdim.LEVL4_KEY As l_lvl_rgn
	,	orgDim.LEVL3_KEY As r_lvl_org
	,	cmpDim.globl_segmnt1_key As glb_company
	,	chDim.LEVL5_KEY As g_lvl_chnl
	,	chDim.LEVL4_KEY As J_lvl_chnl
	,	chDim.LEVL3_KEY As l_lvl_chnl
	,	custL.ShipToCustomerNo As ship_to_cust_no
	,	custL.ShipToLocationNo As ship_to_loc_id
	,	custL.BillToCustomerNo As bill_to_cust_no
	,	custL.BillToLocationNo As bill_to_loc_id
	,	custL.sold_to_cust_no As Cust_no
	,	finL.ProcessDate As Process_Dt
	,	finL.process_dt_fm
	,	acctDim.LEVL7_KEY As g_lvl_acct
	,	finL.item_qty
	,	0 As NEOVT
	,	0 As NSOVT
	,	finL.usd_mor_amt As neov_mor_usd_amt
	,	finL.ext_list_price_usd_mor_amt
	,	finL.discount_usd_mor_amt
	,	acctDim.LEVL9_KEY As c_lvl_acct
	,	chDim.LEVL6_KEY As e_lvl_chnl
	,	finL.period
	,	finL.acct_dt As ord_accpt_dt
	,	prdL.TransactionRegionId
	,	'ORD' ElementType
	,	finL.OED
	,	detL.src_idn As IDLDataSrcID
	,	prdL.LevelId
	,	detL.c_lvl_net_incm_desc
	,	detL.inside_sales_rep_no
	,	detL.mic_sales_rep_no
	,	finL.contract_no
	,	detL.contract_desc As contract_header_desc
	,	detL.contract_type
	,	detL.contract_status
	,	Cast(contract_sign_dt As DATE) contract_sign_dt
	,	detL.contract_lin_no
	,	detL.contract_lin_desc
	,	finL.vc_usd_mor_rev_amt
	,	finL.EDRUpdateTS As idl_upd_ts
	,	finL.transaction_id
	,	custL.ship_to_zipcode
	,	custL.ShipToUCM
	,	custL.BillToUCM
	,	custL.CustomerUCM
	,	custL.bill_to_country As BillToCountry
	,	custL.ship_to_addr_seq_no As ShipToAddrSeq
	,	IsNull(vc_usd_mor_rev_amt * -1 ,0) As TransactionAmt
From IDL.HCIT_PS9_ORD_FINANCE_L finL
	Inner Join IDL.HCIT_PS9_ORD_PRODUCT_L prdL
		On finL.transaction_id = prdL.transaction_id
		And finL.period = prdL.period
	Inner Join IDL.HCIT_PS9_ORD_DETAIL_L detL
		On finL.transaction_id = detL.transaction_id
		And finL.period = detL.period
	Inner Join IDL.HCIT_PS9_ORD_CUST_L custL
		On finL.transaction_id = custL.transaction_id
		And finL.period = custL.period
	Inner Join IDL.GLOBAL_SEGMENT5_MODALITY_DIM modDim
		On prdL.glb_modality_idn = moddim.GLOBL_SEGMNT5_IDN
	Inner Join IDL.GLOBAL_SEGMENT2_ACCOUNT_DIM acctDim
		On prdL.glb_acct_idn = acctDim.GLOBL_SEGMNT2_IDN
	Inner Join IDL.GLOBAL_SEGMENT12_ORG_DIM orgDim
		On prdL.glb_org_idn = orgDim.GLOBL_SEGMNT12_IDN
	Inner Join IDL.GLOBAL_SEGMENT10_REGION_DIM regdim
		On prdL.glb_region_idn = regdim.GLOBL_SEGMNT10_IDN
	Inner Join IDL.GLOBAL_SEGMENT1_COMPANY_DIM cmpDim
		On prdL.glb_company_idn = cmpDim.GLOBL_SEGMNT1_IDN
	Inner Join IDL.GLOBAL_SEGMENT11_CHANNEL_DIM chDim
		On prdL.glb_channel_idn = chDim.GLOBL_SEGMNT11_IDN
	--Inner Join IDL.GLOBAL_SEGMENT5_MODALITY_DIM lclDim
	--	On prdL.local_modality = lclDim.GLOBL_SEGMNT5_ID
Where
	Not Exists
	(
		Select Distinct d.trans_typ 
		From IDL.HCIT_PS9_ORD_DETAIL_L d 
		Where
			d.src_idn=130 
			And Cast(d.cntrl_typ_idn As DECIMAL(15,0))= 4 
			And d.atrbt_3='Y'
			And prdL.transaction_id = d.transaction_id
			And prdl.period = d.period
	)
	And finL.LEVEL_5  = 'J52100000'
	And finl.LEVEL_6  <>  'G52102000'
	And finl.LEVEL_7  <>  'E52101030'
	And ((modDim.LEVL3_KEY='MO_C03' And orgDim.LEVL3_KEY='OR_R83000') Or orgDim.LEVL3_KEY = 'OR_R85000') 
	And modDim.GLOBL_SEGMNT5_KEY Not In ('MO_930','MO_996','MO_576','MO_757')	
	And IsNull(prdL.TransactionRegionId,0)<>69
Go



clear
% prefix = 'G:\';

% set(0, 'defaultfigurewindowstyle', 'docked')
addpath('C:\Users\dtf8829\Documents\MATLAB\eeglab2023.0')
addpath("C:\Users\dtf8829\Documents\GitHub\SheffieldAutismBiomarkers")
addpath("C:\Users\dtf8829\Documents\GitHub\myFrequentUse")
% addpath(genpath('C:\Users\dtf8829\Documents\MATLAB\fieldtrip-20221223'))
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;


ERP_path = 'R:\MSS\Johnson_Lab\dtf8829\estimDat\Zach\air_ERP_test_20230309_125152_seg_ave_new.mff';
subName = 'Zach'; 
load('R:\MSS\Johnson_Lab\dtf8829\estimDat\Zachsum1.mat')

ERP = pop_mffimport({ERP_path},{'code'},0,0);

newERPDat = summaryDat.cDat.upPeriodic;


ERP.data = newERPDat; 

ERP.event(2).mffkey_subj = subName;
ERP.event(2).mffkeys = ['[#seg: 16, subj: ' subName ', FILE: air_ERP_test_20230309_125152_seg.mff]'];
ERP.etc.subject = []; 
ERP.event(2).mffkeysbackup = char("struct('code',{'#seg','subj','FILE'},'data',{'16','Zach','air_ERP_test_20230309_125152_seg.mff'},'datatype',{'long','person','fileReference'},'description',{'','',''})");
pop_mffexport(ERP, ['R:\MSS\Johnson_Lab\dtf8829\estimDat\Zach\\zachERP2.mff']);
